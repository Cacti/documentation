# Upgrading Cacti under Windows

Download [latest stable version](https://www.cacti.net/download_cacti.php)
of Cacti which is referred to as `cacti-xxx.zip` in this document.

1. Stop poller.

   - Cacti Console

   - Configuration

   - Settings

   - Poller

   - uncheck Data Collection Enabled and Save

1. Run Command Prompt as administrator and backup database.

   ```sh
   shell> cd Documents
   shell> "\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump.exe" -uroot -p -l --add-drop-table cacti > cacti-version-YYYYMMDD.sql
   ```

1. Backup the old Cacti directory.

   ```sh
   shell> cd \inetpub\wwwroot
   shell> robocopy cacti cacti-version-YYYYMMDD /s /b /copyall
   ```

1. Windows Update

1. MySQL

   - Open `MySQL Installer - Community`

   - update Catalog

   - upgrade MySQL Server

1. PHP

   - Backup `C:\php\` folder

   - Download a [supported version](http://php.net/supported-versions.php) of
   [PHP for Windows](https://windows.php.net/download/) using the appropriate
   build for IIS or Apache. If missing, install the appropriate VC build.

   - Overwrite `C:\php\` folder contents from zip file.

1. Overwrite new Cacti version to production folder.
   Extract contents of `cacti-xxx` folder in `cacti-xxx.zip` to
   `C:\inetpub\wwwroot\cacti\` and replace files.

1. Edit `include/config.php` and specify the MySQL user, password and database
   for your Cacti configuration.

   ```sh
   shell> notepad cacti/include/config.php
   ```

   ```php
   $database_type = "mysql";
   $database_default = "cacti";
   $database_hostname = "localhost";
   $database_username = "cactiuser";
   $database_password = "cacti";
   ```

1. Point your web browser to: `http://localhost/cacti/`

   Follow the on-screen instructions so your database can be updated to the
   new version.

   Open "MySQL 5.7 Command Line Client" and set variables as needed in
   following format:

   ```sh
   set global max_allowed_packet = 16777216;
   set global tmp_table_size = 67108864;
   set global join_buffer_size = 67108864;
   set global innodb_flush_log_at_timeout = 3;
   ```

1. Start poller

   - Cacti Console

   - Configuration

   - Settings

   - Poller

   - check Data Collection Enabled and Save

---
<copy>Copyright (c) 2004-2023 The Cacti Group</copy>
