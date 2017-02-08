for d in `ls -d ../repo/*`
do
i="`basename $d`"
u="${i}DU"

cat <<EOF
DROP ROLE "$u";
EOF

psql <<EOF
DROP ROLE "$u";
EOF

done
