source common.sh

COMPONENT=cart

echo set up YUM repo
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
StatusCheck

echo insatall YUM repo
yum install redis-6.2.7 -y &>>${LOG}
StatusCheck

#Update listen IP

echo start reddis service
systemctl enable redis &>>${LOG} && systemctl start redis &>>${LOG}
StatusCheck
