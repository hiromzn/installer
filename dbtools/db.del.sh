for x in `ls -d ../repo/*`
do
i="`basename $x`"
d="${i}D"

cat <<EOF
DROP DATABASE "$d";
EOF

psql <<EOF
DROP DATABASE "$d";
EOF

done
