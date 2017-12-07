#!/bin/bash

# Cascading Entrypoint Scripts allows to easily compose multiple Dockerfile
# entrypoint scripts. This is useful as several docker images are layered
# on top of each other.

# The entrypoint scripts usually deal with container inisialisation and
# parsing / processing of the container command and arguments.

# In order for entrypoints scripts to be cascadeable, they should finish their
# execution with something functionally similar to `exec "$@"`

# There are two ways to invoke this script: management mode and entrypoint mode
# Management mode is used in Dockerfiles to add entrypoints and tweak container
# initialisation behavior. Entrypoint mode is executed on container start and
# carries off the programmed initialisation sequence

# This utility requires bash

_print_debug() {
  [ -n "$DOCKERCES_DEBUG" ] && echo "[CES]" "$@" >&2 || true;
}
_warning() { echo "[CES]" "WARNING:" "$@" >&2 ; }
_fatal() {
  local exit_code=$1
  shift
  echo "[CES]" "FATAL:" "$@" >&2
  exit $exit_code
}

manage() {
  _print_debug "Management command: " "$@"
  case "$1" in
    add)
      # Appends entrypoint to the execution list
      # Check the entrypoint is readable and executable
      if [[ ! ( -r $2 ) || ! ( -x $2 ) ]]; then
        _fatal 2 "Entrypoint script $2 must be readable AND executable"
      fi
      # Adds the entrypoint chain link to the file. Aside from the script file,
      # this can include any additional optional arguments to make the script
      # behave in a cascadeable way
      echo "${@:2}" >> $DOCKERCES_ENTRYPOINT_CHAIN
      _print_debug "Added ""${@:2}"" to execution chain"
      ;;
    endpoint)
      # Sets the endpoint of the chain. There can only be one endpoint and
      # it's always executed at the end of the chain. Thus, it doesn't need
      # to be cascadeable.
      # An endpoint is optional, without an endpoint, the entrypoint chain
      # ends in the equivalent of `exec "$@"`
      _print_debug "Setting endpoint to '""${@:2}""'"
      # Check the endpoint is readable and executable
      if [[ ! ( -r $2 ) || ! ( -x $2 ) ]]; then
        _fatal 2 "Endpoint $2 must be readable AND executable"
      fi
      echo "${@:2}" > $DOCKERCES_ENDPOINT_FILE
      ;;
    *)
      _fatal 1 "Unknown CES management command: $1"
      ;;
  esac
}

entrypoint() {
  if [ $$ -ne 1 ]; then
    _warning "not running as PID 1, things may not work as intended"
  else
    _print_debug "Container starting. CES running as entrypoint"
  fi

  # Create entrypoint chain from file
  local _chain=()
  local _endpoint=()
  _print_debug "Building entrypoint chain from ${DOCKERCES_ENTRYPOINT_CHAIN}"
  while read -u9 -r -d $'\n' script; do
    # add each script in the entrypoint list to the chain
    _print_debug "... adding $script"
    _chain+=($script)
  done 9< ${DOCKERCES_ENTRYPOINT_CHAIN}
  # Check if there's an endpoint set and load it
  if [ -f "$DOCKERCES_ENDPOINT_FILE" ]; then
    read -a _endpoint -r < ${DOCKERCES_ENDPOINT_FILE}
    if [ -n "${_endpoint[@]}" ]; then
      _print_debug "... with endpoint: ${_endpoint[@]}"
    fi
  fi
  _print_debug "... and user supplied command: " "$@"
  _print_debug "Executing: " "${_chain[@]}" "${_endpoint[@]}" "$@"
  exec "${_chain[@]}" "${_endpoint[@]}" "$@"
}


## Main execution routine, check how we were invoked
case "$0" in
  $DOCKERCES_MANAGE_UTIL)
    manage "$@"     # management mode
    ;;
  *)
    entrypoint "$@" # entrypoint mode
    ;;
esac
