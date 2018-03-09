#!/bin/bash

###########################################
# Audits AWS instances for unused reserved
# instances and instances which do not have
# corresponding reserved instances.
###########################################

# Critical (exit code 2) if > this number
crit=4

used_types="m3.medium m3.large m3.xlarge m3.2xlarge m4.large m4.xlarge m4.2xlarge m4.4xlarge r3.large r3.xlarge r3.2xlarge r3.4xlarge r3.8xlarge"

source ~/.profile

active_res=$(/usr/local/bin/aws ec2 describe-reserved-instances --filter Name=state,Values=active Name=scope,Values="Availability Zone" --output text)
active_conv=$(/usr/local/bin/aws ec2 describe-reserved-instances --filter Name=state,Values=active Name=scope,Values=Region --output text)
active_ins=$(/usr/local/bin/aws ec2 describe-instances --filter Name=instance-state-name,Values=running --output text)

exit_code=0

# Loop through reserved instances

for type in $used_types; do
  res_total=0
  ins_total=0
  while read -r instance; do
    qty=$(echo "$instance" | awk '{print $7}')
    res_total=$(expr "$res_total" + "$qty")
  done < <(echo "$active_res" | grep "$type")
  while read -r instance; do
    qty=$(echo "$instance" | awk '{print $6}')
    res_total=$(expr "$res_total" + "$qty")
  done < <(echo "$active_conv" | grep "$type")
  ins_total=$(echo "$active_ins" | grep -c "$type")
  diff=$(($res_total - $ins_total))
  if [[ $diff -gt $crit ]]; then
    echo "UNUSED RESERVATION: (${diff}) - $type"
    exit_code=2
  elif [[ $diff -gt 0 ]]; then
    echo "UNUSED RESERVATION: (${diff}) - $type"
    if [[ $exit_code -ne 2 ]]; then
      exit_code=1
    fi
  elif [[ $diff -lt -${crit} ]]; then
    diff=$(echo $diff | sed 's/-//g')
    echo "UNRESERVED INSTANCES: (${diff}) - $type"
    exit_code=2
  elif [[ $diff -lt 0 ]]; then
    diff=$(echo $diff | sed 's/-//g')
    echo "UNRESERVED INSTANCES: (${diff}) - $type"
    if [[ $exit_code -ne 2 ]]; then
      exit_code=1
    fi
  fi
done

exit $exit_code
