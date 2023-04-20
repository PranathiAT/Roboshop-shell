echo -e "\e[36m>>>>>>> setup erlang repos<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>> set up rabbitmq repos<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>> install erlang and rabbitmq <<<<<<<<\e[0m"
yum install erlang  rabbitmq-server -y

echo -e "\e[36m>>>>>>> start rabbitmw service<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[36m>>>>>>Add user with password<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"