#!/bin/sh
LOG_PATH=/root/forever.txt

echo "triggering startup script"
/root/eddi-sensors/bin/sensors >> $LOG_PATH
SENSOR_STATUS=$?
echo "eddi-sensors now started. status $SENSOR_STATUS" >> $LOG_PATH
node /root/eddi-persist/index.js >> $LOG_PATH
PERSIST_STATUS=$?
echo "eddi-persist now started. status $PERSIST_STATUS" >> $LOG_PATH
node /root/eddi-controls/index.js >> $LOG_PATH
CONTROLS_STATUS=$?
echo "eddi-controls now started. status $CONTROLS_STATUS" >> $LOG_PATH

exit 0