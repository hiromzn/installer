
name=$1

WORK=./work

if [ -d "$WORK" ];
then
	rm -rf work
fi

mkdir $WORK
cd $WORK
cp -r ../src/app .
cat ../src/app/index.html \
	| sed 's/__MY_NAME__/'$name'/g' >app/index.html

cd app

#jar cf ../app.war .
tar cf ../app.war .

