#!/bin/bash
cd /home/ubuntu/
sudo apt-get update -y
sudo apt install -y git maven
sudo apt-get install -y docker docker.io docker-compose
sudo git clone https://github.com/beri-sela/signal-server
mv /home/ubuntu/signal-server /home/ubuntu/signal
sudo apt-get install -y nginx
cd /home/ubuntu/signal && sudo docker-compose up -d && \
cd /home/ubuntu/signal && git clone https://github.com/signalapp/signal/Signal-Server.git
cd /home/ubuntu/signal/Signal-Server && git checkout v4.97
cd /home/ubuntu/signal/Signal-Server && mvn -DskipTests package
# sudo docker run -d --restart unless-stopped --name accountdb -e "POSTGRES_PASSWORD=postgres" -e "POSTGRES_DB=accountdb" -p 5432:5432 postgres:11 && \
# sudo docker run -d --restart unless-stopped --name abusedb -e "POSTGRES_PASSWORD=postgres" -e "POSTGRES_DB=abusedb" -p 5433:5432 postgres:11  && \
# sudo docker run -d --restart unless-stopped --name messagedb -e "POSTGRES_PASSWORD=postgres" -e "POSTGRES_DB=messagedb" -p 5434:5432 postgres:11
cp /home/ubuntu/signal/config.yml /home/ubuntu/signal/Signal-Server/config.yml
java -jar /home/ubuntu/signal/Signal-Server/service/target/TextSecureServer-4.97.jar accountdb migrate /home/ubuntu/signal/Signal-Server/config.yml  && \
java -jar /home/ubuntu/signal/Signal-Server/service/target/TextSecureServer-4.97.jar abusedb migrate /home/ubuntu/signal/Signal-Server/config.yml  && \
java -jar /home/ubuntu/signal/Signal-Server/service/target/TextSecureServer-4.97.jar messagedb migrate /home/ubuntu/signal/Signal-Server/config.yml  
# sudo docker run -d --restart unless-stopped --name redis -e "IP=0.0.0.0" -p 7000-7005:7000-7005 grokzen/redis-cluster:latest
# sudo docker run -d --restart unless-stopped --name nginx --net="host" -v /home/ubuntu/nginx/nginx.conf:/etc/nginx/nginx.conf:ro nginx
cd /home/ubuntu/
echo "Open config.yml in signal/Signal-Server and make any changes there then run: 
java -jar /home/ubuntu/signal/Signal-Server/service/target/TextSecureServer-4.97.jar server /home/ubuntu/signal/Signal-Server/config.yml
OR as below as daemon
nohup java -jar /home/ubuntu/signal/Signal-Server/service/target/TextSecureServer-4.97.jar server /home/ubuntu/signal/Signal-Server/config.yml &>/dev/null &"
