# EDDI Startup Script
Start up script to run on the Artik. It will initialize all the digital pins and start sensors, controls and the persist services.

## Setup after download
1. Make the startup script an executable
  ``` chmod +x initialize.sh ```

2. Remove any prior verisions of this script
  ```
  //do this to remove a previous one that exists
  chkconfig --del initialize 
  rm -y /etc/init.d/initialize 
  ```

3. Add the script to ```/etc/init.d``` and the register with ```chkconfig```
  ```
  ln initialize.sh /etc/init.d/initialize
  chkconfig --add initialize
  chkconfig --levels 12345 initialize one
  chkconfig --list // use to confirm
  ```

4. Restart to refresh
  ```shutdown -r now```
