# Upgrading Cacti Under Windows

Download the [latest stable version](https://www.cacti.net/download_cacti.php)
of Cacti, referred to as `cacti-xxx.zip` in this document.

1. Stop the poller:
   - Cacti Console → Configuration → Settings → Poller
   - Uncheck **Data Collection Enabled** and save.

2. Run Command Prompt as Administrator and back up the database:

   ```sh
   shell> cd Documents
   shell> mysqldump.exe -uroot -p --single-transaction --add-drop-table cacti > cacti-version-YYYYMMDD.sql
   ```

   > **Note**: `mysqldump.exe` is located under your MySQL/MariaDB installation
   > bin directory, e.g. `%PROGRAMFILES%\MySQL\MySQL Server X.Y\bin\`.

3. Back up the old Cacti directory:

   ```sh
   shell> cd \inetpub\wwwroot
   shell> robocopy cacti cacti-version-YYYYMMDD /s /b /copyall
   ```

4. Run **Windows Update**.

5. Upgrade MySQL/MariaDB:
   - Open **MySQL Installer - Community** (or the MariaDB upgrade tool)
   - Update the catalog
   - Upgrade the server

6. Upgrade PHP:
   - Back up the `C:\php\` folder
   - Download a [supported PHP version](https://www.php.net/supported-versions.php)
     from [PHP for Windows](https://windows.php.net/download/) using the
     appropriate build for IIS (Non-Thread Safe + FastCGI) or Apache
   - Overwrite `C:\php\` with the contents of the new zip file

7. Install the new Cacti version:
   Extract the contents of the `cacti-xxx` folder from `cacti-xxx.zip` to
   `C:\inetpub\wwwroot\cacti\`, replacing existing files.

8. Edit `include/config.php` and verify the database connection details:

   ```sh
   shell> notepad cacti/include/config.php
   ```

   ```php
   $database_type     = "mysql";
   $database_default  = "cacti";
   $database_hostname = "localhost";
   $database_username = "cactiuser";
   $database_password = "cacti";
   ```

9. Browse to `http://localhost/cacti/` and follow the on-screen instructions
   to update the database schema to the new version.

   If any session variables need adjustment, set them from the MySQL/MariaDB
   command-line client:

   ```sql
   SET GLOBAL max_allowed_packet = 16777216;
   SET GLOBAL tmp_table_size = 67108864;
   SET GLOBAL join_buffer_size = 67108864;
   SET GLOBAL innodb_flush_log_at_timeout = 3;
   ```

10. Re-enable the poller:
    - Cacti Console → Configuration → Settings → Poller
    - Check **Data Collection Enabled** and save.

---
Copyright (c) 2004-2026 The Cacti Group
