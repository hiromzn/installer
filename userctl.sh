#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/userctl.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
# $Id: userctl.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
#

. conf.h
. common.h
. usergroup.h

main()
{
case $1 in
addgroup ) add_all_group ;;
delgroup ) del_all_group ;;
adduser ) add_all_user ;;
deluser ) del_all_user ;;
deluserforce ) del_all_user -r -f ;;
check )
	tail /etc/passwd
	tail /etc/group
	;;
* ) usage ;;
esac
}

usage()
{
cat <<EOF
usage : $0 option

option:
	addgroup
	delgroup
	adduser
	deluser
	deluserforce
	check
EOF
}

add_all_group()
{
	offset=0;
	for i in ${OS_GROUP_NAME_LIST[@]};
	do
		echo groupadd -g `get_groupid $offset` $i
		groupadd -g `get_groupid $offset` $i
		offset=`expr $offset + 1`;
	done
}

del_all_group()
{
	for i in ${OS_GROUP_NAME_LIST[@]};
	do
		echo groupdel $i
		groupdel $i
	done
}

add_all_user()
{
	offset=0;
	for i in ${OS_USER_NAME_LIST[@]};
	do
		echo useradd -u `get_userid $offset` -d `get_userhome $offset` -g `get_groupid $offset` $i 
		useradd -u `get_userid $offset` -d `get_userhome $offset` -g `get_groupid $offset` $i 
		echo chmod `get_userhomepermit $offset` `get_userhome $offset`
		chmod `get_userhomepermit $offset` `get_userhome $offset`
		offset=`expr $offset + 1`;
	done
}

del_all_user()
{
	for i in ${OS_USER_NAME_LIST[@]};
	do
		echo userdel $* $i 
		userdel $* $i 
	done
}

main $*;

