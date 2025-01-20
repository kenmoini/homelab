#!/bin/bash

# Check to make sure we have to parameters passed to the script
if [ $# -ne 2 ]; then
  echo "Usage: $0 pull-secret-1.json pull-secret-2.json [> output.json]"
  exit 1
fi

# Load the two pull secrets into variables

jq -Mrcs '.[0] * .[1]' ${1} ${2}