#!/bin/bash

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