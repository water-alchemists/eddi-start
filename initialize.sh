#! /bin/bash
#chkconfig: - 99 10

start(){
	node /root/eddi-controls/initialize.js
	echo "triggered initialize script $date" > /root/hello.txt
}

case "$1" in
	start)
		start
		;;
	*)
		echo "Usage:$0 {start}"
esac

exit 0