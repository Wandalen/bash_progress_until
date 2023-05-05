#!/bin/bash

_w_sleep()
{

  local -
  set -o errexit
  set -o nounset
  set -o pipefail

  ## Sleep seconds. Argument in second with floating point
  # Function _w_sleep() gets an argument "timeout" and sleeps for "timeout" seconds
  # For pause used built-in command "read" tnat works faster than command "sleep"
  #
  ## Arguments
  # timeout - in seconds with float format
  #
  ## Samples
  # _w_sleep 0.2   #  pause for 0.2 seconds
  # _w_sleep 3.5   #  pause
  #
  # Function `_w_sleep` enter computer process or running code, from which it run, in sleep state for specified number of seconds.
  # Can use if it is need "freeze" code running for any time.
  # Function gets one argument `timeout` at float format that set number of seconds for sleep.
  # Foe sleeping used build-in command `read`. Unlike `sleep` command, `read` command work more faster becouse it is build-in to the shell.
  # 
  # Arguments:
  # timeout - sets time for sleeping in seconds in float format
  #
  # Examples usage function `_w_sleep` :
  # _w_sleep 0.2   #  enter code in sleep state for 0.2 seconds
  # _w_sleep 3.5   #  enter code in sleep state for 3.5 seconds

  read -rt "$1" <> <(:) || :

  # qqq : cover by simple test. check does it work
    # === end of function _w_sleep

}

export -f _w_sleep
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_sleep "$@"
fi
