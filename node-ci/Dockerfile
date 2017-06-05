FROM node:6.10.3

# Install handy utils
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y rsync gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Access github SSH URLs via HTTP
RUN git config --global url."https://github.com/".insteadOf git@github.com:

# Copy wrapper for silent npm installs
ADD npm-install-silent.sh /usr/local/bin

# Install some common node.js tools
RUN npm-install-silent.sh -g gulp@3.9.1 gulp-notify@2.2.0 grunt-cli@1.2.0 bower@1.8.0 node-gyp@3.6.1

# Add ci wrapper
ADD ci-wrapper.sh /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/ci-wrapper.sh" ]
