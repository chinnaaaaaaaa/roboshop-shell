source common.sh

COMPONENT=mysql

if [ -z "$MYSQL_PSWWORD" ]; then
  echo -e "\e[33m env variable MYSQL_PASSWORD missing \e[0m"
   exit 1
 fi


echo set YUM repos
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
StatusCheck

echo install MYSQL
yum install mysql-community-server -y &>>${LOG}
StatusCheck

echo start mysql servive
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
StatusCheck

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD}
