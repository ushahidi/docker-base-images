FROM debian:stretch

ENV DOCKERIZE_VERSION=v0.6.0 \
    DOCKERIZE_TEMPLATE_DIR=/tmpl

RUN apt-get update && \
    apt-get install -y curl findutils && \
    curl -L https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz | \
      tar -C /usr/local/bin -xzv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add utilities for Cascading Entrypoint Scripts
ENV DOCKERCES_MANAGE_UTIL=/manage.CES.sh \
    DOCKERCES_ENTRYPOINT_CHAIN=/entrypoints.CES \
    DOCKERCES_ENDPOINT_FILE=/endpoint.CES \
    DOCKERCES_ENTRYPOINT=/entrypoint.CES.sh \
    DOCKERCES_DEBUG=1
COPY /entrypoint.CES.sh $DOCKERCES_ENTRYPOINT
RUN ln -s /entrypoint.CES.sh $DOCKERCES_MANAGE_UTIL
# Set up Cacading Entrypoint Scripts as master entrypoint
ENTRYPOINT [ "/bin/bash", "/entrypoint.CES.sh" ]

# Add dockerize entrypoint
COPY /entrypoint.dockerize.sh /
RUN $DOCKERCES_MANAGE_UTIL add /entrypoint.dockerize.sh
