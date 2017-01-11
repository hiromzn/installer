---------------------
before RUN
---------------------
$ tar xf <this_tool_package>.tar

$ cd installer
$ vi common.env
ARCHIVE_DIR=${ARCHIVE_DIR:="<your_archive_dirctory_path>"}

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

# make all environment files into output/<instance_name>/env directory.
$ ./mkenv-all

# make all config files into output/<instance_name>/conf directory.
$ ./mkconf-all

# setup all instance of osuser/group, install jboss, setup httpd.
$ sudo ./mkall setup

# start all instance of httpd and jboss 
$ sudo ./mkall start

# do config of jboss using jboss-cli.sh
$ sudo ./mkall config

# deploy test ap into jboss
$ sudo ./mkall deploy

---------------------
controle user/group
---------------------
# add all user/group
$ sudo ./usergroup-all setup

# del all user/group
$ sudo ./usergroup-all clean

---------------------
how to clean
---------------------
# stop all httpd and jboss processes
$ sudo ./mkall stop

# clean up all config file and installation (user/group, httpd, jboss, systemd)
$ sudo ./mkall clean

--------------------------------
 directory structure & scripts
--------------------------------

   TOOL_HOME/
		common.env
		common.h
		env.base/
			httpd, jboss, systemctl[httpd/jboss]
		conf.base/
			httpd, jboss, systemctl[httpd/jboss], testapp

   : mkenv

   	./$OUTPUT_DIR/
	    <INST_NAME>/
		env/
			os, httpd, jboss, systemctl[httpd/jboss]
   : mkconf
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

