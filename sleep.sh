#!/bin/bash

# ===== begin aug of sleep
_w_sleep()
{

  local -
  set -o errexit
  set -o nounset
  set -o pipefail

  ## Sleep seconds. Argument in second with floating point
  #
  #Function _w_sleep() get an argument (e.g., 3.2) with floating point and sleep for 3.2 seconds
  #
  ## Sample
  # _w_sleep 0.2    - sleep for 0.2 seconds
  # _w_sleep 3.5    - sleep for 3.5 seconds 

  read -rt "$1" <> <(:) || :

  # qqq : cover by simple test. check does it work
    # === end of function _w_sleep

}

export -f _w_sleep
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_sleep "$@"
fi
