#!/usr/bin/env bash
# JAVA_HOME
# Must Set for cron scheduler

# Spark Submit Environment Variable Settings

# SPARK_HOME
export SPARK_HOME=

# spark://host:port, mesos://host:port, yarn, or local.
export SPARK_MASTER=

# HADOOP CONF DIR For Yarn & Hdfs use
# export HADOOP_CONF_DIR=

# Modify this for change default driver port 4040
# export SPARK_DRIVER_PORT=4040

# Whether to launch the driver program locally ("client") or
# on one of the worker machines inside the cluster ("cluster") (Default: client).
# export SPARK_DEPLOY_MODE=client

# Memory for driver (e.g. 1000M, 2G) (Default: 1024M).
# export SPARK_DRIVER_MEMORY=4G

# Memory per executor (e.g. 1000M, 2G) (Default: 1G).
# export SPARK_EXECUTOR_MEMORY=4G

# Spark standalone and YARN only:
# ===============================
#
# Number of cores per executor. (Default: 1 in YARN mode,
# or all available cores on the worker in standalone mode)
# export SPARK_EXECUTOR_CORES=8
#
# Number of cores used by the driver, only in cluster mode (Default: 1).
# export SPARK_DRIVER_CORES=1
#
#

# Spark standalone and Mesos only:
# ===============================
#
# Total cores for all executors.
# export SPARK_TOTAL_EXECUTOR_CORES=100
#
#

# Spark driver max result size
# export SPARK_DRIVER_MAX_RESULT=4G

# Spark frame size
# export SPARK_FRAME_SIZE=2000

# Mesos modes of spark.
# If set to true, runs over Mesos clusters in "coarse-grained" sharing mode,
# where Spark acquires one long-lived Mesos task on each machine.
# If set to false, runs over Mesos cluster in "fine-grained" sharing mode,
# where one Mesos task is created per Spark task (Default: true)
# export SPARK_MESOS_COARSE=true

# Mesos library path
# export MESOS_NATIVE_JAVA_LIBRARY="/usr/local/lib/libmesos-0.21.0.so"
