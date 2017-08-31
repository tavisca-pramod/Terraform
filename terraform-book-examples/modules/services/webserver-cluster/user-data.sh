#!/bin/bash
                yum update -y
                yum install httpd -y
                service httpd start
                chkconfig httpd on
                echo "<h1>hello world</h1>" >> /var/www/html/index.html
                echo "<p>DB address = ${db_address}</p>">> /var/www/html/index.html
                echo "<p>DB port = ${db_port}</p>">> /var/www/html/index.html
                EOF

