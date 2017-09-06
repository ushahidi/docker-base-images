#!/bin/bash

start() {
	# Start the chaperone process
	if [[ $UID -eq 0 || $EUID -eq 0 ]]; then
		# root
		exec chaperone --debug
	else
		# non-root
		exec chaperone --force
	fi
}

if [ -z "$1" ]; then
	exec /bin/bash   # If no parameters given, drop to a shell
elif [ "$1" == "start" ]; then
	start "$@"
else
	exec "$@"      # Execute parameters given
fi