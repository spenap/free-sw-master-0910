#!/bin/bash

# Save pid file
if [ ! `echo $$ > /var/run/battery_meter.pid` ]
then
 echo "Failed to store the PID. Check permissions"
fi

BATTERY_INFO_FILE=/proc/acpi/battery/BAT0/state
COUNTER_FILE=/var/tmp/battery_value

while true
do
 BATTERY_STATUS=`cat $BATTERY_INFO_FILE | sed -n -e 's/charging state: *\([a-zA-Z]*\)/\1/p'`
 VALUE=`cat $COUNTER_FILE | { read X; echo ${X:=0}; }`
 
 if [ "discharging" = $BATTERY_STATUS ]
 then
  LOGGED=0
  echo `expr $VALUE + 1` > $COUNTER_FILE
 elif [ $LOGGED -eq 0 ]
 then
  echo $BATTERY_STATUS 
  # Log battery life
  logger -t "Battery Meter" "The battery has lasted $VALUE minutes"
  # Reset counter
  > $COUNTER_FILE
  LOGGED=1
 fi
 sleep 60
done
