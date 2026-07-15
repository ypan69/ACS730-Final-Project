#!/bin/bash

yum -y update
yum -y install httpd

systemctl start httpd
systemctl enable httpd

# Download images from private S3 bucket
aws s3 cp s3://${bucket_name}/image/banner.jpg /var/www/html/banner.jpg
aws s3 cp s3://${bucket_name}/image/logo.png /var/www/html/logo.png

myip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<html>
<head>
<title>${prefix} ${env} Web Server</title>
</head>

<body>

<img src="banner.jpg" width="800" alt="Banner">

<h1>${prefix} ${env} Web Server</h1>

<h2>Team Member</h2>
<p>Yiming</p>

<img src="logo.png" width="200" alt="Logo">

<p>Private IP: $myip</p>

</body>
</html>
EOF