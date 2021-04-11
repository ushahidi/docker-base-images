#!/bin/bash

# These are assuming xdebug 3.x

# defaults
XDEBUG_MODE=${XDEBUG_MODE:-debug}
XDEBUG_START_WITH_REQUEST=${XDEBUG_START_WITH_REQUEST:-yes}
XDEBUG_CLIENT_PORT=${XDEBUG_CLIENT_PORT:-9000}


{
  cat <<EOF
xdebug.mode=${XDEBUG_MODE}
xdebug.start_with_request=${XDEBUG_START_WITH_REQUEST}
xdebug.client_port=${XDEBUG_CLIENT_PORT}
EOF

  # i.e. XDEBUG_DISCOVER_CLIENT_HOST=yes
  if [ -n "${XDEBUG_DISCOVER_CLIENT_HOST}" ]; then cat <<EOF
xdebug.discover_client_host=${XDEBUG_DISCOVER_CLIENT_HOST}
EOF
  fi

  # i.e. XDEBUG_CLIENT_HOST=docker.for.mac.localhost
  if [ -n "${XDEBUG_CLIENT_HOST}" ]; then cat <<EOF
xdebug.client_host=${XDEBUG_CLIENT_HOST}
EOF
  fi

  if [ -n "${XDEBUG_START_UPON_ERROR}" ]; then cat <<EOF
xdebug.start_upon_error=yes
EOF
  fi
} > /etc/php/${PHP_MAJOR_VERSION}/fpm/conf.d/99-xdebug-remote-enable.ini

{
  cat <<EOF
xdebug.mode=${XDEBUG_MODE}
xdebug.client_port=${XDEBUG_CLIENT_PORT}
EOF

  # i.e. XDEBUG_CLIENT_HOST=docker.for.mac.localhost
  if [ -n "${XDEBUG_CLIENT_HOST}" ]; then cat <<EOF
xdebug.client_host=${XDEBUG_CLIENT_HOST}
EOF
  fi

  if [ -n "${XDEBUG_START_UPON_ERROR}" ]; then cat <<EOF
xdebug.start_upon_error=yes
EOF
  fi
} > /etc/php/${PHP_MAJOR_VERSION}/cli/conf.d/99-xdebug-remote-enable.ini

exec "$@"
