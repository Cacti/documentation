# Upgrading Cacti Under FreeBSD

1. Back up the old Cacti database.

   ```sh
   shell> mysqldump --single-transaction --add-drop-table cacti > mysql.cacti
   ```

   > **Note**: You will probably need to specify `-u` and `-p` for the MySQL
   > username and password. This user must have permission to read from Cacti's
   > database or you will end up with an empty backup.
   >
   > `--single-transaction` provides a consistent InnoDB snapshot without
   > locking tables, which is the correct approach for Cacti's InnoDB schema.

2. Back up the old Cacti directory.

   ```sh
   shell> cd /usr/local/share
   shell> tar -zcf cacti_backup_YYYYMMDD.tgz cacti
   ```

3. Install the new version from compiled packages or FreeBSD ports.

   ```sh
   shell> pkg delete cacti
   shell> pkg install cacti
   ```

   or

   ```sh
   shell> pkg install git
   shell> git clone https://git.FreeBSD.org/ports.git /usr/ports
   shell> git -C /usr/ports pull
   shell> cd /usr/ports/net-mgmt/cacti
   shell> make deinstall clean install
   ```

4. If you are using the optional **Performance → Image Caching** feature,
   recreate the cache folder and set the correct permissions.

   ```sh
   shell> cd /usr/local/share/cacti
   shell> mkdir cache
   shell> chown -R cacti cache
   ```

5. Browse to `http://your-server/cacti/` and follow the on-screen instructions
   to update the database schema to the new version.

> **Note**: Starting with Cacti 1.0, all Data Collectors upgrade themselves
> automatically within two polling cycles. If they do not, upgrade them one
> at a time.

---
Copyright (c) 2004-2026 The Cacti Group
