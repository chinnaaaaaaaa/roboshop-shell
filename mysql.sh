source common.sh

COMPONENT=mysql

if [ -z "$MYSQL_PASSWORD" ]; then
  echo -e "\e[33m env variable MYSQL_PASSWORD is missing \e[0m"
  exit 1
fi

echo Set up YUM repos
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
StatusCheck

echo install MYSQL
yum install mysql-community-server -y &>>${LOG}
StatusCheck

echo start MYSQL sevice
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
StatusCheck

echo "show databases;" | mysql -uroot -p$MYSQL_PASSWORD &>>${LOG}

if [ $? -ne 0 ]; then
   echo Changing Default Password
   DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
   echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD} &>>${LOG}
 StatusCheck
fi

echo  "show plugins;" | mysql -uroot -p$MYSQL_PASSWORD 2>&1 | grep validate_password &>>${LOG}
if [ $? -eq 0 ]; then
   echo Remove Password Validate Plugin
   echo  "uninstall plugin validate_password;" | mysql -uroot -p$MYSQL_PASSWORD &>>${LOG}
 StatusCheck
fi

DOWNLOAD

echo extract schema
cd /tmp &>>${LOG} && unzip -o mysql.zip &>>${LOG} && cd mysql-main &>>${LOG}
StatusCheck

echo load schema
mysql -uroot -pRoboShop@1 <shipping.sql &>>${LOG}
StatusCheck