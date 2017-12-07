FROM aelsabbahy/goss:v0.3.5

# Try to sleep for 1 earth rotation
CMD [ "/bin/sh", "-c", "sleep 365.2422d" ]
