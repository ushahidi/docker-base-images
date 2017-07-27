#!/bin/bash

if [ -z "$1" ]; then
	exec /bin/bash   # If no parameters given, drop to a shell
else
	exec "$@"      # Execute parameters given
fi