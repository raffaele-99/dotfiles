function drvi
	# docker run verbose interactive
	# still need to remember how to use this one
	docker run -it -v $HOME/.docker.rc/:/docker.rc -v $(pwd):/code $argv /bin/bash /docker.rc/start.sh
end
