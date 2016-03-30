#! /bin/bash
#chkconfig: - 99 10

start(){
	SENSORS_PATH=/root/eddi-sensors/bin/sensors
	DHCLIENT="dhclient"
	LOG_PATH=/root/hello.txt
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

	( /root/eddi-sensors/bin/sensors & && echo "eddi-sensors now started" >> $LOG_PATH )
	( cd /root/eddi-persist && npm start & echo "eddi-persist now started" >> $LOG_PATH )
	( cd /root/eddi-controls && npm start & && echo "eddi-controls now started" >> $LOG_PATH )

	echo "triggered initialize script $d" >> $LOG_PATH
}

case "$1" in
	start)
		start
		;;
	*)
		echo "Usage:$0 {start}"
esac

exit 0