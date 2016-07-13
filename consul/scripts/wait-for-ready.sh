#!/bin/bash

# Wait for cloud-init to do it's thing
timeout 180 /bin/bash -c \
  "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"

echo "Updating apt-cache..."
sudo apt-get update &>/dev/null
