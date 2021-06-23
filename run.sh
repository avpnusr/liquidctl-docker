#! /bin/bash
liquidctl initialize all
liquidctl --serial $SERIAL list
liquidctl --serial $SERIAL set pump speed $PUMPSPEED
liquidctl --serial $SERIAL set fan speed $FANSPEED
sleep 20
while true; do
        liquidctl --serial $SERIAL status
        sleep 15
done

