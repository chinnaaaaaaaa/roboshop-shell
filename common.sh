# this script is on for DRY concept.

StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
    else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
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

echo downloading the applicant content
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> /tmp/${COMPONENT}.log
cd /home/roboshop &>> /tmp/${COMPONENT}.log
StatusCheck

echo cleaning old application
rm -rf ${COMPONENT} &>> /tmp/${COMPONENT}.log
StatusCheck

echo extrat application archive
unzip -o /tmp/${COMPONENT}.zip &>> /tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} &>> /tmp/${COMPONENT}.log && cd ${COMPONENT} &>> /tmp/${COMPONENT}.log
StatusCheck

echo instaling nodejs dependencies
npm install &>> /tmp/${COMPONENT}.log
StatusCheck
 }
