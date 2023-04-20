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
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>> UnZip App Content<<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>> Install nodejs dependencies <<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>> copy service file<<<<<<<<\e[0m"
cp /home/centos/Roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>start service file<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user


echo -e "\e[36m>>>>>>> Copy mongodb repo<<<<<<<<\e[0m"
cp /home/centos/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>> Install mongodb client <<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>> load schema<<<<<<<<\e[0m"
mongo --host mongodb-dev.pdevops.online </app/schema/user.js