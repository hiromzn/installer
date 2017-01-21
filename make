
MYNAME="$0";
MYARGS="$*";

. ./common.env

. ./common.h

set -eu

usage()
{
cat <<EOF
usage : $MYNAME command

command :
	package
	ci
EOF
}

main()
{
	cmd="$1";

	case "$cmd" in
	package | ci )
		$cmd
		exit 0
		;;
	* )
		usage;
		exit 1
		;;
	esac
}

ci()
{
	rm -rf "${INSTANCE_DIR}";
	rm -rf "${SCRIPT_DIR}";
	git add -A
	git commit
}

package()
{
	PWD="`pwd`";
	dstr=`date +%Y-%m%d-%H%M-%S`;
	revdir="$PWD/../rev/";
	dirname=`basename $PWD`;
	(
		cd ..;
		if [ ! -d "$revdir" ]; then mkdir $revdir; fi;
		arcfile="$revdir/$dirname-`hostname -s`-$dstr.tar.z";
		echo "creating archive in $arcfile";
		mkdir work@@dir
		cp -r $dirname work@@dir
		cd work@@dir
		rm -rf $dirname/.git
		tar czf $arcfile ./$dirname;
		cd ..;
		rm -rf work@@dir;
	)
}

main $*;

