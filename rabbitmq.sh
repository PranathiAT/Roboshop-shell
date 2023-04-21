rabbitmq_appuser_password=$1


if[-z "$rabbitmq_appuser_password"];then
  echo Input Rabbitmq app user password missing
  exit
fi


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
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"