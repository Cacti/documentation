# Upgrading Cacti Under UNIX Compatible Operating Systems

To upgrade Cacti under UNIX style operating systems, you should use the
following instructions.  To upgrade Cacti on Windows, you should use the
instructions in the Link below:

[Upgrading in Windows](Upgrading-Cacti-Under-Windows.md)

1. Backup the old Cacti database.

   ```sh
   shell> mysqldump -l --add-drop-table --lock-tables=false cacti > mysql.cacti
   ```

   > **Note:** You will probably have to specify the -u and -p flags for the
   > MySQL username and password. This user must have permission to read from
   > Cacti's database or you will end up with an empty backup.

2. Backup the old Cacti directory with the exception of the RRD files which
   should not need backup.

   ```sh
   shell> tar --exclude=*.rrd -zcf cacti_backup_YYYYMMDD.tgz cacti
   ```

3. Extract the distribution tarball.

   ```sh
   shell> tar -xzvf cacti-version.tar.gz
   ```

4. Copy the distribution tarball over the existing installation.

   ```sh
   shell> /bin/cp -rpf cacti-version cacti
   ```

5. Set the appropriate permissions on Cacti's directories for graph/log
   generation. You should execute these commands from inside Cacti's directory
   to change the permissions.

   ```sh
   shell> chown -R cactiuser rra/ log/
   ```

   (Enter a valid username for cactiuser, this user will also be used in the
   next step for data gathering.)

6. If you are using the optional feature Performance -> Image Caching, also
   recreate the folder and correct the permissions.

    ```sh
    shell> mkdir cache
    shell> chown -R cactiuser cache
    ```

7. Point your web browser to:

    `http://your-server/cacti/`

    Follow the on-screen instructions so your database can be updated to the
    new version.

> Note that starting with Cacti 1.0, all **Data Collectors** will upgrade
> themselves automatically within two polling cycles.  If for some reason they
> do not, upgrade them one at a time.

---
Copyright (c) 2004-2019 The Cacti Group
