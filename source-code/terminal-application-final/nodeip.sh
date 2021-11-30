#!bin/sh

filename="/usr/share/nginx/html/index.html"
search="POD_IP"
replace=$MY_POD_IP
 
sed -i "s/$search/$replace/" $filename