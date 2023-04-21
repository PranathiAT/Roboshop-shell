app_user=roboshop

print_head()
{
  echo -e "\e[31m>>>>>>> $* <<<<<<<<\e[0m"
}


schema_setup()
{
  if [ "$schema_setup" == "mongo" ]; then
  print_head " Copy mongodb repo"
  cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

  print_head " Install mongodb client"
  yum install mongodb-org-shell -y

  print_head "Load schema"
  mongo --host mongodb-dev.pdevops.online </app/schema/${component}.js
  fi
}
func_nodejs()
{

  print_head "download configuration repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install nodejs"
  yum install nodejs -y

  print_head "Add application user"
  useradd ${app_user}

  print_head " Create app directory"
  rm -rf /app
  mkdir /app

  print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head " UnZip App Content"
  unzip /tmp/${component}.zip

  print_head "Install nodejs dependencies"
  npm install

   print_head "copy service file"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

    print_head "start" ${component} "file"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

  schema_setup

}