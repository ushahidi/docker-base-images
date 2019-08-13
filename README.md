# Base docker images

Ready to be used for products and projects.

See [docker-os-images](github.com/ushahidi/docker-os-images) for the images
that these ones are built on.


# List of images

* [node-ci](node-ci/README.md) : container with node.js, purposed for use in a CI environment
* [php-ci](php-ci/README.md) : container with PHP, purposed for use in a CI environment
* [php-fpm-nginx](php-fpm-nginx/README.md) : container with nginx and php-fpm connected by fastcgi . Suitable for deployable containers in active environments (staging, production, etc)
* [ruby-ci](ruby-ci) : container with ruby and bundler, purposed for CI environments

# Testing

`goss` is used for managing tests and running them

        ./goss.sh edit <image directory name> <major version>

will drop you into a shell running on the directory's image. From there you can use the `goss` command to
manage your tests

## Run the tests

        ./goss.sh run <image directory name> <major version>

i.e.

        ./goss.sh run php-ci 7.0
