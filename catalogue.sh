echo -e "\e[36m>>>>>>> Configuring NodeJs repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>> install NodeJs  <<<<<<<<\e[0m"
yum istall nodejs -y

echo -e "\e[36m>>>>>>> Add Application user <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>> Create application Directory <<<<<<<<\e[0m"
rm-rf /app
mkdir /app

echo -e "\e[36m>>>>>>> Download App content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>> UnZip App Content<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>> Install Nodejs dependencies <<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>> copy catalogue systemd file <<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>> start catalogue service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>> Copy mongodb repo<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>> Install mongodb client<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>> Load schema  <<<<<<<<\e[0m"
mongo --host mongodb-dev.pdevops.online </app/schema/catalogue.js