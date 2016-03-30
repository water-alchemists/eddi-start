#! /bin/bash
#chkconfig: - 99 10

start(){
	SENSORS_PATH=/root/eddi-sensors/bin/sensors
	DHCLIENT="dhclient"
	d=$(date +"%m-%d-%y %H:%M")
	node /root/eddi-controls/initialize.js
	if [ test -e SENSORS_PATH ]
	then
		echo "eddi-sensors was already made" >> /root/hello.txt
	else 
		echo "eddi-sensors was not made" >> /root/hello.txt
		( make -C /root/eddi-sensors )
	fi

	if [ ps -ef | grep $DHCLIENT]
	then
		echo "wifi was already started" >> /root/hello.txt
	else
		echo "wifi was not started" >> /root/hello.txt
		eval "$DHCLIENT wlan0"
	fi

	/root/eddi-sensors/bin/sensors &
	( cd /root/eddi-persist && npm start & )
	( cd /root/eddi-controls && npm start & )

	echo "triggered initialize script $d" >> /root/hello.txt
}

case "$1" in
	start)
		start
		;;
	*)
		echo "Usage:$0 {start}"
esac

exit 0