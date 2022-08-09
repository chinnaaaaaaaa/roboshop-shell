# this script is on for DRY concept.

StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
    else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
 }

DOWNLOAD() {
 echo downloading ${COMPONENT} applicant content
 curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> /tmp/${COMPONENT}.log
 StatusCheck
 }

NODEJS() {
 echo instaling nodejs repos
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> /tmp/${COMPONENT}.log
 StatusCheck

 echo instaling nodejs
 yum install nodejs -y &>> /tmp/${COMPONENT}.log
 StatusCheck

 id roboshop &>>/tmp/${COMPONENT}.log
 if [ $? -ne 0 ]; then
     echo adding application user
     useradd roboshop &>> /tmp/${COMPONENT}.log
     StatusCheck
 fi

DOWNLOAD

 echo cleaning old application
 cd /home/roboshop &>> /tmp/${COMPONENT}.log && rm -rf ${COMPONENT} &>> /tmp/${COMPONENT}.log
 StatusCheck

 echo extrat application archive
 unzip -o /tmp/${COMPONENT}.zip &>> /tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} &>> /tmp/${COMPONENT}.log && cd ${COMPONENT} &>> /tmp/${COMPONENT}.log
 StatusCheck

 echo instaling nodejs dependencies
 npm install &>> /tmp/${COMPONENT}.log
 StatusCheck

 echo confirouing ${COMPONENT} systemD service
 mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> /tmp/${COMPONENT}.log && systemctl daemon-reload &>> /tmp/${COMPONENT}.log
 StatusCheck

 echo starting ${COMPONENT} services
 systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log && systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
 StatusCheck
 }

USER_ID=$( id -u )
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m you should run this script as root user or sudo \e[0m"
  exit 1
fi
LOG=/tmp/${COMPONENT}.log
rm -f ${LOG}