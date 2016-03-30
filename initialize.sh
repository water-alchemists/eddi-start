#! /bin/bash
#chkconfig: - 99 10
LOG_PATH=/root/hello.txt

start(){
	SENSORS_PATH=/root/eddi-sensors/bin/sensors
	DHCLIENT="dhclient"
	d=$(date +"%m-%d-%y %H:%M")
	node /root/eddi-controls/initialize.js
	if [ test -e SENSORS_PATH ]
	then
		echo "eddi-sensors was already made" >> $LOG_PATH
	else 
		echo "eddi-sensors was not made" >> $LOG_PATH
		( make -C /root/eddi-sensors && echo "eddi-sensors is now made" >> $LOG_PATH)
	fi

	if [ ps -ef | grep $DHCLIENT]
	then
		echo "wifi was already started" >> $LOG_PATH
	else
		echo "wifi was not started" >> $LOG_PATH
		eval "$DHCLIENT wlan0"
		echo "wifi was now started" >> $LOG_PATH

	fi

	/root/eddi-sensors/bin/sensors
	SENSOR_STATUS=$?
	echo "eddi-sensors now started. status $SENSOR_STATUS" >> $LOG_PATH
	node /root/eddi-persist/index.js
	PERSIST_STATUS=$?
	echo "eddi-persist now started. status $PERSIST_STATUS" >> $LOG_PATH
	node /root/eddi-controls/index.js
	CONTROLS_STATUS=$?
	echo "eddi-controls now started. status $CONTROLS_STATUS" >> $LOG_PATH
	echo "triggered initialize script $d" >> $LOG_PATH

}

stop(){
	echo "eddi-sensors process $SENSORS_PPID ended" >> $LOG_PATH
	echo "eddi-persist process $PERSIST_PPID ended" >> $LOG_PATH
	echo "eddi-controls process $CONTROLS_PPID ended" >> $LOG_PATH

}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	*)
		echo "Usage:$0 {start|stop}"
esac

exit 0