---------------------
before RUN
---------------------
$ tar xf <this_tool_package>.tar

$ cd installer

$ vi common.env
ARCHIVE_DIR=${ARCHIVE_DIR:="<your_archive_dirctory_path>"}
PG_SERVER_NAME=<DB_server_host_name>
PG_DB_USER_PASSWORD=<PostgreSQL_db_user_password>

$ ./mkall archive

$ cp jboss-eap-7.0.0.zip <your_archive_directory_path>
$ cp postgresql-9.4.1212.jre7.jar <your_archive_directory_path>

$ ls -1 <your_archive_directory_path>
app.war
jboss-eap-7.0.0.zip
postgresql-9.4.1212.jre7.jar
tomcat-connectors-1.2.42
tomcat-connectors-1.2.42.tar

---------------------
how to RUN
---------------------
$ hostanme
<WEB_AP_server>

// make all environment files into output/<instance_name>/env directory.
// make all config files into output/<instance_name>/conf directory.
// make all script for setup
// create tar package for DB and BATCH server setup

$ ./prepare all

// copy tar package to DB and BATCH server.
$ scp ../installer-package.tar <DB_SERVER>:
$ scp ../installer-package.tar <BATCH_SERVER>:

// change to root
$ sudo bash
password:
#

// setup all instance of osuser/group, install jboss, setup httpd, systemctl of httpd/jboss and enable service.
# ./mkall setup

// start all instance of httpd and jboss 
# ./mkall start

// do config of jboss using jboss-cli.sh
# ./mkall config

// deploy test ap into jboss
# ./mkall deploy

----------------------------------------
setup firewall (open port for services)
----------------------------------------
### WEB/AP server ###

// setup for os service port
$ sudo ./script/fw/fw.ap.add.sh

// setup for http service port
$ sudo ./script/fw/fw.http-all.add.sh

// setup for jboss service port
$ sudo ./script/fw.jboss-all.add.sh

// check active services
$ sudo ./fwctl lists
http-LXa ftp dhcpv6-client ssh http-LEa jboss-LEa jboss-LXa ...

### DB serer ###

$ mkdir installer
$ cd installer
$ tar xf $HOME/installer-package.tar
$ sudo ./script/fw/fw.db.add.sh

### BATCH serer ###

$ mkdir installer
$ cd installer
$ tar xf $HOME/installer-package.tar
$ sudo ./script/fw/fw.common.add.sh

-------------------------------------------------
clean firewall config (close port for services)
-------------------------------------------------
// run remove.sh, please !
$ sudo ./script/fw/fw.***.remove.sh

---------------------
controle user/group
---------------------
// add all user/group
$ sudo ./usergroupctl-all setup

// del all user/group
$ sudo ./usergroupctl-all clean

---------------------
how to clean
---------------------
// stop all httpd and jboss processes
$ sudo ./mkall stop

// clean up all config file, installation (user/group, httpd, jboss, systemd) and disable all services of httpd/jboss.
$ sudo ./mkall clean

// cleanup environment / config / script directory.
$ ./prepare clean

--------------------------------
 directory structure & scripts
--------------------------------

   TOOL_HOME/
		common.env .... common environment value
		common.h ...... common fuctions

		env.base/
			httpd, jboss, systemctl[httpd/jboss]

			## RULE ##
				ENV_NAME=__ENV_NAME__ ... depend on instance.
				ENV_NAME=$OTHER_ENV ..... NO depend on instance.
				ENV_NAME="VALUE" ........ NO depend on instance.

		conf.base/
			httpd, jboss, systemctl[httpd/jboss], testapp

   : mkenv
	## RULE ##
		replace __ENV_NAME__ --> value_of_each_instance

   	./$INSTANCE_DIR/
	    <INST_NAME>/
		env/
			os, httpd, jboss, systemctl[httpd/jboss]
   : mkconf
	## RULE ##
		1. evaluate *.env file.
		2. create config file using *.env file

		conf/
			httpd, jboss, systemctl[httpd/jboss]

   : setup
		logs/setup.httpd.log
		logs/setup.jboss.log
   : start
		logs/start.httpd.log
		logs/start.jboss.log

   : conf
		logs/conf.jboss.log

   : check
		logs/check.httpd.log
		logs/check.jboss.log

   : mkfirewall
	./fwctl		# controle script for firewall (setup/clean/etc...)
	./$SCRIPT_DIR/fw/
		./fw.ap.add.sh		# add FW config of web/ap server
		./fw.ap.remove.sh	# remove FW config of web/ap server
		./fw.db.add.sh		# add FW config of DB server
		./fw.db.remove.sh	# remove FW config of DB server
		./fw.common.add.sh	# add FW config of common server
		./fw.common.remove.sh	# remove FW config of common server

