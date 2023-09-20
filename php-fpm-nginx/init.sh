#!/bin/bash

if [ $$ -ne 1 ]; then
	echo "init.sh -- FAIL: WHY AM I NOT PID 1??"
	exit 1
fi

php_config() {
	sed -E -i -e \
	  "s/^;?[[:space:]]*max_execution_time[[:space:]]*=.*$/max_execution_time = ${PHP_EXEC_TIME_LIMIT}/" \
		/etc/php/${PHP_MAJOR_VERSION}/fpm/php.ini
}

start() {
	# DEPRECATED FOR php-ush con.d file
	# php_config
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
