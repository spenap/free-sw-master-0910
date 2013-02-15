#!/bin/bash
# Program a daemon (suitable for init.d) that, every 5 seconds, tests about the
# machine load. If the load goes below 0.1, the daemon will check the user 
# accounts and generate a report listing the top 10 directories from /home 
# taking more disk space. Once the report is generated, the daemon should stop itself.
# Hints: sleep, uptime, du, sort

DATAFILE=/var/tmp/acrep.dat

if [ ! `echo $$ > /var/run/acrep.pid` ]
then
 echo "Failed to store PID. Check permissions"
fi

> $DATAFILE

doreport () {

 for user in `ls /home/`
 do
  du -x "/home/"$user/ | sort -nr | head -n 10 >> $DATAFILE
 done

}

REPORT_READY=0

while [ $REPORT_READY -ne 1 ]
do
 # Get machine load
 LOAD=`uptime | sed -n -e 's/.*load average: \([0-9]*\.[0-9]*\),.*/\1/p'`
 LOAD_VALID=`echo $LOAD | sed -n -e 's/\([0-9]*\)\.\([0-9]*\)/\1 \2/p' | \
{ read ENT DEC; if [ $ENT -eq 0 -a $DEC -le 10 ]; then echo 1; else echo 0; fi }`
 if [ $LOAD_VALID -eq 1 ]
 then 
  doreport
  REPORT_READY=1
 else
   sleep 5
 fi
done
