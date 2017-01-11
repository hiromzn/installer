#
# common.h : common functions
#
######################
# log
######################

DEBUG=${DEBUG:=};

# DEBUG=	# no debug
# DEBUG=on	# standard debug
# DEBUG=DEBUG	# detail debug

pr_logheader()
{
cat <<EOF
#
# autogenerate : `LANG=C date`
#

EOF
}
msg()
{
	if [ -n "$DEBUG" ]; then
		echo "MESSAGE: $*";
	fi
}
debug()
{
	if [ "$DEBUG" = "DEBUG" ]; then
		echo "DEBUG: $*";
	fi
}

#######################
# check
#######################
check_java()
{
	msg "message : check java install"
	java -version 2>&1 |grep 'openjdk ' >/dev/null
	if [ "$?" -ne 0 ]
	then
		echo "ERROR: check java install for openjdk"
		echo "   check:"
		echo "       $ which java"
		echo "       $ java -version"
		echo "   install:"
		echo "       $ sudo yum –y install java-1.8.0-openjdk-devel"
		exit 1;
	fi
}

check_enforce()
{
	msg "message : check enforce"
	getenforce |grep 'Permissive' >/dev/null
	if [ "$?" -ne 0 ]
	then
		now="`getenforce`";
		echo "ERROR: check SELinux mode in Permissive (now:$now)"
		echo "   check:"
		echo "       $ getenforce"
		echo "   change dinamic config:"
		echo "       $ sudo setenforce 0"
		echo "   change static:"
		echo "       $ sudo vi  /etc/selinux/config"
		echo "       SELINUX=permissive"
		exit 1;
	fi
}


#######################
# directory
#######################
create_dir() # dirname own grp permittion
{
	tgt=$1
	mkdir $tgt
	chown $2:$3 $tgt
	chmod $4 $tgt
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

