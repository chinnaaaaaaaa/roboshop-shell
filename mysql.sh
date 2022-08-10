source common.sh

COMPONENT=mysql

echo set YUM repos
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
StatusCheck

echo install MYSQL
yum install mysql-community-server -y &>>${LOG}
StatusCheck

echo start mysql servive
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
StatusCheck