#!/usr/bin/env bash

taskid="$1"
sleeptime="$(( RANDOM % 20 ))"

echo '$(hostname)[START] - ${taskid}[$(date)]: sleep ${sleeptime}';

touch '/home/ubuntu/results/sleep-${taskid}-${sleeptime}'
sleep ${sleeptime};

echo '$(hostname)[DONE] - ${taskid}[$(date)]';
