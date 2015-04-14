#!/bin/bash

###########################################
# Audits AWS instances for unused reserved
# instances and instances which do not have
# corresponding reserved instances.
###########################################

used_types="m3.medium m3.large m3.xlarge m3.2xlarge r3.large r3.xlarge r3.2xlarge r3.4xlarge r3.8xlarge"

active_res=$(ec2-describe-reserved-instances --filter state=active)
active_ins=$(ec2-describe-instances --filter instance-state-name=running)

# Loop through reserved instances

for type in $used_types; do
  res_total=0
  ins_total=0
  while read -r instance; do
    qty=$(echo "$instance" | awk '{print $11}')
    res_total=$(expr "$res_total" + "$qty")
  done < <(echo "$active_res" | grep "$type")
  ins_total=$(echo "$active_ins" | grep -c "$type")
  diff=$(($res_total - $ins_total))
  if [[ $diff > 0 ]]; then
    echo "UNUSED RESERVATION: (${diff}) - $type"
  elif [[ $diff < 0 ]]; then
    echo "UNRESERVED INSTANCES: (${diff}) - $type"
  else
    echo "OK - $type"
  fi
done
