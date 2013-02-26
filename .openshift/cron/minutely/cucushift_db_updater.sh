#!bin/sh

#  File name:	cucushift_db_updater.sh
#  Date:	2013/02/25 15:30
#  Author: cryan@redhat.com

# This script is for updating the cucushift validator web application database.

#Setup the temporary folder name
DATE=`date +%Y-%m-%d-%T`
TMP_FOLDER="cucushift_tmp_"

#Create the temporary directory
cd /tmp
mkdir $TMP_FOLDER$DATE
cd $TMP_FOLDER$DATE

#Clone the git repository
git clone git://qe-git.englab.nay.redhat.com/hss-qe/openshift/openshift-express/ostest

#Setup the $OSTEST_HOME env variable
cd ostest
OSTEST_HOME=$(pwd)
export OSTEST_HOME

#Run the get_cucumber_regex script, and dump the contents to an sql file
cd bin
sh get_cucumber_regex.sh > ../../cucushift_dump.sql

#Upload the sql dump to the cucushift validator application

#Pass the user password to the rhc port-forward script
nohup rhc port-forward cucushiftvalidator -p "redhat" &

sleep 10

mysql -h 127.12.173.1 -P 3306 -u adminJw7eDV5 -pyWfcGXU_bhsI

#Checking available ports...
#Forwarding ports
#  Service Connect to              Forward to
#  ====== ================== ==== ==================
#  httpd  127.12.173.1:8080   =>  127.12.173.1:8080
#  httpd  127.12.173.2:8080   =>  127.12.173.2:8080
#  mysqld 127.12.173.1:3306   =>  127.12.173.1:3306
#  ruby   127.12.173.1:34403  =>  127.12.173.1:34403
#Press CTRL-C to terminate port forwarding


#Delete the temporary directory
