#!/bin/bash

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
  #
  ## Arguments
  # - timeout - time out in seconds
  # - period - how often to run code
  #
  ## Sample
  # _w_progress_until 30 0.25 ssh server1
  #
  # Function `_w_progress_until` gets the command, runs it and drows the bar of work progress for command if the command returns an error (with code not equal to zero).
  # If command works right (with code equal to zero), then function no any bar draws. The function uses another functions: `w_sleep` and `w_progress`.
  # The function also gets the argument `timeout` that sets how many time function will trying to do the command. 
  # Another one argument `period` sets the time interval by which function will run the command again.
  # 
  # Arguments:
  # timeout - how many time function will trying to do the command, in float format
  # period - time interval by which function will run the command again
  # command - command itself
  #
  # Examples usage function `_w_progress_until` :
  # _w_progress_until() 30 6 ssh server1    # run command `ssh server1` and if command fail then draws (and then - draws again)
  # time progress bar that has passed since start run upto now. For example, through 6 seconds will drow the bar with 20% complete and through
  # 18 seconds will drow the bar with 60% complete. In this case every 6 seconds repeatedly will run command `ssh server1`
  #

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

  if (( $period > $elapsed_time ))
  then 
  _w_sleep $($period - $elapsed_time)
  fi
    # qqq2 : make argument $period proper
  # qqq2 : should return nonzero code if fail as well as print stdderr

  now_time=$( date +%s )
  elapsed_time=$(( $now_time - $start_time ))
  _w_progress $(( 100 * $elapsed_time / $timeout ))

  # eval "$@"
  output=$( eval "$@" 2>/dev/null )
  err=$?

  done

  _w_progress 100
  printf "%s\n" "$output"

}

export -f _w_progress_until
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_progress_until "$@"
fi

# Test cases:
#1. Check, how the command in argument running ОК (with code equal to zero). For this give the command that must ensuring work, for example, ls. Need for command check that successfully worked.
#2. Перевіряємо, якщо команда в аргументі виконується з помилкою (з кодом, відмінним від нуля) і не може виконатись потім. Наприклад, ls /11, де /11 - гарантована відсутній каталог. Потрібен для перевірки команди, яка весь час дає помилку. 
#3. Перевіряємо, якщо команда в аргументі виконується спочатку з помилкою (з кодом, відмінним від нуля) але потім виконується ОК (з кодом 0). Наприклад, ls /11, де /11 - спочатку відсутній каталог, але потім робимо його. Потрібен для перевірки команди, яка спочатку дає помилку, а потім успішно відпрацювує.
#4. Виконуємо тест-кейс 3 з різними значеннями timeout та часом створення нового каталога: 
#4.1. Робимо тест-кейс 3, але час створення каталога перевищує timeout. Потрібен для перевірки поведінки функції, коли команда спочатку дає помилку, а потім успішно відпрацювує, але час усунення проблеми перевищує timeout.
#4.2. Робимо тест-кейс 3, але час створення каталога менше за timeout. Потрібен для перевірки поведінки функції, коли команда спочатку дає помилку, а потім успішно відпрацювує і час усунення проблеми не перевищує timeout.
#
#
#
#
