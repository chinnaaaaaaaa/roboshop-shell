source common.sh

COMPONENT=rabbitmq

echo Setup yum repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
StatuCheck

echo "Instal RabbitMQ & Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y  &>>${LOG}
StatuCheck

echo Start RabbitMQ Service
systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}

echo Add App User in RabbitMQ
rabbitmqctl add_user roboshop roboshop123 &>>${LOG} && rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
StatuCheck


