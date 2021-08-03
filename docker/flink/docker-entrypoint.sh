#!/bin/bash

# jobmanager or taskmanager
FLINK_COMPONENT=$1
shift

FLINK_CONFIG=$FLINK_HOME/conf/flink-conf.yaml

function set_config_property {
    key=$1
    value=$2
    grep -qe "^#*\s*$key:" $FLINK_CONFIG && sed -ir "s~^#*\s*$key:.*~$key: $value~" $FLINK_CONFIG || echo -e "$key: $value\n" >> $FLINK_CONFIG
}

function setup_config {
    for i in "$@"
    do
        set_config_property ${i%=*} ${i#*=}
        shift
    done

    echo "config file: " && grep '^[^\n#]' $FLINK_CONFIG
}

# Set default config values
set_config_property "jobmanager.rpc.address" "flink-jobmanager"

if [ "$FLINK_COMPONENT" = "jobmanager" ]; then
    # Override config params form command line arguments
    setup_config "$@"

    $FLINK_HOME/bin/jobmanager.sh start cluster
elif [ "$FLINK_COMPONENT" = "taskmanager" ]; then
    set_config_property "taskmanager.numberOfTaskSlots" `grep -c ^processor /proc/cpuinfo`

    # Override config params from command line arguments
    setup_config "$@"

    $FLINK_HOME/bin/taskmanager.sh start
else
    $@
fi