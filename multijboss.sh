#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
# $Id: multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
#

. conf.h
. common.h
. usergroup.h

# controle multiple jboss eap instance

. multijboss.h

###############
# functions
###############

install_jboss() # num name
{
	num="$1"
	name="$2"
	user="`get_username $num`";
	group="`get_groupname $num`";
	jhome="`get_jbosshome $name`";
	jhomename="`basename $jhome`";
	echo "installing jboss : $JBOSS_INSTALL_ARCHIVE -> $jhome ..."
	(
		mkdir -p $jhome;
		cd $jhome
		cd ..
		rmdir $jhome
		unzip $JBOSS_INSTALL_ARCHIVE >/dev/null
		if [ $JBOSS_INSTALL_NAME != $jhomename ]; then
			mv $JBOSS_INSTALL_NAME $jhomename;
		fi
		chown -R $user:$group $jhome
	)
}

create_jboss_inst() # num name
{
	num="$1"
	name="$2"
	jhome=`get_jbosshome $name`;
	servername="`get_jboss_server_name $name`";
	user="`get_username $num`";
	group="`get_groupname $num`";

	base="`pwd`";
(
	cd $jhome;

	cp -rp ./standalone $servername
	mkdir $servername/bin
	cp -p bin/$JBOSS_CONF_FNAME $servername/bin
	cat $base/$JBOSS_CONF_BASE \
		|jboss_conf_filter $num $name \
		>$servername/bin/$JBOSS_CONF_FNAME

	cat $base/$JBOSS_RUN_BASE \
		|jboss_conf_filter $num $name \
		>$servername/bin/$JBOSS_RUN_FNAME
	chmod $JBOSS_RUN_PERM $servername/bin/$JBOSS_RUN_FNAME

	chperm $servername $user $group
)
}

clean_jboss() # name
{
	name="$1"
	jhome=`get_jbosshome $name`;
	echo "removing jboss : $jhome ..."
	rm -rf $jhome
}

setup_jboss_web_container() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	su - $user -c "$jbosscli" <<EOF
/subsystem=undertow/server=default-server/ajp-listener=default-ajp:add(socket-binding=ajp)
/subsystem=undertow/server=default-server/ajp-listener=default-ajp:write-attribute(name=no-request-timeout,value=600000)
/subsystem=undertow/server=default-server/ajp-listener=default-ajp:write-attribute(name=tcp-keep-alive,value=true)
EOF
}

setup_jboss_io() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	su - $user -c "$jbosscli" <<EOF
/subsystem=io/worker=default:write-attribute(name=task-max-threads,value=400)
EOF
}

add_jboss_default_group() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	su - $user -c "$jbosscli" <<EOF
cd /core-service=management/access=authorization
:write-attribute(name=provider,value=rbac)
reload
./role-mapping=Monitor:add
./role-mapping=Monitor/include=group-$JBOSS_MONITOR_GROUP:add(name=$JBOSS_MONITOR_GROUP,type=Group)
./role-mapping=Deployer:add
./role-mapping=Deployer/include=group-$JBOSS_DEPLOYER_GROUP:add(name=$JBOSS_DEPLOYER_GROUP,type=Group)
./role-mapping=SuperUser/include=group-$JBOSS_SUPERUSER_GROUP:add(name=$JBOSS_SUPERUSER_GROUP,type=Group)
EOF
}

add_jboss_user() # num name
{
	num="$1";
	name="$2";
	jhome="`get_jbosshome $name`";
	shome="`get_jboss_server_home $name`";
	cmd="$jhome/bin/add-user.sh";
	conf="$shome/configuration/";

	$cmd -sc $conf -u $JBOSS_MONITOR_USER -p $JBOSS_USER_PASSWORD -g $JBOSS_MONITOR_GROUP
	$cmd -sc $conf -u $JBOSS_DEPLOYER_USER -p $JBOSS_USER_PASSWORD -g $JBOSS_DEPLOYER_GROUP
	$cmd -sc $conf -u $JBOSS_ADMIN -p $JBOSS_USER_PASSWORD -g $JBOSS_SUPERUSER_GROUP
}

setup_jdbc_driver() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	echo "MESSAGE: JBoss setup JDBC driver for $name"
	su - $user -c "$jbosscli" <<EOF
module add --name=org.postgresql.jdbc --resources=$JBOSS_JDBC_DRIVER --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=postgresql,driver-module-name=org.postgresql.jdbc,driver-xa-datasource-class-name=org.postgresql.xa.PGXADataSource)
EOF
}

deploy_testap() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	echo "MESSAGE: JBoss setup TEST application for $name"
	su - $user -c "$jbosscli" <<EOF
deploy $JBOSS_TESTAP
EOF
}

#OFF# setup_xa_data_source() # num name

setup_data_source() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	JBOSS_DS_NAME=${name}DS
	JBOSS_DS_DB_NAME=${name}DB
	JBOSS_DS_USER_NAME=${name}DU
	echo "MESSAGE: JBoss setup Data source for $name"
	su - $user -c "$jbosscli" <<EOF
