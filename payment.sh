script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1
component=payment
func_python


if [ -z "$rabbitmq_appuser_password" ];then
  echo Input Rabbitmq app user paswword missing
  exit
fi

