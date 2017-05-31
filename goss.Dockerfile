FROM tuxpiper/goss:0.3.2

# Try to sleep for 1 earth rotation
CMD [ "/bin/sh", "-c", "sleep 365.2422d" ]
