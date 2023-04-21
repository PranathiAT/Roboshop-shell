echo -e "\e[36m>>>>>>> Install golang<<<<<<<<\e[0m"
yum install golang -y
echo -e "\e[36m>>>>>>> Add application user<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>> Create app directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>> Download app content<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[36m>>>>>>> Extract app content<<<<<<<<\e[0m"
unzip /tmp/dispatch.zip


echo -e "\e[36m>>>>>>> Install dependencies<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>> Copy service file<<<<<<<<\e[0m"
cp /home/centos/Roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>> start dispatch service<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch