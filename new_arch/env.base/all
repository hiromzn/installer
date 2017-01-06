#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/functions.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
# $Id: functions.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
#

# project name
PROJ_NAME=jast

# multi instance list
#INST_LIST="00 01 02 03 04 05 06"
#INST_LIST="00 01 02 03"
#INST_LIST=(LXa LEa LJa LVa SDa LXb LJb LVb SDb); # 9 instance

# INST_LIST=(LXa LEa LJa); # 3 instance
INST_LIST=(LXa LEa); # for small TEST
# INST_LIST=(LXa); # for 1 TEST

OS_USER_NAME_LIST=(); # ex) LXaOU, LEaOU, ...
OS_GROUP_NAME_LIST=(); # ex) LXaOG, LEaOG, ...

# test data 
# INST_LIST=(00 01 02)
# OS_USER_NAME_LIST=("user1" "user2" "user3")
# OS_GROUP_NAME_LIST=("user1g" "user2g" "user3g")

##################
# naming policy
##################

# LXa	: instance name

# LXaOU : OS user name
# LXaOG : OS group name
# LXa	: /jast/home/LXa/ home dir name of instance set name

# LXaAU : jboss user name
# LXaAG : jboss user name
# LXaDU : postgre DB connect user name

#####################
# directory designe
#####################

#DEV_ENV:

# /jast/home/<InstName>/

# /jast/home/<InstName>/opt/httpd/
# /jast/home/<InstName>/opt/httpd/conf/
# /jast/home/<InstName>/opt/httpd/run/
# /jast/home/<InstName>/opt/httpd/logs/

# /jast/home/<InstName>/opt/jbosseap/
# /jast/home/<InstName>/opt/jbosseap/,conf,etc...

#PRO_ENV:

# /jast/home/<InstName>
# /opt/httpd/
# /opt/jbosseap/

#######################
# OS USER / GROUP
#######################

OS_USER_ARY=();
OS_USER_ARY_RECORD_OFFSET=7;
	# userName UID groupName GID homePath homePermit INSTANCE_NAME
OS_USER_ID_BASE=5000;
OS_GROUP_ID_BASE=6000;
OS_USER_HOME_FMT="/$PROJ_NAME/home/%s";
# CAUTION : Please make directory /proj/home by manual.
OS_USER_HOME_PERMIT=750

#######################
# HTTPD
#######################

HTTPD_LISTEN_PORT_BASE=81

ORG_TOPDIR=/etc/httpd
ORG_TOPDIR_PERM="root root 755"
NEW_TOPDIR=
NEW_TOPDIR_FMT="/$PROJ_NAME/home/%s/opt/httpd"
get_httpd_topdir() { printf "$NEW_TOPDIR_FMT" $1; } # name
#NEW_TOPDIR_FMT="/etc/httpd-%s"
#get_httpd_topdir() { printf "$NEW_TOPDIR_FMT" `printf "%02d" $1`; }

ORG_HTTPD_MODULES_ROOT=
ORG_HTTPD_MODULES_ABS=/usr/lib64/httpd/modules
NEW_HTTPD_MODULES_ROOT_FMT="/$PROJ_NAME/home/%s/opt/httpd/modules"
get_httpd_moduledir() { printf "$NEW_HTTPD_MODULES_ROOT_FMT" $1; }

#-------------------
# configration file
#-------------------

HTTPD_CONF_FILE=
HTTPD_CONF_FILE_MOD=644

# BASE of configuration
HTTPD_BASE_CONFDIR="./apache";
HTTPD_CONF_BASE="$HTTPD_BASE_CONFDIR/etc_httpd_conf_httpd.conf.BASE"
HTTPD_CUSTOM_BASE="$HTTPD_BASE_CONFDIR/custom.conf.BASE"
HTTPD_MODJK_BASE="$HTTPD_BASE_CONFDIR/mod_jk.conf.BASE"
HTTPD_WORKERS_BASE="$HTTPD_BASE_CONFDIR/workers.properties.BASE"

ORG_HTTPD_CONF=$ORG_TOPDIR/conf/httpd.conf
ORG_HTTPD_CONF_PERM="root root 644"
get_httpd_conffile() # name
	{ echo -e "`get_httpd_topdir $1`/conf/httpd.conf"; }
get_httpd_confd() # name
	{ echo -e "`get_httpd_topdir $1`/conf.d"; }
