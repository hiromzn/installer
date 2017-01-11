
MYNAME="$0";
MYARGS="$*";

set -eu

FIREWALL_CMD_OPT="--zone=public";

main()
{
	cmd="$1";
	case "$1" in
	list )
		firewall-cmd --list-services $FIREWALL_CMD_OPT;
		;;
	listdir )
		ls -l /etc/firewalld/services/
		;;
	* )
		cat <<EOF
usage: $0 command

command:
	list
	listdir
EOF
		;;
	esac
}

main $*;

