#!/bin/bash

LOG_FILE=$1

while read line; do echo $line | awk '{print $4 " " $7}' | sed s/^[^:]*\://; done < $LOG_FILE 