data-source add --name=$JBOSS_DS_NAME --driver-name=postgresql --connection-url=jdbc:postgresql://$JBOSS_DS_SERVER_NAME:$JBOSS_DS_SERVER_PORT/$JBOSS_DS_DB_NAME --jndi-name=java:jboss/datasources/$JBOSS_DS_NAME --user-name=$JBOSS_DS_USER_NAME --password=$JBOSS_DS_PASSWORD
data-source --name=$JBOSS_DS_NAME --max-pool-size=20
data-source --name=$JBOSS_DS_NAME --min-pool-size=5
data-source --name=$JBOSS_DS_NAME --pool-prefill=true
data-source --name=$JBOSS_DS_NAME --query-timeout=300
data-source --name=$JBOSS_DS_NAME --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker
data-source --name=$JBOSS_DS_NAME --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter
reload
EOF
}

check_data_source() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	JBOSS_DS_NAME=${name}DS
	echo "MESSAGE: JBoss CHECK Data source for $name"
	su - $user -c "$jbosscli" <<EOF
data-source test-connection-in-pool --name=$JBOSS_DS_NAME
EOF
}

setup_jboss_transaction() # num name
{
	num="$1";
	name="$2";
	user="`get_username $num`";
	jhome="`get_jbosshome $name`";
	jbosscli="$jhome/bin/$JBOSS_CLI `get_jboss_cli_opt $num`";
	JBOSS_TRAN_NODEID="`get_jboss_server_name $name`";
	echo "MESSAGE: JBoss setup transaction for $name"
	su - $user -c "$jbosscli" <<EOF
/subsystem=transactions:write-attribute(name=default-timeout,value=$JBOSS_TRAN_TIMEOUT)
reload
/subsystem=transactions:write-attribute(name=node-identifier,value=$JBOSS_TRAN_NODEID)
EOF
}

#######################
# check
#######################

check_port() # name
{
	log="`get_jboss_server_home $1`/log/server.log";
	grep -e WFLYUT0006 -e WFLYSRV0051 $log
}

wait_startup() # name
{
	# wait admin console port ready
	name=$1;
	log="`get_jboss_server_home $1`/log/server.log";
	echo "MESSAGE : waiting $name JBoss admin console port"
	while [ true ]
	do
		echo -n ".";
		sleep 1;
		grep WFLYSRV0051 $log >/dev/null
		if [ "$?" -eq 0 ]; then
			url=`grep WFLYSRV0051 $log |tail -1 |sed 's[.* \(http://.*\) .*[\1['`;
			echo "MESSAGE : JBoss $name console url($url) is ready !";
			return 0;
		fi
	done
}

######################

usage()
{
cat <<EOF
controle multiple jboss instance

command name : $0

usage :
  ## CONFIG ##
  setup :
	$0 setup
  clean :
	$0 clean
  check :
	$0 check

  ## PROCESS ##
  start:
	$0 start instance_number
  stop:
	$0 stop instance_number
  check all httpd process:
	$0 checkps
EOF
}

addconfig_set() # num inst
{
	num=$1;
	inst=$2;

	echo "add web config : $inst"
	setup_jboss_web_container $num $inst
	echo "add io config : $inst"
	setup_jboss_io $num $inst
	setup_jdbc_driver $num $inst;
	setup_data_source $num $inst;
	check_data_source $num $inst;
	setup_jboss_transaction $num $inst;
}

#####################
#
# main
#
#####################
main()
{
case "$1" in
##### setup ######
setup )
	i=0;
	for name in ${INST_LIST[@]}
	do
		install_jboss $i $name;
		create_jboss_inst $i $name;
		i=`expr $i + 1`;
	done
	;;
check )
	for name in ${INST_LIST[@]}
	do
		echo "##### checking JBoss INSTANCE #$name"
		ls -ld `get_jbosshome $name`;
		check_port $name;
	done
	;;

wait )
	for name in ${INST_LIST[@]}
	do
		wait_startup $name;
	done
	;;

clean )
	for name in ${INST_LIST[@]}
	do
		echo "CLEANING: instance $name"
		clean_jboss $name;
	done
	;;

getinstlist )
	echo -n "instance :"
	i=0;
	for name in ${INST_LIST[@]}
	do
		echo -n " $i:$name"
		i=`expr $i + 1`;
	done
	echo "";
	;;

deploytestap ) # script development test
	prepare_testap;
	num=0;
	for inst in ${INST_LIST[@]}
	do
		deploy_testap $num $inst;
		num=`expr $num + 1`;
	done
	clean_testap;
	;;

addconfig )
	prepare_jdbc_driver;
	if [ "$2" = "all" ]; then
		echo "add config : ALL"
		num=0;
		for inst in ${INST_LIST[@]}
		do
			addconfig_set $num $inst;
			num=`expr $num + 1`;
		done
	else
		num="$2";
		inst="`get_instname $num`";
		addconfig_set $num $inst;
	fi
	clean_jdbc_driver;
	;;

adduser )
	if [ "$2" = "all" ]; then
		echo "add default group : ALL"
		num=0;
		for inst in ${INST_LIST[@]}
		do
			echo "add default group : $inst"
			add_jboss_default_group $num $inst
			echo "add user : $inst"
			add_jboss_user $num $inst
			num=`expr $num + 1`;
		done
	else
		num="$2";
		inst="`get_instname $num`";
		echo "add default group : $num:$inst";
		add_jboss_default_group $num $inst
		echo "add user : $num:$inst";
		add_jboss_user $num $inst
	fi
	;;

checkps )
	ps -ef |grep httpd
	;;

-? | * )
	usage;
	exit 1;
	;;
esac
}


main $*;

