#! /bin/bash
#chkconfig: - 99 10
LOG_PATH=/root/hello.txt

start(){
	SENSORS_PATH=/root/eddi-sensors/bin/sensors
	STARTUP_SCRIPT=/root/eddi-start/startup.sh
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

	chmod +x $STARTUP_SCRIPT
	$STARTUP_SCRIPT
	echo "triggered initialize script $d" >> $LOG_PATH

}

stop(){
	echo "eddi-sensors process ended" >> $LOG_PATH
	echo "eddi-persist process ended" >> $LOG_PATH
	echo "eddi-controls process ended" >> $LOG_PATH

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