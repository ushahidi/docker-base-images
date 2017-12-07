# Wrapper for [dockerize](github.com/jwilder/dockerize)

github.com/jwilder/dockerize is a utility to perform some commonplace container
customisations on initialisation.

These customisations include rendering
configuration files from a template (i.e. to include values of environment
variables), waiting for other services to be ready and piping new contents of
some files to stdout/stderr (useful for logs).

This wrapper enables the container image developer to configure all these
customisations via creation of files and setting environment variables.


* `DOCKERIZE_TEMPLATE_DIR` : this directory will be searched for files to pass
  as templates to dockerize. The destination path is determined from the
  template path inside the directory, thus a file in this path:

      $DOCKERIZE_TEMPLATE_DIR/etc/config.file

  will configure the container to process that file as a template when the
  container gets started, and write the results on `/etc/config.file`

  The wrapper will attempt to create the destination folder if it doesn't exist.

  This environment variable defines to `/tmpl`

* `DOCKERIZE_WAIT_*` : the values of any environment variables with names
  matching this pattern will be passed as -wait options to dockerize.
  i.e. `DOCKERIZE_WAIT_MYSQL=tcp://mysql:3306`

## CES (Chained Entrypoint Scripts)

As a bonus, we add Chained Entrypoint Script logic to easily customize and
extend the container startup sequence.

Entrypoint scripts usually deal with container initialization and
parsing / processing of the container command and arguments. Docker provides
means for setting the container entrypoint, but no means for extending that
entrypoint as other Dockerfiles build on top of an image.

CES helps Dockerfile authors easily build an initialization chain

In order for entrypoint scripts to be chainable, they should finish their
execution with something functionally similar to `exec "$@"`

### Setting up CES

The following Dockerfile statements install and set up CES

```
ENV DOCKERCES_MANAGE_UTIL=/manage.CES.sh \
    DOCKERCES_ENTRYPOINT_CHAIN=/entrypoints.CES \
    DOCKERCES_ENDPOINT_FILE=/endpoint.CES \
    DOCKERCES_ENTRYPOINT=/entrypoint.CES.sh \
    DOCKERCES_DEBUG=1
COPY /entrypoint.CES.sh $DOCKERCES_ENTRYPOINT
RUN ln -s /entrypoint.CES.sh $DOCKERCES_MANAGE_UTIL
ENTRYPOINT [ "/bin/bash", "/entrypoint.CES.sh" ]
```

### Management mode

From the Dockerfile, we invoke the CES script in management mode. The purpose
of doing so is to modify / extend the startup chain. i.e.:

    COPY entrypoint.dockerize.sh /entrypoint.dockerize.sh
    RUN $DOCKERCES_MANAGE_UTIL add /entrypoint.dockerize.sh

has the effect of adding the `/entrypoint.dockerize.sh` to the chain of
entrypoints

    COPY run.sh /run.sh
    RUN $DOCKERCES_MANAGE_UTIL endpoint /run.sh

has the effect of setting `/run.sh` as the endpoint of the initialization
chain. There can only be one endpoint and it's always executed at the end
of the chain. Thus, it doesn't need to be chainable.
