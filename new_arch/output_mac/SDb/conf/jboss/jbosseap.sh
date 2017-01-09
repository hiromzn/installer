#!/bin/bash
JBOSS_HOME=/jast/home/SDb/opt/jbosseap

CONFIG=standalone.xml
SERVER_NAME="SDbA"
BIND_ADDR="0.0.0.0"
MGMT_ADDR="0.0.0.0"
UNSECURE_ADDR=
PORT_OFFSET="900"
RUN_CONF=${JBOSS_HOME}/${SERVER_NAME}/bin/standalone.conf

WILDFLY_OPTS="-c $CONFIG"
WILDFLY_OPTS="$WILDFLY_OPTS -Djboss.server.base.dir=${JBOSS_HOME}/${SERVER_NAME}"
WILDFLY_OPTS="$WILDFLY_OPTS -Djboss.node.name=${SERVER_NAME}"
WILDFLY_OPTS="$WILDFLY_OPTS -Djboss.bind.address=${BIND_ADDR}"
if [ "x${MGMT_ADDR}" != "x" ]; then
  WILDFLY_OPTS="$WILDFLY_OPTS -Djboss.bind.address.management=${MGMT_ADDR}"
fi
if [ "x${UNSECURE_ADDR}" != "x" ]; then
  WILDFLY_OPTS="$WILDFLY_OPTS -Djboss.bind.address.unsecure=${UNSECURE_ADDR}"
fi
if [ "x${PORT_OFFSET}" != "x" ]; then
  WILDFLY_OPTS="$WILDFLY_OPTS -Djboss.socket.binding.port-offset=${PORT_OFFSET}"
fi

export RUN_CONF
$JBOSS_HOME/bin/standalone.sh $WILDFLY_OPTS

