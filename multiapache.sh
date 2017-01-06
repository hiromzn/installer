#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
# $Id: multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
#

. conf.h
. common.h
. usergroup.h
. multiapache.h

# controle multiple apache instance

##########

usage()
{
cat <<EOF
controle multiple apache instance

command name : $0

usage :
  ## CONFIG ##
  setup:
	$0 setup
	$0 setup -f : force execute
  check:
	$0 check
  clean:
	$0 clean

  ## PROCESS ##
  check all httpd process:
	$0 checkps
EOF
}

#####################
#
# main
#
#####################
main()
{
APACHE_VER=`get-apache-version`;

case "$1" in
##### setup ######
setup )
	FORCE=no
	if [ "$2" = "-f" ]; then
		FORCE=yes;
	fi
	# setup-httpdconf;

	i=0;
	for n in ${INST_LIST[@]}
	do
		setup-clone $i $n
		i=`expr $i + 1`;
	done
	;;
"check" )
	for n in ${INST_LIST[@]}
	do
		echo "##### INSTANCE $n : diff httpd.conf"

		ls -ld `get_httpd_topdir $n`;
		ls -ld `get_httpd_logdir_abs $n`;
		ls -ld `get_httpd_rundir_abs $n`;
		wwwroot="`get_httpd_wwwroot $n`";
		ls -ld $wwwroot
		ls -ld $wwwroot/*

		echo "--- check $ORG_TOPDIR-$n/conf/httpd.conf"
		grep -e ^ServerRoot -e ^Document -e ^Listen -e ^PidFile -e ^DefaultRuntimeDir $ORG_TOPDIR-$n/conf/httpd.conf
	done
	;;
"clean" )
	for num in ${INST_LIST[@]}
	do
		echo "CLEANING: instance $num"
		rmdir_force `get_httpd_topdir $num`;
		rmdir_force `get_httpd_logdir_abs $num`;
		rmdir_force `get_httpd_rundir_abs $num`;
		rmdir_force `get_httpd_wwwroot $num`;
	done
	;;

##### controle process ######
checkps )
	ps -ef |grep httpd
	;;

-? | * )
	usage;
	exit 1;
	;;
esac
}

pr_apache_ver()
{
	case "$APACHE_VER" in
	2.2 ) echo "Apache VER 2.2" ;;
	2.4 ) echo "Apache VER 2.4" ;;
	esac
}

get-apache-version()
{
	if [ -d "$ORG_TOPDIR/conf.modules.d" ]; then
		echo "2.4";
	else
		echo "2.2";
	fi
}

setup_welcomepage_for_test() # num name
{
	if [ -s "$TEST_WELCOME_BASE" ]; then
		num=$1
		name=$2;
		target="`get_httpd_docroot $name`/index.html";
		cat "$TEST_WELCOME_BASE" |httpd_conf_filter $num $name >$target
		chperm_user_num $target $num 644
	else
		debug "MESSAGE : no $TEST_WELCOME_BASE : check this file."
	fi
}

setup-clone() # num name
{
	num=$1
	name=$2
	username="`get_username $num`";
	groupname="`get_groupname $num`";

	echo "setup clone #:$num:$name of user:$username"

	topdir="`get_httpd_topdir $name`";
	httpdconf="`get_httpd_conffile $name`";

  # topdir
	check_dir $topdir $FORCE;
	mk_base_dir $topdir;
	cp -rp $ORG_TOPDIR $topdir
	chperm_user_num $topdir $num

  # config file
	custom_fn="`get_httpd_conf_custom_file $name`";
	modjk_fn="`get_httpd_conf_modjk_file $name`";
	workers_fn="`get_httpd_conf_workers_file $name`";

	cat $HTTPD_CONF_BASE \
		|httpd_conf_filter $num $name >$httpdconf;
	cat $HTTPD_CUSTOM_BASE \
		|httpd_conf_filter $num $name >$custom_fn;
	cat $HTTPD_MODJK_BASE \
		|httpd_conf_filter $num $name >$modjk_fn;
	cat $HTTPD_WORKERS_BASE \
		|httpd_conf_filter $num $name >$workers_fn;

	# OFF : SSL config
	sslconf="`get_httpd_confd $name`/ssl.conf";
	if [ -s "$sslconf" ];
	then
		rm -f $sslconf;
	fi

	chown $username:$groupname $custom_fn $modjk_fn $workers_fn;
	chmod $HTTPD_CONF_FILE_MOD $custom_fn $modjk_fn $workers_fn;

  # logs dir
	check_create_dir `get_dirconf log $name $num` yes

  # run dir
	check_create_dir `get_dirconf run $name $num` yes

  # modules dir
	(
		rm -f $topdir/modules
		cd $topdir
		su `get_username $num` -c "ln -s $ORG_HTTPD_MODULES_ABS ./modules"
	)
	install_mod_jk $name;

  # www dir
	check_create_dir `get_dirconf www $name $num` $FORCE
  # docroot dir
	check_create_dir `get_dirconf doc $name $num` $FORCE
	setup_welcomepage_for_test $num $name;
  # cgiroot dir
	check_create_dir `get_dirconf cgi $name $num` $FORCE
}

main $*;

