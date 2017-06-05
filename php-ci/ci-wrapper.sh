#!/bin/bash

if [[ "$CI_NAME" == "codeship" || -n "$CI_TIMESTAMP" ]]; then

	# Perform variable substitution on parameters
	#   i.e. if we get a parameter myvar="$CI_BRANCH" we substitute $CI_BRANCH for
	#        its actual value in the environment, and get i.e. myvar="master"
	args=()
	for p in $@; do
	    args+=(`printf '%s\n' $p | envsubst`)
	done
	set -- "${args[@]}"

	# Parse environment assignations from arguments
	while true; do
		if [[ "$1" =~ ^[^=]+=.*$ ]]; then
			echo "+ ${1%%=*} <- ${1#*=}"
			export ${1%%=*}=${1#*=}
			shift
			continue
		fi
		break
	done
fi

if [ -z "$1" ]; then
	exec /bin/bash   # If no parameters given, drop to a shell
else
	exec "$@"      # Execute parameters given
fi