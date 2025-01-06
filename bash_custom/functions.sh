get_bearer_rules() {
	mkdir -p ~/bash_custom/bearer
	{
		git clone https://github.com/Bearer/bearer-rules.git ~/bash_custom/bearer 2>/dev/null
	} || {
		echo "bearer-rules likely already exists. git pull it if you want to update"
	}
}

bearer_offline() {
	bearer scan --disable-default-rules --external-rule-dir=~/bearer/bearer-rules/rules $1
}

get_semgrep_rules() {
	mkdir -p ~/bash_custom/semgrep
	{
		curl https://semgrep.dev/c/p/default > ~/bash_custom/semgrep/default.yml
	} || {
		echo "error getting semgrep rules"
	}
}

semgrep_offline() {
	semgrep --config ~/.semgrep/default.yml --disable-version-check --metrics off $1
}


dvi() {
	docker run -it -v $HOME/.docker.rc/:/docker.rc -v $(pwd):/code "$@" /bin/bash /docker.rc/start.sh
}

d() {
	docker run -it -v $(pwd):/code "$@" /bin/bash
}

dvin() {
	docker run -it -p 18080:8080 -v $HOME/.docker.rc/:/docker.rc -v $(pwd):/code "$@" /bin/bash /docker.rc/start.sh
}

dsl() {
	docker exec -it `docker ps -n 1 -q` /bin/bash
}

swaggerui() {
	docker run -p 8090:8080 -e SWAGGER_JSON=/app/openapi.json -v $1:/app/openapi.json swaggerapi/swagger-ui
}

j2y() {
	yq -oy $1
}
