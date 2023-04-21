app_user=roboshop


func_nodejs()
{

  echo -e "\e[36m>>>>>>> download configuration repos <<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[36m>>>>>>> Install nodejs<<<<<<<<\e[0m"
  yum install nodejs -y

  echo -e "\e[36m>>>>>>> Add application user<<<<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[36m>>>>>>> Create app directory<<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[36m>>>>>>> Download app content <<<<<<<<\e[0m"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>> UnZip App Content<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip

  echo -e "\e[36m>>>>>>> Install nodejs dependencies <<<<<<<<\e[0m"
  npm install

  echo -e "\e[36m>>>>>>> copy service file<<<<<<<<\e[0m"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>start service file<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}



}