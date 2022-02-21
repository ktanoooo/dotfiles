
#################################
# initial setups
#################################
# root user change password
sudo passwd root ...

# update packages
sudo yum update

#################################
# create new user
#################################
sudo adduser username
sudo passwd username ...
## If the user is sudo user
sudo usermod -aG wheel username

## Add ssh settings for created user
sudo su - username
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#################################
# firewalld
#################################
sudo systemctl status firewalld  # nothing
sudo yum -y install firewalld
sudo systemctl status firewalld  # installed
## start
sudo systemctl start firewalld
## auto enable
sudo systemctl enable firewalld
sudo systemctl is-enabled firewalld # check auto enable
## firewall-cmd
sudo firewall-cmd --state  # 起動確認
sudo firewall-cmd --get-active-zone  # 現在利用されているゾーン名確認
sudo firewall-cmd --list-all  # 利用されているゾーンの詳細確認
sudo firewall-cmd --list-services  # 現在のゾーンで許可されているサービスの一覧表示
sudo firewall-cmd --get-services  # 定義されているサービスの一覧表示
sudo firewall-cmd --get-icmptypes  # 定義されているicmpの一覧表示
sudo firewall-cmd --permanent --add-service=サービス名  # サービスを現在のゾーンに追加
sudo firewall-cmd --permanent --remove-service=サービス名  # 現在のゾーンからサービスを取り除く
sudo firewall-cmd --reload  # 定義の再読み込み
sudo firewall-cmd --permanent --new-service-from-file=サービス名.xml --name=サービス名	サービス名  # xmlファイルでサービスを登録
sudo firewall-cmd --permanent --delete-service=サービス名  # サービス定義を削除
sudo firewall-cmd --permanent --zone=ゾーン名 --add-service=サービス名  # 現在のゾーンに指定したサービスを追加
sudo firewall-cmd --permanent --zone=ゾーン名 --remove-service=サービス名  # 現在のゾーンから指定したサービスを取り除く

#################################
# Setup docker
#################################
sudo yum install -y docker
## start
sudo systemctl start docker
## auto enable
sudo systemctl enable docker
sudo systemctl is-enabled docker # check auto enable
sudo usermod -aG docker ec2-user  # Add ec2-user to docker group
exit 
## install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
#################################
# Run Nginx container
#################################
docker run -d nginx
docker image ls
