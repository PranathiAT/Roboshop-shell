script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1



if [ -z "$rabbitmq_appuser_password" ];then
  echo Input Rabbitmq app user password missing
  exit
fi

func_print_head "setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_status_check $?

func_print_head "set up rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_status_check $?

func_print_head "install erlang and rabbitmq"
yum install erlang  rabbitmq-server -y &>>$log_file
func_status_check $?

func_print_head "start rabbitmq service"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_status_check $?

func_print_head "Add user with password"
user = $(rabbitmqctl list_users -q |grep roboshop | awk 'print $1')
echo "$user"
if [user != 'roboshop'];then
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
fi
func_status_check $?