COMPONENT=rabbitmq

source common.sh
if [ -z "$APP_RABBITMQ_PASSWORD" ]; then
  echo -e "\e[33m env variable APP_RABBITMQ_PASSWORD is needed \e[0m"
  exit 1
fi

echo Setup yum repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
StatusCheck

echo "Instal RabbitMQ & Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y  &>>${LOG}
StatusCheck

echo Start RabbitMQ Service
systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}
StatusCheck

rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
 echo Add App User in RabbitMQ
 rabbitmqctl add_user roboshop ${APP_RABBITMQ_PASSWORD} &>>${LOG} && rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
 StatusCheck
fi

