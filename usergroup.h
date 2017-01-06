#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/functions.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
# $Id: functions.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
#

DEBUG=;		# no debug
# DEBUG=on	# standard debug
# DEBUG=DEBUG	# detail debug

#######################
# USER / GROUP
#######################

make_user_list()
{
	OS_USER_NAME_LIST=();
	for i in ${INST_LIST[@]}
	do
		OS_USER_NAME_LIST+=("${i}OU");
	done
}

make_group_list()
{
	OS_GROUP_NAME_LIST=();
	for i in ${INST_LIST[@]}
	do
		OS_GROUP_NAME_LIST+=("${i}OG");
	done
}

make_user_array()
{
	make_user_list;
	make_group_list;

	offset=0;
	for i in ${OS_USER_NAME_LIST[@]}
	do
		debug $i

		# user name
		OS_USER_ARY+=("$i");
		# user ID
		OS_USER_ARY+=("`expr $OS_USER_ID_BASE + $offset`");

		# group name
		OS_USER_ARY+=(${OS_GROUP_NAME_LIST[$offset]});
		# group ID
		OS_USER_ARY+=("`expr $OS_GROUP_ID_BASE + $offset`");

		# home
		OS_USER_ARY+=("`printf $OS_USER_HOME_FMT ${INST_LIST[$offset]}`");
		# home permit
		OS_USER_ARY+=("$OS_USER_HOME_PERMIT");

		# INSTANCE name
		OS_USER_ARY+=("${INST_LIST[$offset]}");

		offset=`expr $offset + 1`;
		debug ${OS_USER_ARY[*]};
		#echo $offset;
	done
}

NO_NEWLINE="-n"
get_username() 	{ echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET`]}"; }
get_userid() 	{ echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET + 1`]}"; }
get_groupname() { echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET + 2`]}"; }
get_groupid() 	{ echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET + 3`]}"; }
get_userhome() 	{ echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET + 4`]}"; }
get_userhomepermit() 	{ echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET + 5`]}"; }
get_instname() 	{ echo $NO_NEWLINE "${OS_USER_ARY[`expr $1 \* $OS_USER_ARY_RECORD_OFFSET + 6`]}"; }

check_user_array()
{
	offset=0;
	for i in ${OS_USER_NAME_LIST[@]}
	do
		get_username $offset;
		echo -n ":"
		get_userid $offset;
		echo -n ":"
		get_groupname $offset;
		echo -n ":"
		get_groupid $offset;
		echo -n ":"
		get_userhome $offset;
		echo -n ":"
		get_userhomepermit $offset;
		echo " ";
		offset=`expr $offset + 1`;
	done
}

pr_user_array()
{
	offset=0;
	for i in ${OS_USER_NAME_LIST[@]}
	do
		debug $offset
		echo "$i : ${OS_USER_ARY[$offset]}\
 ${OS_USER_ARY[`expr $offset + 1`]}\
 ${OS_USER_ARY[`expr $offset + 2`]}\
 ${OS_USER_ARY[`expr $offset + 3`]}\
 ${OS_USER_ARY[`expr $offset + 4`]}\
 ${OS_USER_ARY[`expr $offset + 5`]}\
"
		offset=`expr $offset + $OS_USER_ARY_RECORD_OFFSET`;
	done
}

chperm_user_num() # path num perm
{
	path=$1;
	num=$2;
	perm=$3;
	chperm $path `get_username $num` `get_groupname $num` $perm
}

check_utils()
{
pr_user_array;
check_user_array;
}

initial_functions()
{
	make_user_array;
}

#####################
# initial functions
#####################

initial_functions;

# DEBUG functions
if [ -n "$DEBUG" ]; then check_utils; fi

