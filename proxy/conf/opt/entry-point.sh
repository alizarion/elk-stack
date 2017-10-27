#!/bin/sh

#Check if we are asked to process old logs

if [ x${BACKEND_IP} = x"12.34.56.78" ]
	then
	echo "You need to set the BACKEND_IP"
	echo "Run with:"
	echo "    docker run -e BACKEND_IP=<your_backend_ip> -p 80:80 -p 8081:8081 itesoft/bla"
	exit 1
else
	sed -i "s#proxy_redirect_ip#${BACKEND_IP}#" /etc/nginx/sites-enabled/default
fi


if [ x${LEARNING_MODE} != x"yes" ]
	then
	sed -i 's/LearningMode;//g' /etc/nginx/naxsi.rules
	echo "LearningMode is disabled - Blocking requests"
	else
	echo "LearningMode is enabled"
fi

if [ ! -z "$SERVER_NAME" ]
    then
	echo "Server name :"
	echo $SERVER_NAME
    else
    export SERVER_NAME="localhost"
	echo "Setting server name as default value : localhost"
fi
sed -i  -e "s;%SERVER_NAME%;${SERVER_NAME};g"  /etc/nginx/sites-enabled/default

if [ x${SSL_MODE} != x"prod" ]
	then
	echo "SSL mode enabled"
	else
	echo "SSL mode TEST, self signed certificate will be generated"
fi

if [ x${FORCE_SSl} != x"yes" ]
	then
	echo "SSL redirect enabled"
	sed -i  -e "s,%FORCE_SSl%,if (\$scheme = http) { return 301 https://\$server_name\$request_uri;  break; },g"  /etc/nginx/sites-enabled/default
	else
    sed -i  -e "s;%FORCE_SSl%;;g"  /etc/nginx/sites-enabled/default

	echo "SSL mode TEST, self signed certificate will be generated"
fi



echo $@

exec "$@"