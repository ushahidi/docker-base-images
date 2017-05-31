#!/bin/sh

export NPM_CONFIG_PROGRESS=false

npm install --silent "$@" > /dev/null 2>&1 || \
    {
    	if [ -f npm-debug.log ]; then
    		tail -n 1000 npm-debug.log ;
    	else
    		echo "!! npm-debug.log not available"
    	fi
    	false ;
	}
