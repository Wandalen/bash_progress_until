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
  # Функція _w_sleep() вводить процес в стан сну на задану кількість секунд.
  # Функція приймає один аргумент "timeout" в форматі float, який задає кількість секунд для сну.
  # Для засинання використовуєтья вбудована команда "read" так як вона працює бистріше, ніж команда "sleep"
  # 
  # Аргументи:
  # timeout - задає час для сну в секундах, в форматі float
  #
  # Приклади використання функції _w_sleep() :
  # _w_sleep 0.2   #  вводить процес в стан сну на 0.2 секунди
  # _w_sleep 3.5   #  вводить процес в стан сну на 3.5 секунди

  read -rt "$1" <> <(:) || :

  # qqq : cover by simple test. check does it work
    # === end of function _w_sleep

}

export -f _w_sleep
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_sleep "$@"
fi
