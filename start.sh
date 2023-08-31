#!/bin/bash

/usr/local/bin/curl -V

export JBOSS_HOME=/opt/jboss/sso

if [ -z "$KEYCLOAK_ADMIN" ]; then
  echo "keycloak admin username is env is not set user default: admin"
  export KEYCLOAK_ADMIN=admin
fi

if [ -z "$KEYCLOAK_ADMIN_PWD" ]; then
  echo "keycloak admin password is env is not set user default: admin"
  export KEYCLOAK_ADMIN_PWD=admin
fi

echo  "enable keycloak admin"
command="$JBOSS_HOME/bin/add-user-keycloak.sh -r master  -u ${KEYCLOAK_ADMIN} -p ${KEYCLOAK_ADMIN_PWD}"

$command

sleep 1h
# set -b option to listen on all adresses
JBOSS_SCRIPT="${JBOSS_HOME}/bin/standalone.sh -b 0.0.0.0"

prog="keycloak server"

### JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT

#$JBOSS_SCRIPT

