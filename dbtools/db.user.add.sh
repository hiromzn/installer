. ../common.env

for d in `ls -d ../repo/*`
do
i="`basename $d`"
u="${i}DU"

cat <<EOF
CREATE ROLE "$u" WITH LOGIN INHERIT PASSWORD '$PG_DB_USER_PASSWORD';
EOF

psql <<EOF
CREATE ROLE "$u" WITH LOGIN INHERIT PASSWORD '$PG_DB_USER_PASSWORD';
EOF

done