get_httpd_conf_custom_file() # name
	{ echo -e "`get_httpd_topdir $1`/conf.d/custom.conf"; }
get_httpd_conf_modjk_file() # name
	{ echo -e "`get_httpd_topdir $1`/conf.d/mod_jk.conf"; }
get_httpd_conf_workers_file() # name
	{ echo -e "`get_httpd_topdir $1`/conf.d/workers.properties"; }

#--------
# config
#--------
HTTPD_WORKER_SERVER1_HOST=127.0.0.1
HTTPD_WORKER_SERVER1_PORT_DEFAULT=8009
HTTPD_WORKER_SERVER1_PORT_BASE=8109	# DEFAULT + OFFSET
HTTPD_WORKER_SERVER1_PORT_OFFSET=100

HTTPD_WORKER_SERVER2_HOST=127.0.0.1
HTTPD_WORKER_SERVER2_PORT_DEFAULT=8009

get_httpd_core_dump_dir() # name
{
	echo "`get_httpd_topdir $1`/run";
}

get_httpd_worker_host() # id name
{
	id=$1;
	name=$2;
	case "$id" in
	1 ) echo "$HTTPD_WORKER_SERVER1_HOST" ;;
	2 ) echo "$HTTPD_WORKER_SERVER2_HOST" ;;
	* ) echo "BAD_ID_ARG_IN_get_httpd_worker_host (id:$id, name:$name)" 1>&2; exit 1 ;;
	esac
}

get_httpd_worker_port() # id name num
{
	id=$1;
	name=$2;
	num=$3;
	case "$id" in
	1 ) echo "`expr $HTTPD_WORKER_SERVER1_PORT_BASE \
		+ $HTTPD_WORKER_SERVER1_PORT_OFFSET \* $num`" ;;
	* ) echo "BAD_ID_ARG_IN_get_httpd_worker_port (id:$id, name:$name, num:$num)" 1>&2;
		exit 1 ;;
	esac
}

# for TEST
TEST_WELCOME_BASE="$HTTPD_BASE_CONFDIR/index_test.html";

ORG_WWW_ROOT="/var/www"
ORG_WWW_ROOT_PERM="root root 755"
NEW_WWW_ROOT=
NEW_WWW_ROOT_FMT="/$PROJ_NAME/home/%s/opt/httpd/www"
get_httpd_wwwroot() { printf "$NEW_WWW_ROOT_FMT" $1; }
#NEW_WWW_ROOT_FMT="/var/www-%s"
#get_httpd_wwwroot() { printf "$NEW_WWW_ROOT_FMT" `printf "%02d" $1`; }

ORG_DOC_ROOT="/var/www/html"
ORG_DOC_ROOT_PERM="root root 755"
NEW_DOC_ROOT_FMT="/$PROJ_NAME/home/%s/opt/httpd/www/html"
get_httpd_docroot() { printf "$NEW_DOC_ROOT_FMT" $1; }
#NEW_DOC_ROOT_FMT="/var/www-%s/html"
#get_httpd_docroot() { printf "$NEW_DOC_ROOT_FMT" `printf "%02d" $1`; }

ORG_CGI_ROOT="/var/www/cgi-bin"
ORG_CGI_ROOT_PERM="root root 755"
NEW_CGI_ROOT_FMT="/$PROJ_NAME/home/%s/opt/httpd/www/cgi-bin"
get_httpd_cgiroot() { printf "$NEW_CGI_ROOT_FMT" $1; }
#NEW_CGI_ROOT_FMT="/var/www-%s/cgi-bin"
#get_httpd_cgiroot() { printf "$NEW_CGI_ROOT_FMT" `printf "%02d" $1`; }

ORG_RUN_DIR=$ORG_TOPDIR/run
ORG_RUN_DIR_PERM="root apache 710"
ORG_RUN_DIR_ABS_FMT="/$PROJ_NAME/home/%s/opt/httpd/run"
get_httpd_rundir_abs() { printf "${ORG_RUN_DIR_ABS_FMT}" $1; }
#ORG_RUN_DIR_LINKNAME=`file -b $ORG_RUN_DIR |sed "s[.*\ .\(.*\)'[\1["`
	# 2.2 : ../../var/run/httpd
	# 2.4 : /run/httpd
