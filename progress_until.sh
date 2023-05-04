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
  ## Arguments
  # - timeout - time out in seconds
  # - period - how often to run code
  #
  ## Sample
  # _w_progress_until 30 0.25 ssh server1

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

  _w_sleep $period
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

# Тест-кейси:
#1. Перевіряємо, якщо команда в аргументі виконується ОК (строки 34...42). Для цього передаєм команду, яка повинна гарантовано відпрацювати, наприклад, ls
#2. Перевіряємо, якщо команда в аргументі виконується з кодом помилки і не може виконатись потім. Наприклад, ls /11, де /11 - гарантована відсутній каталог
#3. Перевіряємо, якщо команда в аргументі виконується спочатку з кодом помилки але потім виконується ОК. Наприклад, ls /11, де /11 - спочатку відсутній каталог, але потім робимо його.
#4. Виконуємо тест-кейс 3 з різними значеннями timeout, period та часом створення нового каталога: 
#4.1. Час створення перевищує timeout
#4.2. Час створення менше, ніж timeout
#
#
#
#
