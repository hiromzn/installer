
MYNAME="$0";
MYARGS="$*";

. ./common.env
. ./utility.h

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
	package | ci | check )
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
	rm -rf "${REPO_DIR}";
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

check()
{
ok_repo=repo.ok
(
	set +e;
	cd $REPO_DIR;
	find */conf -type f |while read f;
	do
		echo "###### $f"
		diff $f ../$ok_repo/$f >/dev/null 2>&1
		if [ "$?" -ne 0 ];
		then
			echo "##### diff env : $f ../$ok_repo/$f"
			diff $f ../$ok_repo/$f
		fi
	done
)
(
	set +e;
	cd $REPO_DIR;
	for ienv in */env;
	do
	find $ienv -type f |while read f;
	do
		echo "###### $f"
		( . $ienv/os.env; . $ienv/jboss.env; . $f; env >/tmp/new; )
		( . ../$ok_repo/$f; env >/tmp/ok; )
		diff /tmp/new /tmp/ok >/dev/null 2>&1
		if [ "$?" -ne 0 ];
		then
			echo "##### diff env : $f ../$ok_repo/$f"
			diff /tmp/new /tmp/ok
		fi
	done
	done
)
}

main $*;

