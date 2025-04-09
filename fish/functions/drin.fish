function drin
	# docker run interactive network
	docker run -it -p 18080:8080 -v $(pwd):/code $argv /bin/bash
end
