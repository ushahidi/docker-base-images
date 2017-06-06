# Base docker images

Ready to be used for products and projects

# List of images

* [node-ci](node-ci/README.md) : container with node.js, purposed for use in a CI environment
* [php-ci](php-ci/README.md) : container with PHP, purposed for use in a CI environment

# Testing

`goss` is used for managing tests and running them

        ./goss.sh edit <image directory name>

will drop you into a shell running on the directory's image. From there you can use the `goss` command to
manage your tests

## Run the tests

        ./goss.sh run <image directory name>

