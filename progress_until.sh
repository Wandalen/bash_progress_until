#!/bin/bash

  # ===== begin aug of progress_until
. ./progress.sh
. ./sleep.sh

_w_progress_until()
{

  local -
  set -o errexit     # exit immediately if command has non-zero status
  set -o nounset     # if varuable not set - this is an error
  set -o pipefail    #

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

  local output elapsed_time now_time err
  local start_time && start_time=$( date +%s )

  set +o errexit
  set +o nounset
  set +o pipefail

   _w_progress 0
  # eval "$@"
  output=$( eval "$@" 2>/dev/null )    # read passed parameters of function _w_progress and nothing to output
  err=$?
  if [[ $err -eq 0 ]]     # if no errors
  then
  _w_progress 100         # run function _w_progress with his argument 100
  printf "%s" "$output"   # print argumant _w_progress
  return
  fi

  now_time=$( date +%s )
  elapsed_time=$(( $now_time - $start_time ))

  while (( $err != 0 && $elapsed_time < $timeout ))     # while error and elapsed < timeout
  do

  _w_sleep $period       # run function _w_sleep with $2 argument
  # qqq2 : make argument $period proper
  # qqq2 : should return nonzero code if fail as well as print stdderr

  now_time=$( date +%s )
  elapsed_time=$(( $now_time - $start_time ))
  _w_progress $(( 100 * $elapsed_time / $timeout ))   # calculate persent of elapsed time, run function _w_progress

  # eval "$@"
  output=$( eval "$@" 2>/dev/null )     # read passed parameters of function  _w_progress  and nothing to output

  err=$?

  done

  _w_progress 100
  printf "%s\n" "$output"               # print passed parameters of function _w_progress
  # === end of function _w_progress_until

}

export -f _w_progress_until
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_progress_until "$@"
fi

