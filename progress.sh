#!/bin/bash
_w_progress()
{

  local -
  set -o errexit
  set -o nounset
  set -o pipefail

  ## Draw progress bar. If percent is 100 progress bar erase itself.
  # Function get two arguments (percent and visual_length) and draw progress bar.
  # Argument visual_length set length of the bar in symbols. Default is 40 symbols
  # Function _w_progress() can be used several times and create animation for progress  
  #
  ## Arguments
  # - percent - progress in percent
  # - visual_length - visual length in number of characters
  #
  ## Sample
  # _w_progress $percent $visual_length
  # _w_progress 50 30   # draw bar witn 30 symbols length and 50% progress
  # _w_progress 30 70   # draw bar witn 70 symbols length and 30% progress
  # _w_progress 70      # draw bar witn 40 symbols length (default) and 70% progress
  #
  # Функція _w_progress() вирісовує смугу прогресу. 
  # Функція приймає два аргумента: percent (відсоток прогреса) та visual_length (довжина смуги прогреса)
  # Функція розраховує, скільки символів треба позначити як "виконано" і скильки символіа треба позначити як "решта"
  # Якщо відсоток прогресу дорівнюється 100, то полоса прогресу сама затирається.
  # Функцію можна використовувати неодноразово - як анимацію для смуги прогресу.
  #
  # Аргументи:
  # percent - прогрес в відсотках. Якщо percent > 100, то функцыя встановлює percent=100. А якщо percent < 0, функцыя встановлює percent=0
  # visual_length - довжина смуги в кількості символів. Це не обов'язковій аргумент. Якщо він вітсутній, то visual_length = 40 
  #
  # Приклади використання функції _w_sleep() :
  # _w_progress 50 30   # вирісовує смугу довжиною 30 символів і прогресом 50 відсотків (15 символів позначає як виконано, а 15 символів - як решта)
  # _w_progress 30 70   # вирісовує смугу довжиною 70 символів і прогресом 30 відсотків (21 символ позначає як виконано, а 49 символів - як решта)
  # _w_progress 70      # вирісовує смугу довжиною 40 символів і прогресом 70 відсотків (28 символів позначає як виконано, а 12 символів - як решта)
  #

  local percent && percent=$1
  local visual_length && visual_length=${2:-40}

  percent=$(( $percent > 100 ? 100 : $percent ))
  percent=$(( $percent < 0 ? 0 : $percent ))

  if (( $percent == 100 ))
  then

  printf -v spaces "%${visual_length}s"
  printf '%s\r' "${spaces}"

  else

  if [[ ${VERBOSITY:-1} -eq 0 ]]
  then
    return
  fi

  local tick=''
  local margin=0
  if [[ ${WITH_TICKS:-1} -eq 1 ]]
  then
    local -a ticks=( ⠁ ⠁ ⠉ ⠙ ⠚ ⠒ ⠂ ⠂ ⠒ ⠲ ⠴ ⠤ ⠄ ⠄ ⠤ ⠠ ⠠ ⠤ ⠦ ⠖ ⠒ ⠐ ⠐ ⠒ ⠓ ⠋ ⠉ ⠈ ⠈ )
    local len=${#ticks[@]}
    local index=$(( RANDOM % $len ))
    margin=4
    tick="  ${ticks[$index]} "
  fi

  local internal_visual_length && internal_visual_length=$(( $visual_length - $margin ))
  local elapsed_val && elapsed_val=$(( $percent * $internal_visual_length / 100 ))
  local remaining_val && remaining_val=$(( $internal_visual_length - $elapsed_val ))

  printf -v elapsed_str "%${elapsed_val}s"
  printf -v remaining_str "%${remaining_val}s"
  printf "%s\r" "${tick}${elapsed_str// /█}${remaining_str// /░}"

  fi

}

export -f _w_progress
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_progress "$@"
fi
