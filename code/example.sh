#!/usr/bin/env bash

taskid="$1"
sleeptime="$(( RANDOM % 20 ))"

echo "${taskid}[$(date)] - $(hostname): START - sleep ${sleeptime}";

touch "${SCIBOX_HOME:-/home/ubuntu/scibox}/results/sleep-${taskid}-${sleeptime}"
sleep ${sleeptime};

echo "${taskid}[$(date)] - $(hostname): DONE";
