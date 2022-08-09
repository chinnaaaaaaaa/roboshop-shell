source common.sh

COMPONENT=frontend

echo installing Nginx
yum install nginx -y &>>${LOG}
StatusCheck

DOWNLOAD

echo Clean Old Content
cd /usr/share/nginx/html && rm -rf *
StatusCheck

echo Extract Downloaded Content
unzip -o /tmp/frontend.zip &>>${LOG} && mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
StatusCheck

echo Start Nginx Service
systemctl restart nginx &>>${LOG} && systemctl enable nginx &>>${LOG}
StatusCheck