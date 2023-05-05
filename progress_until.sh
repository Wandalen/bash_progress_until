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
  # Функція _w_progress_until() приймає команду, виконує її та вирісовує смугу прогресу роботи команди якщо команди повертає помилку (з кодом не нуль)
  # Якщо команда відпрацьовує коректно (з кодом нуль), то функція нічого не вирісовує. Функція використовує функції _w_sleep() та _w_progress()
  # Функція також приймае аргумент "timeout", який задає, скільки часу функція буде намагатися виконати команду. 
  # Ще один аргумент "period" задає інтервал часу, через який функція буде повторно виконувати команду.
  # 
  # Аргументи:
  # timeout - скільки часу функція буде намагатися виконати команду, в форматі float
  # period - через який інтервал часу фйнкція буде повторно виконувати команду
  # command - сама команда
  #
  # Приклади використання функції _w_progress_until() :
  # _w_progress_until() 30 6 ssh server1    # виконує команду ssh server1 і якщо не виходить виконати команду, то малює (а потім - перемальовує)
  #смугу прогресу часу, який пройшов з момента початку виконання до теперешнього часу. Наприклад, через 6 секунд намалює смугу з 20% виконання, а через
  #18 секунд буде смуга з 60% виконання. При цобму кожні 6 секунд буде повторна виконана команда ssh server1
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
