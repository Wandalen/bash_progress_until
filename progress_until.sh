#!/bin/bash

  # ===== begin aug of progress_until
. ./progress.sh
. ./sleep.sh

_w_progress_until()
{

  local -
  set -o errexit
  set -o nounset
  set -o pipefail

  ## Draw progress bar executing code passed in arguments while it returns false.
  #
  ## Arguments
  # - timeout - time out in seconds
  # - period - how often to run code
  # - commands
  #
  ## Sample
  # _w_progress_until 30 0.25 ssh server1   - tries to connect to server1 with SSH every 0.25 seconds with timeout 30 seconds. Drows progress bar in persant command SSH has non-zero status


  local timeout=$1
  local period=$2
  shift 2

  local output elapsed_time now_time err sleep_period
  local start_time && start_time=$( date +%s )

  set +o errexit
  set +o nounset
  set +o pipefail

  _w_progress 0
  # eval "$@"
  output=$( eval "$@" 2>/dev/null )
  err=$?
  if [[ $err -eq 0 ]]
  then
  _w_progress 100
  printf "%s" "$output"
  return
  fi

  now_time=$( date +%s )
  elapsed_time=$(( $now_time - $start_time ))

  while (( $err != 0 && $elapsed_time < $timeout ))
  do

  sleep_period = $period - $elapsed_time
  if [ $sleep_period -gt 0 ]
  then
  _w_sleep $sleep_period       # run function _w_sleep with $2 argument
  # qqq2 : make argument $period proper
  # qqq2 : should return nonzero code if fail as well as print stdderr
  fi


  now_time=$( date +%s )
  elapsed_time=$(( $now_time - $start_time ))
  _w_progress $(( 100 * $elapsed_time / $timeout ))

  # eval "$@"
  output=$( eval "$@" 2>/dev/null )
  err=$?

  done

  _w_progress 100
  printf "%s\n" "$output"
  # === end of function _w_progress_until

}

export -f _w_progress_until
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_progress_until "$@"
fi

