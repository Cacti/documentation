# Upgrading Cacti under Windows

Download latest cacti-xxx.zip

1. Stop poller.
   Cacti > Configuration > Settings > Poller > uncheck Data Collection Enabled and Save.

2. Run Command Prompt as administrator and backup database.

   ```sh
   shell> cd Documents
   shell> "\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump.exe" -uroot -p -l
   --add-drop-table cacti > cacti-version-YYYYMMDD.sql
   ```

3. Backup the old Cacti directory.

   ```sh
   shell> cd \inetpub\wwwroot
   shell> robocopy cacti cacti-version-YYYYMMDD /s /b /copyall
   ```

4. Windows Update

5. MySQL Installer - update Catalog, then upgrade MySQL Server

6. Overwrite new Cacti version to production folder.
   Extract contents of cacti-xxx folder in cacti-xxx.zip to
   C:\inetpub\wwwroot\cacti\ and replace files.

7. Edit `include/config.php` and specify the MySQL user, password and database
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

8. Point your web browser to:

    `http://localhost/cacti/`

   Follow the on-screen instructions so your database can be updated to the new version.

   Open "MySQL 5.7 Command Line Client" and set variables as needed in following format:

   ```sh
   set global max_allowed_packet = 16777216;
   set global tmp_table_size = 67108864;
   set global join_buffer_size = 67108864;
   set global innodb_flush_log_at_timeout = 3;
   ```

9. Start poller.
   Cacti > Configuration > Settings > Poller > check Data Collection Enabled and Save.

---
Copyright (c) 2004-2019 The Cacti Group
