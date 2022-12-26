#!/bin/bash
# Get logs fron pods selected by labels.

oc logs --tail 10 $(oc get pods -l name=infodb -o custom-columns=NAME:.metadata.name | tail -n 1)
