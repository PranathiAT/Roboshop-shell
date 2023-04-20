echo -e "\e[36m>>>>>>> Disable mysql old version<<<<<<<<\e[0m"
dnf module disable mysql -y
echo -e "\e[36m>>>>>>> copy mysql repo file<<<<<<<<\e[0m"
cp /home/centos/Roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m>>>>>>> install mysql<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>> start mysql<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[36m>>>>>>> set mysql password<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1