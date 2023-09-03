#!/bin/bash

IMAGE="quay.io/nmajorov/sso:7.6.5"
podman run -it --rm --name keycloak \
  -e DB_ADDR="host.containers.internal:5432" \
  -e DB_DATABASE=root -p 7080:8080 $IMAGE

