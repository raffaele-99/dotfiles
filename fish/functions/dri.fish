function dri
	# docker run interactive
	docker run -it -v $(pwd):/code $argv /bin/bash
end
