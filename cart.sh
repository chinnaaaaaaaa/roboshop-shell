source common.sh

NODEJS

echo downloading the applicant content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>> /tmp/cart.log
cd /home/roboshop &>> /tmp/cart.log
StatusCheck

echo cleaning old application
rm -rf cart &>> /tmp/cart.log
StatusCheck

echo extrat application archive
unzip -o /tmp/cart.zip &>> /tmp/cart.log && mv cart-main cart &>> /tmp/cart.log && cd cart &>> /tmp/cart.log
StatusCheck

echo instaling nodejs dependencies
npm install &>> /tmp/cart.log
StatusCheck

echo confirouing cart systemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>> /tmp/cart.log && systemctl daemon-reload &>> /tmp/cart.log
StatusCheck

echo starting cart services
systemctl start cart &>> /tmp/cart.log && systemctl enable cart &>> /tmp/cart.log
StatusCheck
