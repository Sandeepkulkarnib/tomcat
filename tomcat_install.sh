echo "#Tomcat install"
yum install -y python3 java-1.8*

mkdir -p /opt/tomcat
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /opt/
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.65/bin/apache-tomcat-8.5.65.tar.gz 
tar -xzvf apache-tomcat-8.5.65.tar.gz
rm -f apache-tomcat-8.5.65.tar.gz
mv apache-tomcat-8.5.65/* tomcat/
chown -R tomcat:tomcat /opt/tomcat

cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Tomcat
After=syslog.target network.target

[Service]
Type=forking

User=tomcat
Group=tomcat
Restart=always

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment='JAVA_OPTS=-Djava.awt.headless=true'

Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment=CATALINA_PID=/opt/tomcat.pid

ExecStart=/opt/tomcat/bin/catalina.sh start
ExecStop=/opt/tomcat/bin/catalina.sh stop

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat
