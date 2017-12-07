#!/bin/bash

# Wrapper for dockerize (github.com/jwilder/dockerize)
#
# DOCKERIZE_TEMPLATE_DIR : this directory wil be searched for files to pass
#   as templates to dockerize. The destination path is determined from the
#   template path inside the directory, thus:
#
#     $DOCKERIZE_TEMPLATE_DIR/etc/config.file -> /etc/config.file
#
#   the wrapper will attempt to create the destination folder if it doesn't
#   exist
#
# DOCKERIZE_WAIT_* : the values of any environment variables with names
#   matching this pattern will be passed as -wait options to dockerize.
#   i.e. DOCKERIZE_WAIT_MYSQL=tcp://mysql:3306
#

set -e

_template_args=()
_wait_args=()

# find templates
set_template_args() {
  local template dest dest_dir j ;
  if [ ! -d ${DOCKERIZE_TEMPLATE_DIR} ]; then
    return 0;
  fi
  while IFS= read -u9 -r -d $'\0' template; do
    dest=${template##$DOCKERIZE_TEMPLATE_DIR}
    dest_dir=`dirname "$dest"`
    echo "[dockerize] Using template: $template -> $dest" >&2
    if [ ! -d "$dest_dir" ]; then
      echo "[dockerize] .. creating destination directory $dest_dir" >&2
      mkdir -p "$dest_dir"
    fi
    # add execution arguments
    _template_args[j++]="-template"
    _template_args[j++]="$template:$dest"
  done 9< <(find ${DOCKERIZE_TEMPLATE_DIR} -type f -print0)
}

set_wait_args() {
  local name value j
  while IFS='=' read -u9 -r name value; do
    if [[ $name == 'DOCKERIZE_WAIT_'* ]]; then
      echo "[dockerize] Adding wait for $value"
      _wait_args[j++]="-wait"
      _wait_args[j++]=$value
    fi
  done 9< <(env)
}

set_template_args
set_wait_args

echo "[dockerize] Executing: " dockerize -timeout ${DOCKERIZE_TIMEOUT:-30s} ${_template_args[@]} ${_wait_args[@]}
/usr/local/bin/dockerize -timeout ${DOCKERIZE_TIMEOUT:-30s} ${_template_args[@]} ${_wait_args[@]} || exit 1

exec "$@"
