
. conf.h
. common.h
. usergroup.h

main()
{
	if [ "$1" = "-f" ] # force : skip environment check.
	then
		shift;
	else
		check_env;
	fi

	kind="$1";
	shift

	case "$kind" in

	all ) all ;;

	setup ) setup $* ;; # install and autorun for all
	clean ) clean $* ;; # remove all configuration & files

	start ) start $* ;; # start all processes.
	stop ) stop $* ;; # stop all processes.

	waitconfig ) waitconfig $* ;; # config after start instance.
	runconfig ) runconfig $* ;; # config after start instance.

	deploy ) deploytestap $* ;; # config after start instance.

	check ) check $* ;; # check!
	ps ) check_ps $*;; # check processes

	ci ) ci $* ;; # check in and create archive file

	* ) echo "ERROR: bad args : $kind $*" ;;
	esac
}

all()
{
	setup;
	start;
	jboss_wait;
	runconfig;
	deploytestap;
}

waitconfig()
{
	jboss_wait;
	runconfig;
	deploytestap;
}

jboss_wait()
{
	./multijboss.sh wait
}

check_env()
{
	selinux="`getenforce`";
	if [ "$selinux" = "Enforcing" ]; then
		echo "CAUTION: check selinux config."
		echo "         NOW : selinux conf : $selinux"
		echo "         change enforce mode to Permissive"
		echo "                # setenforce 0"
		echo "         and"
		echo "             edit /etc/selinux/config file"
		echo "                SELINUX=permissive"
		exit 1;
	fi
}

preinstall()
{
	id=0;
	name="`get_instname $id`";

	uhome=`get_userhome $id`;
	echo "message : create base directory of $uhome"
	mk_base_dir $uhome;
}

setup()
{
	preinstall;

	./userctl.sh addgroup
	./userctl.sh adduser

	./multiapache.sh setup
	./multijboss.sh setup

	./multictl.sh httpd setup
	./multictl.sh jboss setup
}

start()
{
	./multictl.sh jboss start all
	./multictl.sh httpd start all
}

runconfig()
{
	./multijboss.sh adduser all
	./multijboss.sh addconfig all
}

deploytestap()
{
	./multijboss.sh deploytestap
}

stop()
{
	./multictl.sh httpd stop all
	./multictl.sh jboss stop all
}

clean()
{
	./multictl.sh jboss clean
	./multictl.sh httpd clean

	./multijboss.sh clean # all
	./multiapache.sh clean all

	./userctl.sh deluserforce
	./userctl.sh delgroup
}

check()
{
	./multijboss.sh check
}

ps_kind() { ps -ef |grep $1; }
check_ps()
{
	if [ -n "$1" ]
	then
		ps_kind $1;
	else
		ps_kind jboss;
		ps_kind httpd;
	fi
}

ci()
{
	dstr=`date +%Y-%m%d-%H%M-%S`;
	revdir="`pwd`/../rev/";
	dirname=`basename $PWD`;

	(
	cd ..
	arcfile="$revdir/$dirname-`hostname -s`-$dstr.tar";
	echo "creating archive in $arcfile"
	tar cf $arcfile ./$dirname
	)
}

main $*;

