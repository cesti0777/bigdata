#!/bin/bash 

quiz_numbers=()
answer_numbers=()
strike_count=0

is_not_included() {
  local value=$1
  local res="Y"

  for element in ${quiz_numbers[@]}
  do
    if [ ${element} = ${value} ]
    then
      res="N"
      break
    fi
  done

  if [ ${res} = "Y" ]; then return 1; fi

  return 0
}

make_numbers() { # make random number - quiz_numbers
  while [ ${#quiz_numbers[@]} -lt 3 ]
  do
    random_number=$((RANDOM%9+1)) # 1~9 random number
    is_not_included ${random_number}
    res=$?
    if [ ${res} = 1 ]; then quiz_numbers+=(${random_number}); fi
  done
}

make_numbers

is_validate() { # numric and 3 digit
  local value=$1
  local strValue="${value}"
  if [ "${value}" -eq "${value}" ] 2>/dev/null
  then
    if [ ${#strValue} -eq 3 ]; then return 1; fi
  fi
  return 0
}

check_strike_count() {
  local index=$1
  if [ ${quiz_numbers[index]} = ${answer_numbers[index]} ]
  then
    return 1
  fi
  return 0
}

check_ball_count() {
  local index=$1
  local answer_num=${answer_numbers[${index}]} 
  local is_ball="N"
  for i in "${!quiz_numbers[@]}"
  do
    local quiz_num=${quiz_numbers[${i}]}
    if [ ${answer_num} = ${quiz_num} ]
    then
      if [ ${index} -ne ${i} ]
      then
        is_ball="Y"
        break
      fi
    fi
  done
  if [ ${is_ball} = "Y" ]; then return 1; fi
  return 0
}

check_numbers() {
  local strike_cnt=0
  local ball_cnt=0
  for idx in {0..2}
  do
    check_strike_count ${idx}
    str_cnt=$?
    strike_cnt=$((${strike_cnt}+str_cnt))

    check_ball_count ${idx}
    bal_cnt=$?
    ball_cnt=$((${ball_cnt}+bal_cnt))
  done
  echo ${strike_cnt} " strike, " ${ball_cnt} " ball"
  answer_numbers=()
  strike_count=${strike_cnt}
}

input_number() {
  if [ ${#answer_numbers[@]} -lt 3 ]
  then
    echo -e "input your numbers (3 digit): \c"
    read numbers
    is_validate ${numbers}
    validate_result=$?
    if [ ${validate_result} -ne 1 ]
    then
      echo "not valid! (numeric and 3 digit only)"
      input_number
    fi
    str_numbers="${numbers}"
    answer_numbers=(${str_numbers:0:1} ${str_numbers:1:1} ${str_numbers:2:1})
  else
    check_numbers  
  fi
}

while [ ${strike_count} -lt 3 ]
do
  input_number
done
