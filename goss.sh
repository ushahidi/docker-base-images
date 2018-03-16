#!/bin/bash

set -e

if [ -z `which dgoss` ]; then
	echo "Install dgoss in your local system"
fi

action="$1"
basedir="$2"
versiondir="$3"

cd $basedir

docker build -t goss_tested -f ${versiondir}/Dockerfile .

case "$1" in
	edit)
		cd ${versiondir}
		dgoss edit ${vols_clause} goss_tested sleep infinity
		;;
	run|test)
	  cd ${versiondir}
		dgoss run ${vols_clause} goss_tested sleep infinity
		;;
	*)
		echo "Need edit|run"
		exit 1;
esac
