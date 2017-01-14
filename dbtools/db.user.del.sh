. ../common.env

for i in $DB_INSTANCE_LIST
do
u="${i}DU"

cat <<EOF
DROP ROLE "$u";
EOF

psql <<EOF
DROP ROLE "$u";
EOF

done
