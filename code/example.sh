#!/usr/bin/env bash

# ----------------------- Description -------------------------------- #

# This snippet provides a working example of code that is
# pushed and executed on remote machines.

# ----------------------- Input -------------------------------------- #

default_taskid="$(uuidgen)"
taskid="${1:-$default_taskid}"
sleeptime="$(( RANDOM % 20 ))"

# ----------------------- Output file -------------------------------- #

output_file="results/${taskid}-output-example"

# ----------------------- Log ---------------------------------------- #

function log {
  echo "${taskid}[$(date '+%H:%M:%S.%N')] - $(hostname): ${@:2}" | tee "results/${output_file}.log"
}

# ----------------------- Main --------------------------------------- #

# Write start time to log
log "START" "sleep" ${sleeptime}

# Write task id to screen
echo "Running job $taskid"

# Test output
{ echo "stdout log"; echo "stderr log" 1>&2; } 1>> $output_file.out 2>> $output_file.err

# Run your script
sleep ${sleeptime} 1>> $output_file.out 2>> $output_file.err

# Write end time to log
log "END" "sleep" ${sleeptime}
