Upgrading Cacti
===============

1.  Backup the old Cacti database.

        shell> mysqldump -l --add-drop-table cacti > mysql.cacti

    Note: You will probably have to specify the -u and -p flags for the MySQL username and password. This user must have permission to read from Cacti's database or you will end up with an empty backup.

2.  Backup the old Cacti directory.

        shell> mv cacti cacti_old

3.  Extract the distribution tarball.

        shell> tar xzvf cacti-version.tar.gz

4.  Rename the new Cacti directory to match the old one.

        shell> mv cacti-version cacti

5.  Edit `include/config.php` and specify the MySQL user, password and database for your Cacti configuration.

        $database_type = "mysql";
        $database_default = "cacti";
        $database_hostname = "localhost";
        $database_username = "cactiuser";
        $database_password = "cacti";

6.  Copy the *.rrd files from the old Cacti directory.

        shell> cp cacti_old/rra/* cacti/rra/

7.  Copy any relevant custom scripts from the old Cacti directory. Some script are updated between versions. Therefore, make sure you only over write if the scripts either don't exist or are newer than the distribution's.

        shell> cp -u cacti_old/scripts/* cacti/scripts/

8.  Copy any relevant custom resource XML files from the old Cacti directory. Some resource XML files are updated between versions. Therefore, make sure you only over write if the XML files either don't exist or are newer than the distribution's.

        shell> cp -u -R cacti_old/resource/* cacti/resource/

9.  Set the appropriate permissions on Cacti's directories for graph/log generation. You should execute these commands from inside Cacti's directory to change the permissions.

        shell> chown -R cactiuser rra/ log/

    (Enter a valid username for cactiuser, this user will also be used in the next step for data gathering.)

10. If you are using the optional feature Performance -> Image Caching, also recreate the folder and correct the permissions.

        shell> mkdir cache
        shell> chown -R cactiuser cache

11. Point your web browser to:

    > http://your-server/cacti/

    Follow the on-screen instructions so your database can be updated to the new version.

