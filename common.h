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
get_date_str() { echo "`date $DATE_TIME_FMT`"; }
message() # messages...
{
	echo "msg: " $*;
}
log() # messages...
{
	echo "LOG:`get_date_str`: " $*
}
pr_error() # messages....
{
	prstderr "ERROR:`get_date_str`: " $*;
}
prstderr() # messages....
{
	echo "$*" 1>&2;
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
		pr_error "check java install for openjdk"
		prstderr "   check:"
		prstderr "       $ which java"
		prstderr "       $ java -version"
		prstderr "   install:"
		prstderr "       $ sudo yum –y install java-1.8.0-openjdk-devel"
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
		pr_error "check SELinux mode in Permissive (now:$now)"
		prstderr "   check:"
		prstderr "       $ getenforce"
		prstderr "   change dinamic config:"
		prstderr "       $ sudo setenforce 0"
		prstderr "   change static:"
		prstderr "       $ sudo vi  /etc/selinux/config"
		prstderr "       SELINUX=permissive"
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

	log "LOG: remove dir : rm -rf $cdir"
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
		log "message : $path directory already exists."
	fi
}

