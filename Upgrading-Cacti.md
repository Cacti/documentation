# Upgrading Cacti Under UNIX Compatible Operating Systems

To upgrade Cacti under UNIX-style operating systems is very straightforward. To upgrade Cacti on Windows, you should use the instructions in the link below:

[Upgrading in Windows](Upgrading-Cacti-Under-Windows.md)

Before you begin, ensure that both your Apache/NGINX and your Crontab or systemd-based pollers run as the same account. In most Linux operating systems, this will be the apache account. Under SLES, it will be www-run. For this guide, we will use the apache account, but please adjust accordingly.

1. Disable Polling:

   Go to Console >> Settings >> Poller >> Data Collection Enabled and switch it off.

2. Backup the Cacti Configuration File:

   Backup the config.php file located in <cacti_dir>/include/.
   ```shell
   shell> cp <cacti_dir>/include/config.php <backup_location>
   ```
   
3. Backup the Old Cacti Database:

   Create a backup of the current Cacti database.
   ```shell
   shell> mysqldump -l --add-drop-table --lock-tables=false cacti > mysql.cacti
    ```
   On newer versions of MariaDB

   ```shell
   shell> mariadb-dump   -l --add-drop-table --lock-tables=false cacti > mysql.cacti

   ```
   
   You will probably have to specify the -u and -p flags for the MySQL username and password. This user must have permission to read from Cacti's database or you will end up with an empty backup.

5. Backup the Old Cacti Directory:

   Backup the old Cacti directory with the exception of the RRD files, which should not need backup.
   ```shell
   shell> tar --exclude=*.rrd -zcf cacti_backup_YYYYMMDD.tgz cacti
   ```
6. Extract the Distribution Tarball:
   ```shell
   shell> tar -xzvf cacti-version.tar.gz
   ```
7. Copy the Distribution Tarball Over the Existing Installation:
   ```shell
   shell> /bin/cp -rpf cacti-version cacti
   ```
8. Set Appropriate Permissions:

   Set the appropriate permissions on Cacti's directories for graph/log generation. Execute these commands from inside Cacti's directory to change the permissions.
   ```shell
   shell> chown -R apache:apache rra/ log/
   ```
9. Recreate the Cache Folder (Optional):

   If you are using Performance > Image Caching or Realtime Graphing, recreate the cache folder and correct the permissions.
   ```shell
   shell> mkdir cache
   shell> chown -R apache:apache cache
    ```
   
10. Point Your Browser:

   Point your web browser to http://your-server/cacti/ and follow the on-screen instructions to update your database to the new version.

11. Re-enable Polling:

    Go to the console and re-enable the poller. It will take two polling cycles to update the remote pollers.

12. If Remote Pollers Fail to Update:

    Try to rebuild the Resource Cache by going to Console >> Utilities.

    If that fails, update the remote pollers that have failed to update.
