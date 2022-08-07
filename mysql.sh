set -e
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

yum install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld

echo MYSQL PASWORD is=$MYSQL_PASWWORD
DEFAULT_PASSWORD=$( grep ' A temporary password'  /var/log/mysqld.log | awk '{print $11}')

echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD}


mysql_secure_installation

echo  "uninstall plugin validate_password;" | mysql -uroot -p$MYSQL_PASSWORD

#> uninstall plugin validate_password;

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql