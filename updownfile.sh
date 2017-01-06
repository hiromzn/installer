#
# $Header: /home/hmizuno/opens/CVSrepo/multi_instance/updownfile.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
# $Id: updownfile.sh,v 1.1.1.1 2016/12/24 12:16:09 hmizuno Exp $
#

HOST=16.146.89.146
# LOCAL=pack_local.tar
# REMOTE=pack_remote.tar
LOCAL=pack.`hostname -s`.tar
REMOTE=pack.tar

upload()
{
	tar cvf $LOCAL ./work
	scp $LOCAL $HOST:
}

download()
{
	scp $HOST:pack.\*.tar .
}

cd ../

case $1 in
upload ) upload ;;
download ) download ;;
esac

