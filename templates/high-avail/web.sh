#!/bin/bash
yum update -y
yum install httpd -y
cd /var/www/html
echo "<html><body><h1> Hello from Nathan Meehan at $(hostname -f) </html></body></h1>" > index.html
systemctl restart httpd
systemctl enable httpd