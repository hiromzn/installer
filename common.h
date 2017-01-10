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

