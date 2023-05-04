#!/bin/bash
_w_progress()
{

  local -
  set -o errexit
  set -o nounset
  set -o pipefail

  ## Draw progress bar. If percent is 100 progress bar erase itself.
  #
  ## Arguments
  # - percent - progress in percent
  # - visual_length - visual length in number of characters
  #
  ## Sample
  # _w_progress $percent $visual_length

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


# Тест-кейси:
#1. _w_progress 0 # Запускаємо з percent=0 . Перевіряємо як відпрацьовує функція, коли percent=0 (початок шкали відсотків). Перевіряємо поведінку функції на початку шкали відсотків.
#2. _w_progress 100 # Запускаємо з percent=100. Перевыряємо як відпрацьовують строки 25...29, коли percent=100 (кінець шкали відсотків). 
#3. Запускаємо з percent більш 0, але менш 100 (наприклад, 30). Перевіряємо як відпрацьовує функція десь всередені шкали відсотків)
#4. Запускаємо з percent більш 100, наприклад, 120. Перевіряємо як відпрацьовує функція поза шкалою відсотків вище 
#5. Запускаємо з percent більш менш 0, наприклад, -20 . Перевіряємо як відпрацьовує функція поза шкалою відсотків нижче.
#6. Запускаєм з різними значеннями visual_length: до 40 (наприклад, 25), 40 і вище 40 (наприклад, 60). Перевіряємо як відпрацьовує функція 
#з аргументами visual_length, які менше/рівен/більше значенню visual_length за замовченням
