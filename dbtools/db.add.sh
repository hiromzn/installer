. ../common.env

for x in `ls -d ../repo/*`
do
i="`basename $x`"
d="${i}D"
u="${i}DU"

cat <<EOF
CREATE DATABASE "$d" OWNER "$u";
EOF

psql <<EOF
CREATE DATABASE "$d" OWNER "$u";
EOF

done
