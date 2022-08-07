echo instaling nodejs repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi


echo instaling nodejs
yum install nodejs -y &>> /tmp/cart.log
if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

id roboshop  &>>/tmp/cart.log
if [ $? -ne  0 ]; then
   echo adding application user
   useradd roboshop &>> /tmp/cart.log
    if [ $? -eq 0 ]; then
   echo -e "\e[32mSUCCESS\e[0m"
  else
   echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

echo downloading the applicant content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>> /tmp/cart.log
cd /home/roboshop &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

echo cleaning old application
rm -rf cart &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

echo extrat application archive
unzip -o /tmp/cart.zip &>> /tmp/cart.log
mv cart-main cart &>> /tmp/cart.log
cd cart &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

echo instaling nodejs dependencies
npm install &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

echo confirouing cart systemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
 fi

echo starting cart services
systemctl daemon-reload &>> /tmp/cart.log
systemctl start cart &>> /tmp/cart.log
systemctl enable cart &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
  echo -e "\e[31mFAILURE\e[0m"
  exit 1
fi