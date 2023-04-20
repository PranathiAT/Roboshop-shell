echo -e "\e[36m>>>>>>>install maven <<<<<<<<\e[0m"
yum install maven -y
echo -e "\e[36m>>>>>>> Add application user<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>> Add app directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>> Download app content<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>Unzip app content <<<<<<<<\e[0m"
unzip /tmp/shipping.zip


echo -e "\e[36m>>>>>>>Download maven dependencies <<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>> Copy Systemd file<<<<<<<<\e[0m"

cp /home/centos/Roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>> Install mysql <<<<<<<<\e[0m"
yum install mysql -y
mysql -h mysql-dev.pdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>> start shipping service <<<<<<<<\e[0m"

systemctl daemon-reload

systemctl enable shipping
systemctl restart shipping
