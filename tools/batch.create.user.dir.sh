. ../common.env

set +e

for i in $INSTANCE_LIST
do

u="${i}OU"

su - $u <<EOF
mkdir -p batch/
mkdir -p onlinebatch/
mkdir -p data/batch/
mkdir -p data/onlinebatch/
mkdir -p logs/batch/
mkdir -p logs/onlinebatch/
EOF

done
