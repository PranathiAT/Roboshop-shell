app_user=roboshop

func_print_head()
{
  echo -e "\e[31m>>>>>>> $* <<<<<<<<\e[0m"
}

func_status_check()
{
   if [ $1 -eq 0 ];then
       echo -e "\e[32mSUCCESS\e[0m"
    else
       echo -e "\e[31mFAILURE\e{0m"
       exit 1
    fi
}


func_schema_setup()
{
  if [ "$schema_setup" == "mongo" ]; then
  func_print_head " Copy mongodb repo"
  cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo
  func_status_check $?

  func_print_head " Install mongodb client"
  yum install mongodb-org-shell -y
  func_status_check $?

  func_print_head "Load schema"
  mongo --host mongodb-dev.pdevops.online </app/schema/${component}.js
  func_status_check $?
  fi


  if [ "$schema_setup" == "mysql" ];then
    func_print_head   "Install mysql "
    yum install mysql -y
    func_status_check $?

    func_print_head "load schema"
    mysql -h mysql-dev.pdevops.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
    func_status_check $?
  fi

}

func_systemd_setup()
{
  func_print_head "copy service file"
    cp $script_path/${component}.service /etc/systemd/system/${component}.service
    func_status_check $?

    func_print_head "start" ${component} "file"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl start ${component}
    func_status_check $?

}
func_app_prereq()
{
  func_print_head "Add application user"
    useradd ${app_user}

    func_print_head " Create app directory"
    rm -rf /app
    mkdir /app

    func_print_head "Download app content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    cd /app

    func_print_head " UnZip App Content"
    unzip /tmp/${component}.zip

}

func_nodejs()
{

  func_print_head
 "download configuration repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "Install nodejs"
  yum install nodejs -y
  func_status_check $?
  func_app_prereq

  func_print_head "Install nodejs dependencies"
  npm install
  func_status_check $?

  func_schema_setup
  func_systemd_setup

}




func_java()
{
  func_print_head "install maven"
  yum install maven -y
  func_status_check $?

  func_app_prereq

  func_print_head  "Download maven dependencies"
  mvn clean package
  func_status_check $?
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup

}