#ORG_RUN_DIR_ABS=`echo $ORG_RUN_DIR_LINKNAME |sed -e 's[\.\.\/[[g' -e 's[^/*[[g' -e 's[^[/['`
	# 2.2 : /var/run/httpd
	# 2.4 : /run/httpd

ORG_LOG_DIR=$ORG_TOPDIR/logs
ORG_LOG_DIR_PERM="root root 700"
ORG_LOG_DIR_ABS_FMT="/$PROJ_NAME/home/%s/opt/httpd/logs"
get_httpd_logdir_abs() { printf "${ORG_LOG_DIR_ABS_FMT}" $1; }
#ORG_LOG_DIR_LINKNAME=`file -b $ORG_LOG_DIR |sed "s[.*\ .\(.*\)'[\1["`
	# 2.2/2.4 : ../../var/log/httpd
#ORG_LOG_DIR_ABS=`echo $ORG_LOG_DIR_LINKNAME |sed -e 's[\.\.\/[[g' -e 's[^/*[[g' -e 's[^[/['`
	# 2.2/2.4 : /var/log/httpd
#get_httpd_logdir_abs() { printf "${ORG_LOG_DIR_ABS}-%02d" $1; }

httpd_conf_filter() # num name
{
        num="$1";
        name="$2";

        topdir="`get_httpd_topdir $name`";
        listen="`expr $HTTPD_LISTEN_PORT_BASE + $num`";
        wwwroot="`get_httpd_wwwroot $name`";
        docroot="`get_httpd_docroot $name`";
        cgiroot="`get_httpd_cgiroot $name`";
        user="`get_username $num`";
        group="`get_groupname $num`";
        coredir="`get_httpd_core_dump_dir $name`";
        host="`get_httpd_worker_host 1 $name`";
        port="`get_httpd_worker_port 1 $name $num`";
	sconffile="`get_sysconfigfile httpd $name`";
	conffile="`get_httpd_conffile $name`";

        timestamp="`date $DATE_TIME_FMT`";

        sed \
                -e "s[__CREATE_DATE__[$timestamp[g" \
                -e "s[__HTTPD_SERVER_ROOT__[$topdir[g" \
                -e "s[__HTTPD_DOCUMENT_ROOT__[$docroot[g" \
                -e "s[__HTTPD_WWW_ROOT__[$wwwroot[g" \
                -e "s[__HTTPD_CGI_ROOT__[$cgiroot[g" \
                -e "s[__HTTPD_LISTEN__[$listen[g" \
                -e "s[__HTTPD_USER__[$user[g" \
                -e "s[__HTTPD_GROUP__[$group[g" \
                -e "s[__HTTPD_CORE_DUMP_DIR__[$coredir[" \
                -e "s[__HTTPD_WORKER_SERVER1_HOST__[$host[" \
                -e "s[__HTTPD_WORKER_SERVER1_PORT__[$port[" \
                -e "s[__HTTPD_SYSCONFIG_FILE__[$sconffile[" \
                -e "s[__HTTPD_CONF_FILE__[$conffile[" \
                ;
}

#----------
# mod_jk
#----------

HTTPD_MOD_JK_BIN_PATH=./apache/mod_jk/mod_jk.so
get_httpd_mod_jk_path() # name
{
	echo "`get_httpd_moduledir $1`/mod_jk.so";
}
install_mod_jk() # name
{
	modjkpath=`get_httpd_mod_jk_path $1`;
	bin=$HTTPD_MOD_JK_BIN_PATH
	if [ -s "$bin" ]; then
		echo "MESSAGE: installing $bin to $modjkpath"
		cp $bin $modjkpath
		chmod 755 $modjkpath
		chown root:root $modjkpath
	else
		echo "ERROR: check $bin file...."
	fi
}

##############################
# JBoss EAP
##############################

# directory structure
#
# JBOSS_HOME = $JAST_USER_HOME/opt/jboss-eap-7.0/
#
# $JOBSS_HOME ... JBOSS home directory
#	./bin/
#		stadalone.conf
#	./standalone/
#	./<server1>/ .... instance home directory
#		./bin/
#			./standalone.conf : (copy from $JBOSS_HOME/bin/)
#		./configuration/
#			./standalone.xml
#		./deployments/
#		./lib/
#		./tmp/
#	./modules/
#

JBOSS_INSTALL_ARCHIVE=`pwd`/jboss/jboss-eap-7.0.0.zip
JBOSS_INSTALL_NAME=jboss-eap-7.0

