source common.sh

COMPONENT=cart
NODEJS



echo confirouing cart systemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>> /tmp/cart.log && systemctl daemon-reload &>> /tmp/cart.log
StatusCheck

echo starting cart services
systemctl start cart &>> /tmp/cart.log && systemctl enable cart &>> /tmp/cart.log
StatusCheck
