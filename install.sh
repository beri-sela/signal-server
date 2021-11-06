#!/bin/bash
cd
sudo apt-get update -y
sudo apt install -y git maven
sudo apt-get install -y docker docker.io
sudo git clone https://github.com/beri-sela/signal-server
mv ~/signal-server ~/signal
sudo apt-get install -y nginx
cd ~/signal && sudo docker-compose up -d && \
git clone https://github.com/signalapp/signal/Signal-Server.git -b v4.97
cd ~/signal/Signal-Server && mvn -DskipTests package
# sudo docker run -d --restart unless-stopped --name accountdb -e "POSTGRES_PASSWORD=postgres" -e "POSTGRES_DB=accountdb" -p 5432:5432 postgres:11 && \
# sudo docker run -d --restart unless-stopped --name abusedb -e "POSTGRES_PASSWORD=postgres" -e "POSTGRES_DB=abusedb" -p 5433:5432 postgres:11  && \
# sudo docker run -d --restart unless-stopped --name messagedb -e "POSTGRES_PASSWORD=postgres" -e "POSTGRES_DB=messagedb" -p 5434:5432 postgres:11
cp ~/signal/config.yml ~/signal/Signal-Server/config.yml
java -jar ~/signal/Signal-Server/service/target/TextSecureServer-4.97.jar accountdb migrate ~/signal/Signal-Server/config.yml  && \
java -jar ~/signal/Signal-Server/service/target/TextSecureServer-4.97.jar abusedb migrate ~/signal/Signal-Server/config.yml  && \
java -jar ~/signal/Signal-Server/service/target/TextSecureServer-4.97.jar messagedb migrate ~/signal/Signal-Server/config.yml  
# sudo docker run -d --restart unless-stopped --name redis -e "IP=0.0.0.0" -p 7000-7005:7000-7005 grokzen/redis-cluster:latest
# sudo docker run -d --restart unless-stopped --name nginx --net="host" -v /home/ubuntu/nginx/nginx.conf:/etc/nginx/nginx.conf:ro nginx
cd
echo "Open config.yml in signal/Signal-Server and make any changes there then run: \n
nohup java -jar ~/signal/Signal-Server/service/target/TextSecureServer-4.97.jar server ~/signal/Signal-Server/config.yml \n 
OR as below as daemon \n
nohup java -jar ~/signal/Signal-Server/service/target/TextSecureServer-4.97.jar server ~/signal/Signal-Server/config.yml &>/dev/null &"