JBOSS_HOME_NAME="jbosseap"
JBOSS_HOME_FMT="$OS_USER_HOME_FMT/opt/$JBOSS_HOME_NAME"
get_jbosshome()
{
	printf "$JBOSS_HOME_FMT" $1;
}

#
# JBOSS_SERVER_HOME_FMT
#   ex) /jast/home/<instname>/opt/jboss-eap-7.0/<instname>
JBOSS_SERVER_HOME_FMT="$OS_USER_HOME_FMT/opt/$JBOSS_HOME_NAME/%s";
get_jboss_server_name() { echo "${1}A"; } # name (:= INSTANCE_NAME)
get_jboss_server_home() # name
{
	printf "$JBOSS_SERVER_HOME_FMT" $1 `get_jboss_server_name $1`;
}

JBOSS_START_SCRIPT_NAME="jbosseap.sh";
JBOSS_CONFIG_NAME="standalone.xml";

#
# JAVA
#
if [ ! -d "$JBOSS_JAVA_HOME" ]
then
#pccoe# JBOSS_JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.102-4.b14.el7.x86_64/jre/
# macbook # JBOSS_JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.111-2.b15.el7_3.x86_64/jre
JBOSS_JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.111-2.b15.el7_3.x86_64/jre
if [ ! -d "$JBOSS_JAVA_HOME" ]
then
	jh=`ls -d /usr/lib/jvm/java-1.8.0-openjdk-1.8*/jre |tail -1`;
	if [ -d "$jh" ]
	then
		echo "MESSAGE : JBOSS_JAVA_HOME was set to $jh"
		JBOSS_JAVA_HOME=$jh
	else
		echo "ERROR : can't find JAVA_HOME in $JBOSS_JAVA_HOME or $jh"
		echo "        check Java 1.8 jre home directory"
		exit 1;
	fi	
fi
fi
# JBOSS_JAVA_OPTS="-Xms512m -Xmx512m -XX:MaxMetaspaceSize=256m"; # STD doc.
JBOSS_JAVA_OPTS="-Xms128m -Xmx256m -XX:MaxMetaspaceSize=128m"; # my TEST

#
# configurataion
#
JBOSS_BASE_CONFDIR="./jboss";
JBOSS_CONF_FNAME="standalone.conf";
JBOSS_CONF_BASE="$JBOSS_BASE_CONFDIR/$JBOSS_CONF_FNAME.BASE";
JBOSS_RUN_FNAME="jbosseap.sh";
JBOSS_RUN_PERM="744";
JBOSS_RUN_BASE="$JBOSS_BASE_CONFDIR/$JBOSS_RUN_FNAME.BASE";

JBOSS_WEB_PORT_BASE=8080
JBOSS_ADMIN_PORT_BASE=9990

JBOSS_PORT_OFFSET_BASE_OFFSET=100
JBOSS_PORT_OFFSET=
JBOSS_BIND_ADDR=0.0.0.0
JBOSS_MGMT_ADDR=0.0.0.0

get_jboss_port_offset() # num
	{ echo `expr $JBOSS_PORT_OFFSET_BASE_OFFSET \* \( $num + 1 \)`; }
get_jboss_web_port() # num
	{ echo `expr $JBOSS_WEB_PORT_BASE + \
		$JBOSS_PORT_OFFSET_BASE_OFFSET \* \( $num + 1 \)`; }
get_jboss_admin_port() # num
	{ echo `expr $JBOSS_ADMIN_PORT_BASE + \
		$JBOSS_PORT_OFFSET_BASE_OFFSET \* \( $num + 1 \)`; }

#--------------
# cli
#--------------
JBOSS_CLI=jboss-cli.sh
get_jboss_cli_opt() # num
	{ echo -c --controller=127.0.0.1:`get_jboss_admin_port $num`; }

#
# JBoss user/group
#
JBOSS_MONITOR_GROUP=MonitorGroup
JBOSS_DEPLOYER_GROUP=DeployerGroup
JBOSS_SUPERUSER_GROUP=SuperUserGroup

JBOSS_MONITOR_USER=monitor
JBOSS_DEPLOYER_USER=deployer
JBOSS_ADMIN=admin
JBOSS_USER_PASSWORD=password
#ORG# JBOSS_USER_PASSWORD=p@ssw0rd


