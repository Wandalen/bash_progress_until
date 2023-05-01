#!/bin/bash
_w_progress()
{

  local -
  set -o errexit
  set -o nounset
  set -o pipefail

  # === begin of function _w_progress

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
    # === end of function _w_progress

}

export -f _w_progress
if [[ "${BASH_SOURCE[0]}" == "$0" ]]
then
  _w_progress "$@"
fi
