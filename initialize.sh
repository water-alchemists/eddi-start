#! /bin/bash
#chkconfig: - 99 10

echo "triggering script"

start(){
	node /root/eddi-controls/initialize.js
}

case "$1" in
	start)
		start
		;;
	*)
		echo "Usage:$0 {start}"
esac

exit 0