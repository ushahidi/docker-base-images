FROM ruby:2.5.3

# PHP_DOCKER_USH_BUILD_SEQ can be incremented to force a rebuild within the
# same minor version
ENV RUBY_VERSION=2 \
    RUBY_MAJOR_VERSION=2.5 \
    RUBY_MINOR_VERSION=2.5.3 \
    RUBY_DOCKER_USH_BUILD_SEQ=1

# Install extensions and handy tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      libpq-dev \
      gettext-base \
      unzip \
      rsync \
      git \
      netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ruby tooling (bundler)
RUN gem install bundler

# Add ci wrapper
ADD ci-wrapper.sh /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/ci-wrapper.sh" ]
