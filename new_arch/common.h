#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/functions.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
# $Id: functions.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
#

DEBUG=;		# no debug
# DEBUG=on	# standard debug
# DEBUG=DEBUG	# detail debug

msg()   { if [ -n "$DEBUG" ]; then echo "MESSAGE: $*"; fi }
debug() { if [ "$DEBUG" = "DEBUG" ]; then echo "DEBUG: $*"; fi }

#######################
# directory
#######################
chperm() # path own grp permittion
{
	path=$1
	perm=$4;

	chown -R $2:$3 $path
	if [ -n "$perm" ]
	then
		chmod $perm $path
	fi
}

create_dir() # dirname own grp permittion
{
	tgt=$1
	mkdir $tgt
	chown $2:$3 $tgt
	chmod $4 $tgt
}

check_dir() # dirname [force(yes)]
{
	cdir=$1
	force=$2

	if [ -d "$cdir" -o -h "$cdir" ]; then
	if [ "$force" = "yes" ]; then
		echo "LOG: remove dir : rm -rf $cdir"
		rm -rf $cdir
	else
		echo "ERROR: $cdir exists"
		echo "  check $cdir or remove it ( rm -rf $cdir )"
		exit 1
	fi
	fi
}

check_create_dir() # dirname own grp permittion [force(yes)]
{
	check_dir $1 $5;
	create_dir $*;
}

rmdir_force()
{
	cdir=$1;

	echo "LOG: remove dir : rm -rf $cdir"
	rm -rf $cdir
}

mk_base_dir() # path
# make parent directory
# ex) path=/a/b/c -> crete /a/b only.
{
	path=$1;
	if [ ! -d "$path" ]; then
	(
		mkdir -p $path
		cd $path
		cd ..
		rmdir $path
	)
	else
		echo "message : $path directory already exists."
	fi
}

