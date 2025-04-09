function dsl
	# docker start last
	# retrieves container id of most recently-created container then starts a shell inside it
	docker exec -it $(docker ps -n 1 -q) /bin/bash
end
