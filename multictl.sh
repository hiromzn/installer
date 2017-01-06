#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
# $Id: multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
#

. conf.h
. common.h
. usergroup.h
. multiapache.h
. multijboss.h

DEBUG=on

# controle multiple systemctl instance

##############################
#
# cofiguration
#
##############################

#
# service configration file
#
#  ex ) /etc/systemd/system/httpd.service
#
create_servicefile() # base name num
{
	base=$1;
	name=$2;
	num=$3;
	sfile="`get_servicefile $base $name`";
	sfile_base="`get_servicefile_base $base`";

	if [ -s "$sfile_base" ]; then
		cat $sfile_base | \
			case "$base" in
			httpd ) httpd_conf_filter $num $name ;;
			jboss ) jboss_conf_filter $num $name ;;
			esac >$sfile
	else
		echo "MESSAGE: $sfile_base does NOT exists."
		echo "MESSAGE: skip to create $base:$name service file"
	fi
}

#
# environment configration file
#
#  ex ) /etc/sysconfig/httpd
#
create_sysconfigfile() # base name num
{
	base=$1;
	name=$2;
	num=$3;
	sconfile="`get_sysconfigfile $base $name`";
	sconfile_base="$SYSCONFIG_FILE_BASE";

	if [ -s "$sconfile_base" ]; then
		cat $sconfile_base | \
			case "$base" in
			"httpd" ) httpd_conf_filter $num $name >$sconfile ;;
			"jboss" ) : ;; # no environment file
			* )
				echo "ERROR:(create_sysconfigfile) $base is unknown...."
				exit 1 ;;
			esac
	else
		echo "MESSAGE: $sconfile_base does NOT exists."
		echo "MESSAGE: skip to create $base:$name systemctl config file"
	fi
}


usage()
{
cat <<EOF
controle multiple apache instance

command name : $0

usage : $0 <service_name> command....

service_name :

  service name of systemctl ( httpd / jboss )

command :

  setup:
	setup
	setup -f : force execute
  check:
	check
  clean:
	clean

  do sysctrl command:
  	<cmd> instance_name ( := `get_instance_name_list`)
	<cmd> := start/stop/enable/disable/status

  check all httpd process:
	checkps
EOF
}

do_cmd_instance() # target cmd(start/stop/etc...) name
{
	target=$1
	cmd="$2";
	name="$3";
	cfile="`get_httpd_conffile $name`";
	sname="`get_servicename $target $name`";

	echo "MESSAGE : $cmd $target service:$sname"
	echo systemctl $cmd $sname
	systemctl $cmd $sname
}

#####################
#
# main
#
#####################
main()
{
ctltarget=$1; shift
kind="$1";
case "$kind" in
##### setup ######
setup )
	FORCE=no
	if [ "$2" = "-f" ]; then
		FORCE=yes;
	fi

	i=0;
	for name in ${INST_LIST[@]}
	do
		echo "creating $ctltarget : $name instance of systemctl"
		create_sysconfigfile $ctltarget $name $i
		create_servicefile $ctltarget $name $i
		i=`expr $i + 1`;
	done
	echo "MESSAGE: systemctl daemon-reload"
	systemctl daemon-reload;
	;;

"check" )
	for name in ${INST_LIST[@]}
	do
		echo "##### INSTANCE $name : diff httpd.conf"

		sf=`get_servicefile $ctltarget $name`;
		cf=`get_sysconfigfile $ctltarget $name`;

		if [ $ctltarget = "httpd" ]
		then
			ls -ld $sf;
			ls -ld $cf
			echo "--- check $cf / $sf file"
			grep -e $ctltarget-$name $sf $cf
		else
			ls -ld $sf;
			echo "--- check $sf file"
			grep -e $ctltarget-$name $sf
		fi

	done
	;;

"clean" )
	for name in ${INST_LIST[@]}
	do
		echo "CLEANING: instance $name"
		rmdir_force `get_servicefile $ctltarget $name`;
		rmdir_force `get_sysconfigfile $ctltarget $name`;
	done
	;;

##### controle process ######
start | stop | enable | disable | status )
	if [ "$2" = "all" ]; then
		for name in ${INST_LIST[@]}
		do
			do_cmd_instance $ctltarget $kind $name
		done
	else
		do_cmd_instance $ctltarget $kind $2
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

