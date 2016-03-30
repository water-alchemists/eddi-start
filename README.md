# EDDI Startup Script
Start up script to run on the Artik

## Setup after download
1. Make the startup script an executable
``` chmod +x initialize.sh ```

1a. Remove any prior verisions of this script
```
//do this to remove a previous one that exists
rm -y /etc/init.d/initialize 
chkconfig --del initialize 
```

2. Add the script to ```/etc/init.d``` and the register with chkconfig
```
ln initialize.sh /etc/init.d/initialize
chkconfig --add initialize
chkconfig --levels 12345 initialize one
chkconfig --list // use to confirm
```

3. Restart to refresh
```shutdown -r now```