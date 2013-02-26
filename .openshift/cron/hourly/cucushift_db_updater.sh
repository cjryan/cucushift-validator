#!/bin/sh

#  File name:	cucushift_db_updater.sh
#  Date:	2013/02/25 15:30
#  Author: cryan@redhat.com

# This script is for updating the cucushift validator web application database.

#Setup the temporary folder name
TMP_FOLDER="cucushift_tmp_"

set -e

#Create the temporary directory
cd $OPENSHIFT_TMP_DIR

#Clone the git repository
if [ ! -d ostest ]; then
  git clone git://qe-git.englab.nay.redhat.com/hss-qe/openshift/openshift-express/ostest
else
  pushd ostest;git pull;popd
fi

  

#Setup the $OSTEST_HOME env variable
cd ostest
export OSTEST_HOME=$(pwd)

#Run the get_cucumber_regex script, and dump the contents to an sql file
FRESH_DUMP="${OPENSHIFT_TMP_DIR}/cucushift_dump.sql"
./bin/get_cucumber_regex.sh > $FRESH_DUMP

#Create an md5 sum of the sql file to see if anything has changed since the last time
NEWMD5=$(md5sum $FRESH_DUMP | awk '{print $1}')

#Get the mysql value for hash here
HASH=$(mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME -p$OPENSHIFT_MYSQL_DB_PASSWORD cucushiftvalidator --skip-column-names -e "SELECT dbhash FROM step_db_versions;" |tail -1)
RESULT=$(echo $HASH cucushift_dump.sql | md5sum -c | awk '{ print $2 }')

#echo "the new md5 is: "$NEWMD5
#echo "the old md5 was "$HASH

#Compare the result of the hash with the value in the database
if [ "$RESULT" = 'OK' ]; then
	exit 0
	#echo "It's totally cool."
else
	mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME -p$OPENSHIFT_MYSQL_DB_PASSWORD cucushiftvalidator < cucushift_dump.sql
	mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME -p$OPENSHIFT_MYSQL_DB_PASSWORD cucushiftvalidator -e "UPDATE step_db_versions set version=NOW();"
	mysql -h $OPENSHIFT_MYSQL_DB_HOST -P $OPENSHIFT_MYSQL_DB_PORT -u $OPENSHIFT_MYSQL_DB_USERNAME -p$OPENSHIFT_MYSQL_DB_PASSWORD cucushiftvalidator -e "UPDATE step_db_versions set dbhash=\"$NEWMD5\";"
fi
  

exit 0

