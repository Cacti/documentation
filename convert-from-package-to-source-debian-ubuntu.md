# Converting from Debian/Ubuntu Package Install to Cacti Source-Based Install

This guide outlines the steps to convert from a Debian/Ubuntu package install of Cacti to a source-based install.

If you are looking to run the latest version of Cacti a source based installation is the way to go 
Often the cacti team releases feature and updates that the packages lag behind on also source based installs
provide more control for administrators than a package installation

This document will provide the steps on how to convert a system that has been installed via package on a Debian/Ubuntu system while retaining your settings and data

### Important !  Before running these steps ensure you have a system backup !
#### Note these steps can vary between Ubuntu/Debian versions however the process flow would be the same 

## Step 1: Stop Cron/cactid Daemon
ensure that cron is stopped to prevent any conflicts during the transition and to prevent the poller from running while backing up the system
systemctl stop cron
If you have installed the cactid daemon 
```shell
systemctl stop cactid
 ```

## Step 2: Backup Configuration File
```shell
cp /usr/share/cacti/site/include/config.php /path/to/backup/config.php
```

## Step 3: Backup Graph Files
You can copy all of the graph files in `/usr/share/cacti/site/rra` to another folder so you can copy them back later.
```shell
cp -r /usr/share/cacti/site/rra /path/to/backup/rra
```

## Step 4: Dump the Database
Create a backup of the Cacti database.
```shell
mysqldump cacti > cacti.sql
```
## Step 5: Uninstall the Package Version of Cacti
Remove and purge the Cacti package to ensure no conflicts with the source-based install.
```shell
apt-get remove cacti && apt-get purge cacti
```

## Step 6: Install Cacti via Source
Follow the appropriate steps to install Cacti from source. Refer to the official Cacti https://github.com/bmfmancini/documentation/blob/develop/Installing-Under-Ubuntu-Debian.md

## Step 7: Re-import the Database
Once Cacti is installed from source, restore your previous settings by re-importing the database.
```shell
mysql cacti < cacti.sql
```

## Step 8: Restore Graph Files
Copy the backed-up RRA files to the new RRA folder directory in your source installation.

```shell
cp -r /path/to/backup/rra /new/cacti/source/path/rra
```

---

Once these steps are completed, your Cacti installation will be switched from a package-based install to a source-based one, while retaining your configurations and graphs.
