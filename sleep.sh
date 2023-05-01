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
  ## Sample
  # _w_sleep 0.2

  read -rt "$1" <> <(:) || :

  # qqq : cover by simple test. check does it work
    # === end of function _w_sleep

}

export -f _w_sleep
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_sleep "$@"
fi
