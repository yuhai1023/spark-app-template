#!/usr/bin/env bash
if [ $# -lt 1 ]; then
    echo "Usage: $0 class.name"
    exit 0
fi

this=`dirname $0`
this=`cd ${this}; pwd`
logs=${this}/log

if [ ! -d ${logs} ]; then
    mkdir -p ${logs}
fi

. "$this/config/submit-spark-env.sh"

if [ -z "$SPARK_MASTER" ]; then
    echo "Error: SPARK_MASTER not Specified in environment"
    exit -1
fi

#
# spark-submit options
#

# deploy option
if [ -n "$SPARK_DEPLOY_MODE" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --deploy-mode $SPARK_DEPLOY_MODE"
fi

# driver option
if [ -n "$SPARK_DRIVER_MEMORY" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --driver-memory $SPARK_DRIVER_MEMORY"
fi

if [ -n "$SPARK_DRIVER_CORES" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --driver-cores $SPARK_DRIVER_CORES"
fi

if [ -n "$SPARK_EXECUTOR_MEMORY" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --executor-memory $SPARK_EXECUTOR_MEMORY"
fi

if [ -n "$SPARK_EXECUTOR_CORES" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --executor-cores $SPARK_EXECUTOR_CORES"
fi

if [ -n "$SPARK_TOTAL_EXECUTOR_CORES" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --total-executor-cores $SPARK_TOTAL_EXECUTOR_CORES"
fi

# spark-submit environment properties
if [ -n "$SPARK_MESOS_COARSE" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --conf spark.mesos.coarse=$SPARK_MESOS_COARSE"
fi

if [ -n "$SPARK_DRIVER_MAX_RESULT" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --conf spark.driver.maxResultSize=$SPARK_DRIVER_MAX_RESULT"
fi

if [ -n "$SPARK_FRAME_SIZE" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --conf spark.akka.frameSize=$SPARK_FRAME_SIZE"
fi

if [ -n "$SPARK_DRIVER_PORT" ]; then
    SUBMIT_OPTS="$SUBMIT_OPTS --conf spark.ui.port=$SPARK_DRIVER_PORT"
fi


for i in ${this}/deps/*.jar; do
    JARS="$JARS,$i"
done

JARS=${JARS:1}

SUBMIT_OPTS="$SUBMIT_OPTS --master ${SPARK_MASTER} --jars $JARS"

JAR=${this}/app/`ls -t ${this}/app | head -n 1`

# Set spark-submit bin
if [ -z "$SPARK_HOME" ]; then
    if which spark-submit > /dev/null 2>&1; then
        SPARK_SUBMIT=spark-submit
    else
        echo "Error: SPARK_HOME not Specified in environment"
        exit -1
    fi
else
    SPARK_SUBMIT=${SPARK_HOME}/bin/spark-submit
fi

class=$1
shift

time ${SPARK_SUBMIT} ${SUBMIT_OPTS} --class $class ${JAR} $@

