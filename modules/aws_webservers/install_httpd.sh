#!/bin/bash
yum -y update
yum -y install httpd

systemctl start httpd
systemctl enable httpd

myip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<h1>Yiming - NONPROD Web Server</h1>
<p>Private IP: $myip</p>
EOF