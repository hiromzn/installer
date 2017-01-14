. ../common.env

for i in $DB_INSTANCE_LIST
do
d="${i}D"
u="${i}DU"

cat <<EOF
CREATE DATABASE "$d" OWNER "$u";
EOF

psql <<EOF
CREATE DATABASE "$d" OWNER "$u";
EOF

done
