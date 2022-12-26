#!/bin/bash
# Copy files  from local dir to pod dir.

oc cp /home.student/Template/* $(oc get pods -l name-infodb -o custom-columns=NAME:.metadata.name | tail -n 1):/tmp

echo ". Print files in pod:"

oc exec -it $(oc get pods -l name-infodb -o custom-columns=NAME:.metadata.name | tail -n 1) -- ls -l /tmp