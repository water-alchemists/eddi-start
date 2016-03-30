#! /bin/bash
#chkconfig: - 99 10
LOG_PATH=/root/hello.txt
SENSORS_PPID=''
PERSIST_PPID=''
CONTROLS_PPID=''

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

	( /root/eddi-sensors/bin/sensors &; echo "eddi-sensors now started" >> $LOG_PATH; SENSORS_PPID=$PPID )
	( cd /root/eddi-persist && npm start;echo "eddi-persist now started" >> $LOG_PATH; PERSIST_PPID=$PPID )
	( cd /root/eddi-controls && npm start; && echo "eddi-controls now started" >> $LOG_PATH; PERSIST_PPID=$PPID )

	echo "triggered initialize script $d" >> $LOG_PATH
	exit 0
}

stop(){
	echo "eddi-sensors process $SENSORS_PPID ended" >> $LOG_PATH
	echo "eddi-persist process $PERSIST_PPID ended" >> $LOG_PATH
	echo "eddi-controls process $CONTROLS_PPID ended" >> $LOG_PATH
	exit 0
}

case "$1" in
	start)
		start
		;;
	*)
		echo "Usage:$0 {start}"
esac

exit 0