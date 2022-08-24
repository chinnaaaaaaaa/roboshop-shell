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
 curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> ${LOG}
 StatusCheck
 }
 APP_USER_SETUP() {
id roboshop &>>${LOG}
 if [ $? -ne 0 ]; then
     echo adding application user
     useradd roboshop &>> ${LOG}
     StatusCheck
 fi
 }
 APP_CLEAN() {
 echo cleaning old application
 cd /home/roboshop &>> ${LOG} && rm -rf ${COMPONENT} &>> ${LOG}
 StatusCheck

 echo extrat application archive
 unzip -o /tmp/${COMPONENT}.zip &>> ${LOG} && mv ${COMPONENT}-main ${COMPONENT} &>> ${LOG} && cd ${COMPONENT} &>> ${LOG}
 StatusCheck
 }
SYSTEMD() {
 echo Update SystemD Cofg
 sed -i -e 's/MONGO_DNSNAME/mongodb-dev.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
 StatusCheck

 echo confirouing ${COMPONENT} systemD service
 mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> ${LOG} && systemctl daemon-reload &>> ${LOG}
 StatusCheck

 echo starting ${COMPONENT} services
 systemctl start ${COMPONENT} &>> ${LOG} && systemctl enable ${COMPONENT} &>> ${LOG}
 StatusCheck
 }

NODEJS() {
 echo instaling nodejs repos
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${LOG}
 StatusCheck

 echo instaling nodejs
 yum install nodejs -y &>> ${LOG}
 StatusCheck

 APP_USER_SETUP
 DOWNLOAD
 APP_CLEAN

 echo instaling nodejs dependencies
 npm install &>> ${LOG}
 StatusCheck

 SYSTEMD
 }

 JAVA() {
   echo Install maven
   yum install maven -y &>>${LOG}
   StatusCheck

   APP_USER_SETUP
   DOWNLOAD
   APP_CLEAN

 echo Make application package
   mvn clean package &>>${LOG} && mv target/shipping-1.0.jar shipping.jar &>>${LOG}
 StatusCheck


  SYSTEMD

   }

 PYTHON() {
    echo instal python
    yum install python36 gcc python3-devel -y &>>${LOG}
    StatusCheck

    APP_USER_SETUP
    DOWNLOAD
    APP_CLEAN

    echo Install Python Dependencies
    cd /home/roboshop/payment &>>${LOG} &&  pip3 install -r requirements.txt &>>${LOG}
    StatusCheck

  SYSTEMD
  }

USER_ID=$( id -u )
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m you should run this script as root user or sudo \e[0m"
  exit 1
fi
LOG=/tmp/${COMPONENT}.log
rm -f ${LOG}

