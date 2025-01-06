#!/bin/bash

# TODO: fix the whole thing

# script-specific vars
ARGC=$#
PROJ_NAME=$1
PROJ_ROOT=$HOME/projects/$PROJ_NAME/$(date +"%Y")
HOSTS_DIR=$PROJ_ROOT"/hosts"
HOST_PORTS_FILE=$HOSTS_DIR/host-ports.txt
IP_ADDRESSES=()
PORTS=100
VERBOSE=0

usage() {
    echo "Usage: $0 <project-name> -i <ip_list> [-p <top_ports>] [-s <shodan_API_key>] [-v]"
    echo "Runs default nmap TCP scans on an IP list, then saves the output to a specified project folder."
    echo ""
    echo "Options:"
    echo "  -i      Path to the file containing the list of IPs to scan. (Required)"
    echo "  -p      Number of ports to scan. Defaults to 100 if not specified."
    echo "  -s      Perform a Shodan search for each IP. Requires Shodan API key."
    echo "  -v      Enable verbose output. Use this if you want to see where the full results are saved."
    exit 1
}

debug_message() {
    if [ $VERBOSE -eq 1 ]; then
	echo $1
    fi
}

parse_args() {
    if [ -z "$1" ]; then
        usage
    else
        PROJ_NAME=$1
        shift
    fi

    while getopts "i:p:s:v" opt; do
        case $opt in
            i)
                IPS_TXT=$OPTARG
                ;;
            p)
                PORTS=$OPTARG
                ;;
	    s)
		SHODAN_KEY=$OPTARG
		;;
	    v)
		VERBOSE=1
		;;
            \?)
                usage
                ;;
        esac
    done

    shift $((OPTIND - 1))

    if [ -z "$IPS_TXT" ]; then
        usage
    fi
}

get_ips() {
    local file=$1
    if [[ -f "$file" ]]; then
        while IFS= read -r ip; do
            if is_valid_ip "$ip"; then
                IP_ADDRESSES+=("$ip")
            else
                debug_message "[!] Skipping invalid IP address: $ip"
            fi
        done < "$file"
    else
        echo "[!] The IP list provided does not exist. Aborting."
        exit 1
    fi
}

is_valid_ip() {
    local ip=$1
    local valid_ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if [[ $ip =~ $valid_ip_regex ]]; then
        return 0
    else
        return 1
    fi
}

scan_ip() {
    [ ! -d "$HOSTS_DIR/$1/nmap" ] && debug_message "[i] Creating directory $HOSTS_DIR/$1/nmap"
    mkdir -p "$HOSTS_DIR/$1/nmap"
    {
        sudo nmap -Pn -T4 $1 --top-ports $PORTS -v0 -oX "$HOSTS_DIR/$1/nmap/top-$PORTS.xml" &&
        nmap-parse-output "$HOSTS_DIR/$1/nmap/top-$PORTS.xml" host-ports >> "$HOSTS_DIR/$1/nmap/top-$PORTS.txt"
        debug_message "[i] Nmap results saved at $HOSTS_DIR/$1/nmap/top-$PORTS.xml and .txt"
    } || {
        echo "[i] Something went wrong with the nmap scan for $1. It will be skipped."
    }
}

combine_nmap_results() {
    for ip in "${IP_ADDRESSES[@]}"; do
        cat "$HOSTS_DIR/$ip/nmap/top-$PORTS.txt" >> "$HOST_PORTS_FILE.tmp"
    done
    sort "$HOST_PORTS_FILE.tmp" | uniq > $HOST_PORTS_FILE
    rm "$HOST_PORTS_FILE.tmp"
}

search_shodan() {
    {
        curl -s --location "https://api.shodan.io/shodan/host/$1?key=$SHODAN_KEY" > "$HOSTS_DIR/$1/shodan.json" &&
        debug_message "[i] JSON file saved at $HOSTS_DIR/$1/shodan.json"
    } || {
        echo "[!] Something went wrong with the Shodan search for $1. It will be skipped."
    }
}

read_shodan() {
    jq --color-output -r '. | "domains: \(.domains[])\nhostnames: \(.hostnames[])\nports: \(.ports)"' $HOSTS_DIR/$1/shodan.json 2>/dev/null ||
    jq --color-output . $HOSTS_DIR/$1/shodan.json 2>/dev/null
}

output_results() {
    echo ""
    echo "--- results ---"

    echo ""
    echo "Nmap:"
    if [ -s $HOST_PORTS_FILE ]; then
        cat $HOST_PORTS_FILE
    else
        echo "Nmap scans show no ports open across all hosts."
    fi

    echo ""
    echo "Shodan:"
    for ip in "${IP_ADDRESSES}"; do
        echo $ip
        read_shodan $ip
    done

}

# prepare
parse_args "$@"
get_ips "$IPS_TXT"

# scan
for ip in "${IP_ADDRESSES[@]}"; do
    scan_ip $ip
    if [ ! -z "$SHODAN_KEY" ]; then
        search_shodan $ip
    fi
done

# parse
combine_nmap_results

# print
output_results
