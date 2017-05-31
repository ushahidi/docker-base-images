#!/bin/bash

set -e

if [ -z `which dgoss` ]; then
	echo "Install dgoss in your local system"
fi

action="$1"
dir="$2"

cd $dir

if [ -d tests ]; then
	vols_clause="-v `pwd`/tests:/tests"
else
	vols_clause=""
fi

docker build -t goss_tested .

case "$1" in
	edit)
		dgoss edit ${vols_clause} goss_tested sleep infinity
		;;
	run|test)
		dgoss run ${vols_clause} goss_tested sleep infinity
		;;
	*)
		echo "Need edit|run"
		exit 1;
esac
