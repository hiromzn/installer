#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
# $Id: multiapache,v 1.2 2016/12/24 13:31:01 hmizuno Exp $
#

# controle multiple apache instance

##############################
#
# httpd cofiguration
#
##############################
#
# original directory structure
#
# /etc/httpd/conf/httpd.conf
# /etc/httpd/logs --> ../../var/logs/httpd
# /etc/httpd/run --> /var/run/httpd : httpd 2.2
# /etc/httpd/run --> /run/httpd     : httpd 2.4
# /etc/httpd/modules --> ../../usr/lib64/httpd/modules
#
##############################

HTTPD=/usr/sbin/httpd

get_dir_perm_all() # kind
{
	case "$kind" in
	top ) echo $ORG_TOPDIR_PERM ;;
	www ) echo $ORG_WWW_ROOT_PERM ;;
	doc ) echo $ORG_DOC_ROOT_PERM ;;
	cgi ) echo $ORG_CGI_ROOT_PERM ;;
	run ) echo $ORG_RUN_DIR_PERM ;;
	log ) echo $ORG_LOG_DIR_PERM ;;
	esac
}

get_dir_perm() # kind num
{
	kind="$1";
	num="$2";

	permstr=`get_dir_perm_all $kind`;
	if [ -n "$num" ]; then
		perm=`echo $permstr |awk '{print $3 }'`;
		echo `get_username $num` `get_groupname $num` $perm
	else
		# return all parameter
		echo $permstr;
	fi
}

get_dirconf() # kind name [num]
	# if num is NULL; then return original user/group (root:apache etc..)
{
	kind="$1";
	name=$2;
	num=$3;
	permall=`get_dir_perm $kind $num`;
	case "$kind" in
	top ) echo `get_httpd_topdir $name` $permall ;;
	www ) echo `get_httpd_wwwroot $name` $permall ;;
	doc ) echo `get_httpd_docroot $name` $permall ;;
	cgi ) echo `get_httpd_cgiroot $name` $permall ;;
	run ) echo `get_httpd_rundir_abs $name` $permall ;;
	log ) echo `get_httpd_logdir_abs $name` $permall ;;
	esac
}

