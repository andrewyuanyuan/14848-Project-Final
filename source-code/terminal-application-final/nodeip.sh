#!bin/sh

replace=$MY_POD_IP

sed -i "s/POD_IP/$replace/" /usr/share/nginx/html/index.html