#!bin/sh

replace=$POD_IP

# We use the envorinmental variable POD_IP to replace the TMP_IP in the index.html file
sed -i "s/TMP_IP/$replace/" /usr/share/nginx/html/index.html