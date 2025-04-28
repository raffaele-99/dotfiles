function dri
	# docker run interactive
	docker run --entrypoint "/bin/bash" -it -v $(pwd):/code $argv
end
