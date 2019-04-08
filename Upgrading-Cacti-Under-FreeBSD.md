# Upgrading Cacti Under FreeBSD


1. Backup the old Cacti database.

   ```sh
   shell> mysqldump -l --add-drop-table --lock-tables=false cacti > mysql.cacti
   ```

   > **Note:** You will probably have to specify the -u and -p flags for the
   > MySQL username and password. This user must have permission to read from
   > Cacti's database or you will end up with an empty backup.

2. Backup the old Cacti directory.

   ```sh
   shell> cd /usr/local/share
   shell> tar -zcf cacti_backup_YYYYMMDD.tgz cacti
   ```

3. Install new version from compiled packages or FreeBSD ports.

   ```sh
   shell> pkg delete cacti
   shell> pkg install cacti
   ```
   
   or

   
   ```sh
   shell> portsnap fetch update
   shell> cd /usr/ports/net-mgmt/cacti
   shell> make deinstall clean install
   ```

4. If you are using the optional feature Performance -> Image Caching, also recreate the folder and correct the permissions.

    ```sh
    shell> mkdir cache
    shell> chown -R cacti cache
    ```

5. Point your web browser to:

    `http://your-server/cacti/`

    Follow the on-screen instructions so your database can be updated to the
    new version.

> Note that starting with Cacti 1.0, all **Data Collectors** will upgrade themselves automatically within two polling cycles.  If for some reason they do not, upgrade them one at a time.

---
Copyright (c) 2004-2019 The Cacti Group
