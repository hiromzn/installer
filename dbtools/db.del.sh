. ../common.env

for i in $DB_INSTANCE_LIST
do
d="${i}D"

cat <<EOF
DROP DATABASE "$d";
EOF

psql <<EOF
DROP DATABASE "$d";
EOF

done
