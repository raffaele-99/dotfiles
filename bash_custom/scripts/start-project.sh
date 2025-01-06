#!/bin/bash

PROJ_ROOT=$HOME/projects/$1/$(date +"%Y")
NOTES_DIR=$PROJ_ROOT"/notes"
HOSTS_DIR=$PROJ_ROOT"/hosts"
SITES_DIR=$PROJ_ROOT"/sites"

create_directories_from_ips() {
    local FILE=$1
    if [[ -f "$FILE" ]]; then
        while IFS= read -r ip; do
	    echo "[i] Created directory $HOSTS_DIR/$ip"
            mkdir -p "$HOSTS_DIR/$ip"
        done < "$FILE"
        echo "[i] Directories created successfully."
	cp $1 "$HOSTS_DIR/ips.txt"
	echo "[i] Copied $1 to $HOSTS_DIR/ips.txt"
    else
	$(cat $FILE)
        echo "[!] Could not find file at $1. Skipping directory creation for now..."
    fi
}

create_directories_from_domains() {
    local FILE=$1
    if [[ -f "$FILE" ]]; then
        while IFS= read -r domain; do
            echo "[i] Created directory $SITES_DIR/$domain"
            mkdir -p "$SITES_DIR/$domain"
        done < "$FILE"
        echo "[i] Directories created successfully."
	cp $1 "$SITES_DIR/domains.txt"
	echo "[i] Copied $1 to $SITES_DIR/domains.txt"
    else
        $(cat $FILE)
        echo "[!] Could not find file at $1. Skipping directory creation for now..."
    fi
}


if [ $# -eq 0 ]
    then
        echo '[!] Usage: '$(basename $(readlink -nf $0))' <project_name>'
        exit 1
fi

echo "[i] Creating directories for new project: $1"

if [ -d $PROJ_ROOT ]
    then
        echo "[!] Error: Project with name '$1' already exists."
	echo "[x] Exiting"
        exit 1
    else
        mkdir -p $PROJ_ROOT
fi

## check if directory was made successfully.
if [ -d $PROJ_ROOT ]
    then
        echo "[i] Directories created successfully."
fi

## do we have any IPs?
read -p "[?] Do you have an IP list prepared? (Y/N): " HAS_IPS

if [[ "$HAS_IPS" = "Y" ]]; then
    read -p "[?] What's the filepath of the IP list? Enter it here: " IPLIST_LOCATION
    create_directories_from_ips "$IPLIST_LOCATION"
else
    echo "[i] Skipping creation of hosts folders."
fi

## what about sites?
read -p "[?] Do you have a domains list prepared? (Y/N): " HAS_DOMAINS

if [[ "$HAS_DOMAINS" = "Y" ]]; then
    read -p "[?] What's the filepath of the domain list? Enter it here: " DOMAINS_LOCATION
    create_directories_from_domains "$DOMAINS_LOCATION"
else
    echo "[i] Skipping creation of sites folders."
fi

# taking notes?
read -p "[?] Do you want a notes directory? (Y/N): " WANTS_NOTES

if [[ "$WANTS_NOTES" = "Y" ]]; then
    mkdir -p $NOTES_DIR
    echo "[i] Created directory $NOTES_DIR"
else
    echo "[i] Skipping creation of notes folder."
fi


echo "[] All project directories created."

echo "[i] Looks like:"

tree $PROJ_ROOT
