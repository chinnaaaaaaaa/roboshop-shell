echo instaling nodejs repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> /tmp/cart.log
echo $?

echo instaling nodejs
yum install nodejs -y &>> /tmp/cart.log
echo $?

echo adding application user
useradd roboshop &>> /tmp/cart.log
echo $?

echo downloading the applicant content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>> /tmp/cart.log
cd /home/roboshop &>> /tmp/cart.log
echo $?

echo cleaning old application
rm -rf cart &>> /tmp/cart.log
echo $?

echo extrat application archive
unzip -o /tmp/cart.zip &>> /tmp/cart.log
mv cart-main cart &>> /tmp/cart.log
cd cart &>> /tmp/cart.log
echo $?

echo instaling nodejs dependencies
npm install &>> /tmp/cart.log
echo $?

echo confirouing cart systemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>> /tmp/cart.log
echo $?

echo starting cart services
systemctl daemon-reload &>> /tmp/cart.log
systemctl start cart &>> /tmp/cart.log
systemctl enable cart &>> /tmp/cart.log
echo $?