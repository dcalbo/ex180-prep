#!/bin/bash

# rm -rf data

echo -n ". Deleting containers: "
podman stop todo_frontend &>/dev/null
podman stop todoapi &>/dev/null
podman stop mysql &>/dev/null
podman rm todo_frontend &>/dev/null
podman rm todoapi>/dev/null 
podman rm mysql >/dev/null
echo "OK"