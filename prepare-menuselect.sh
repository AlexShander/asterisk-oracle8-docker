#!/bin/bash

n=0
while read line; do
  # reading each line
  n=$((n+1))
  STATE=`echo $line | cut -d' ' -f1`
  OPTION=`echo $line | cut -d' ' -f2`
  CATEGORY=`echo $line | cut -d' ' -f3`
  echo "Line No. $n"
  echo "$line"
  echo "state=$STATE cat=$CATEGORY values=$OPTION"
  action='enable'
  if [[ "$STATE" == '-' ]] ; then
    action='disable'
  fi
  menuselect/menuselect --$action $OPTION menuselect.makeopts
  echo "-------------------"
done < ../options.conf
