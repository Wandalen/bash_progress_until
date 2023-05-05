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
  # Function `_w_progress` draws the bar of work progress. Can use  multiple times for animation of code execution progress.
  # For animation function gets two arguments: `percent` (progress persant) and `visual_length` (progress bar length), 
  # then calculate, how many symbols need indicate as `done` and how many symbols need indicate as ' remains'.
  # If progress persant equal to 100 then progress bar is self-overwritten.
  #
  # Arguments:
  # `percent` - progress in persants. If `percent` > 100, then function sets percent=100. And if percent < 0, then function sets percent=0
  # visual_length - bar length in symbols amount. This is not required argument. If it is absent then `visual_length` = 40 
  #
  # Examles of use fubction _w_sleep :
  # _w_progress 50 30   # draws bar with 30 symbols in length and progress 50 persant (15 symbols sets as done and 15 symbols as remains)
  # _w_progress 30 70   # draws bar with 70 symbols in length and progress 30 persant (21 symbols sets as done and 49 symbols as remains)
  # _w_progress 70      # draws bar with 40 symbols in length and progress 70 persant (28 ymbols sets as done and 12 symbols as remains)
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


# Тест-кейси:
#1. _w_progress 0 # Запускаємо з percent=0 . Перевіряємо як відпрацьовує функція, коли percent=0 (початок шкали відсотків). Перевіряємо поведінку функції на початку шкали відсотків.
#2. _w_progress 100 # Запускаємо з percent=100. Перевыряємо як відпрацьовують строки 25...29, коли percent=100 (кінець шкали відсотків). 
#3. Запускаємо з percent більш 0, але менш 100 (наприклад, 30). Перевіряємо як відпрацьовує функція десь всередені шкали відсотків)
#4. Запускаємо з percent більш 100, наприклад, 120. Перевіряємо як відпрацьовує функція поза шкалою відсотків вище 
#5. Запускаємо з percent більш менш 0, наприклад, -20 . Перевіряємо як відпрацьовує функція поза шкалою відсотків нижче.
#6. Запускаєм з різними значеннями visual_length: до 40 (наприклад, 25), 40 і вище 40 (наприклад, 60). Перевіряємо як відпрацьовує функція 
#з аргументами visual_length, які менше/рівен/більше значенню visual_length за замовченням
