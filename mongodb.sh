COMPONENT=mongodb

source common.sh

echo Set up YUM Repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
StatusCheck

echo YUM Install mongodb
yum install -y mongodb-org &>>${LOG}
StatusCheck

echo start mongodb services
systemctl enable mongod &>>${LOG} && systemctl start mongod &>>${LOG}
StatusCheck

## Update the Listing IP Config

DOWNLOAD

echo "Extract the Schema Files"
cd /tmp && unzip -o mongodb.zip &>>${LOG}
StatusCheck

echo Load Schema
cd mongodb-main  && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
StatusCheck

