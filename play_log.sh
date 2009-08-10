#!/bin/bash

LOG_IN=$1
BASE_URL="http://c17-tv-perf1.cnet.com"
FAKE_HOST="www.tv.com"
#curl -v -H"Host: www.tv.com" http://c17-tv-perf1.cnet.com/

#turn a string in the form HH:MM:SS into seconds since 00:00:00
function string_to_secs {
    BASE_TIME_STR=$1
    BASE_TIME_HRS=$(echo $BASE_TIME_STR | awk -F: '{print $1}')
    BASE_TIME_MIN=$(echo $BASE_TIME_STR | awk -F: '{print $2}')
    BASE_TIME_SEC=$(echo $BASE_TIME_STR | awk -F: '{print $3}')
    BASE_TIME=$(echo "($BASE_TIME_HRS*60*60)+($BASE_TIME_MIN*60)+$BASE_TIME_SEC" | bc)
    echo $BASE_TIME
}

PREV_TIME=$(string_to_secs `head -1 $LOG_IN | awk '{print $1}'`)

while read line;
do
    TIME=$(string_to_secs `echo $line | awk '{print $1}'`)
    WAIT=$(($TIME-$PREV_TIME))
    URL_PATH=$(echo $line | awk '{print $2}')
    URI=${BASE_URL}${URL_PATH}
    echo "wait $WAIT secs and then access $URI"
    
    if [ $WAIT -gt "0" ]; then
        sleep $WAIT
        curl -q -H "Host: $FAKE_HOST" "$URI" > /dev/null
    else 
        curl -q -H "Host: $FAKE_HOST" "$URI" > /dev/null &
    fi


    PREV_TIME=$TIME
done < $LOG_IN
