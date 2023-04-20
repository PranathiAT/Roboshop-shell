echo -e "\e[36m>>>>>>> download configuration repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>> Install nodejs<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>> Add application user<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>> Create app directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>> Download app content <<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>> UnZip App Content<<<<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>> Install nodejs dependencies <<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>> copy service file<<<<<<<<\e[0m"
cp /home/centos/Roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>start service file<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart


