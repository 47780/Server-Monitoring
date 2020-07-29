#!/bin/bash

# Variables
EMAIL='name@email.com'
SUB="$HOSTNAME-Alert"
CPU=$(top -bn1 | grep load | awk '{printf "%.2f", $(NF-2)}')
CPU_THRESHOLD=60.0
MEM=$(free -mt | awk '/Total/{print $4}')
MEM_THRESHOLD=100
D1_NAME="/"
D2_NAME="/mnt/volume1"
DRIVE1=$(df -h | awk '$NF=="/"{printf "%s\n", $5}' | sed 's/.$//')
DRIVE2=$(df -h | awk '$NF=="/mnt/volume_nyc3_01"{printf "%s\n", $5}' | sed 's/.$//')
DRIVE_THRESHOLD=90

# CPU monitoring
if [ $(echo "$CPU > $CPU_THRESHOLD" | bc -l) ]
then
  printf "CPU load is greater than threshold.\nCPU Load: %.1f%%\n" $CPU | mailx -s $SUB $EMAIL
fi

# Memory monitoring
if [ $MEM -le $MEM_THRESHOLD ]
then
  printf "Server memory running low.\nFree memory: %dMB\n" $MEM | mailx -s $SUB $EMAIL
fi

# Storage monitoring
if [ $DRIVE1 -gt $DRIVE_THRESHOLD ]
then
  printf "Storage running low on %s.\nPercentage used: %d%%\n" $D1_NAME $DRIVE1 | mailx -s $SUB $EMAIL
fi

if [ $DRIVE2 -gt $DRIVE_THRESHOLD ]
then
  printf "Storage running low on %s.\nPercentage used: %d%%\n" $D2_NAME $DRIVE2 | mailx -s $SUB $EMAIL
fi
