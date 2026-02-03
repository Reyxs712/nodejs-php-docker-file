#!/bin/bash
cd /home/container

# Replace some environment variables that Pterodactyl passes
# This ensures the startup command can be modified via the panel
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}