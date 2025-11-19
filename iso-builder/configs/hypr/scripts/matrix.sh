#!/usr/bin/env bash
# Matrix rain aesthetic script
set -euo pipefail
trap 'tput cnorm; exit' INT TERM

chars=("ア" "カ" "サ" "タ" "ナ" "ハ" "マ" "ヤ" "ラ" "ワ" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")
cols=$(tput cols)
lines=$(tput lines)
tput civis

declare -a drops
for ((i=0; i<cols; i++)); do
  drops[i]=$((RANDOM % lines))
done

while true; do
  printf '\e[1;30m'
  for ((i=0; i<cols; i++)); do
    printf '\e[%s;1f ' "${lines}"
  done
  for ((i=0; i<cols; i++)); do
    rand_char=${chars[$RANDOM % ${#chars[@]}]}
    printf '\e[%s;%sf\e[38;5;%sm%s' "${drops[i]}" "$((i+1))" "$((46 + RANDOM % 50))" "$rand_char"
    drops[i]=$(((drops[i] + 1) % lines))
  done
  sleep 0.05
done
