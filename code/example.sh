#!/usr/bin/env bash

# ----------------------- Description -------------------------------- #

# This snippet provides a working example of code that is
# pushed and executed on remote machines.

# ----------------------- Input -------------------------------------- #

PARALLEL_HOST=$(hostname)
JOB_ID="${PARALLEL_PID:-0}-${PARALLEL_SEQ:-0}"
sleeptime="$(( RANDOM % 20 ))"

# ----------------------- Output file -------------------------------- #

output_file="results/${JOB_ID}-output-example"
std_output="${output_file}.out"
err_output="${output_file}.err"

# ----------------------- Log ---------------------------------------- #

function log {
  # Log to file and also to stdout
  TIMESTAMP=$(date '+%H:%M:%S.%N')
  echo "${PARALLEL_HOST}/${JOB_ID}[${TIMESTAMP}]: ${@:2}" | tee -a "${output_file}.log"
}

# ----------------------- Main --------------------------------------- #

# Write start time to log
log "START" "sleep" ${sleeptime}

# Test output redirection to log files
{ echo "stdout log"; env; echo "stderr log" 1>&2; } 1> "${std_output}" 2> "${err_output}"

# Run your script
sleep ${sleeptime} 1>> "${std_output}" 2>> "${err_output}"

# Write end time to log
log "END" "sleep" ${sleeptime}