#----------------------
# data source
#----------------------
JBOSS_JDBC_DRIVER_FNAME="postgresql-9.4.1212.jre7.jar"
JBOSS_JDBC_DRIVER_ORG="$JBOSS_BASE_CONFDIR/jdbc/$JBOSS_JDBC_DRIVER_FNAME"
JBOSS_JDBC_DRIVER="/tmp/$JBOSS_JDBC_DRIVER_FNAME"
prepare_jdbc_driver()
{
	cp $JBOSS_JDBC_DRIVER_ORG $JBOSS_JDBC_DRIVER
	chmod o+r $JBOSS_JDBC_DRIVER
}
clean_jdbc_driver(){ rm $JBOSS_JDBC_DRIVER; }

#----------------------
# test application
#----------------------
JBOSS_TESTAP_FNAME="app.war"
JBOSS_TESTAP_ORG="$JBOSS_BASE_CONFDIR/testap/$JBOSS_TESTAP_FNAME"
JBOSS_TESTAP="/tmp/$JBOSS_TESTAP_FNAME"
prepare_testap()
{
	cp $JBOSS_TESTAP_ORG $JBOSS_TESTAP
	chmod o+r $JBOSS_TESTAP
}
clean_testap(){ rm $JBOSS_TESTAP; }

# JBOSS_DS_NAME=PgsqlDS
JBOSS_DS_SERVER_NAME=127.0.0.1
JBOSS_DS_SERVER_PORT=5432
# JBOSS_DS_DB_NAME=user01db
# JBOSS_DS_USER_NAME=user01
JBOSS_DS_PASSWORD=password

#----------------------
# transaction
#----------------------
JBOSS_TRAN_TIMEOUT=300 # sec
JBOSS_TRAN_NODEID= # = JBOSS_SERVER_NAME

jboss_conf_filter() # num name
{
	num="$1";
	name="$2";

	jhome="`get_jbosshome $name`";
	shome="`get_jboss_server_home $name`";
	sname="`get_jboss_server_name $name`";
	user="`get_username $num`";
	group="`get_groupname $num`";
	scriptname=$JBOSS_START_SCRIPT_NAME;
	poffset="`get_jboss_port_offset $num`";

	sed \
		-e "s[__JBOSS_USER__[$user[g" \
		-e "s[__JBOSS_GROUP__[$group[g" \
		-e "s[__JBOSS_HOME__[$jhome[g" \
		-e "s[__JBOSS_JAVA_HOME__[$JBOSS_JAVA_HOME[g" \
		-e "s[__JBOSS_JAVA_OPTS__[$JBOSS_JAVA_OPTS[g" \
		-e "s[__JBOSS_CONFIG_NAME__[$JBOSS_CONFIG_NAME[g" \
		-e "s[__JBOSS_SERVER_NAME__[$sname[g" \
		-e "s[__JBOSS_SERVER_HOME__[$shome[g" \
		-e "s[__JBOSS_START_SCRIPT_NAME__[$scriptname[g" \
		-e "s[__JBOSS_PORT_OFFSET__[$poffset[g" \
		-e "s[__JBOSS_BIND_ADDR__[$JBOSS_BIND_ADDR[g" \
		-e "s[__JBOSS_MGMT_ADDR__[$JBOSS_MGMT_ADDR[g" \
		;
}

##############################
# systemctl
##############################

SYSTEMCTL_BASE_CONFDIR=./systemctl

SERVICE_DIR=/etc/systemd/system
SERVICE_FILE_BASE_FMT="$SYSTEMCTL_BASE_CONFDIR/%s.service.BASE"
SERVICE_FILE_FMT="%s-%s.service"
#get_servicename() { printf "$SERVICE_FILE_FMT" $1 `printf "%02d" $2`; }
get_servicename() { printf "$SERVICE_FILE_FMT" $1 $2; }
get_servicefile() { printf "$SERVICE_DIR/%s" "`get_servicename $1 $2`"; }
get_servicefile_base() { printf "$SERVICE_FILE_BASE_FMT" $1; }

#
# environment configration file
#
SYSCONFIG_DIR=/etc/sysconfig
SYSCONFIG_FILE_BASE=$SYSTEMCTL_BASE_CONFDIR/httpd.BASE
SYSCONFIG_FILE_FMT="$SYSCONFIG_DIR/%s-%s"
get_sysconfigfile() { printf "$SYSCONFIG_FILE_FMT" $1 $2; } # base name

