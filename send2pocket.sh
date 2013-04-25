#!/bin/bash

#-------------------------------------------------------

ACCESS_TOKEN=""

#-------------------------------------------------------

CONSUMER_KEY="13431-3b6a09e0bf7bf59869718a0e"

if [ -z "$ACCESS_TOKEN" ]; then
	CODE=`curl -H "Content-Type: application/json" -X POST -d '{"consumer_key":"'$CONSUMER_KEY'","redirect_uri":"void:ok"}' https://getpocket.com/v3/oauth/request`

	CODE=`echo $CODE|cut -c 6-`

	echo Request-token: $CODE

	#TODO: Change redir uri to project page
	echo "Requiring authorization! Go to following url:"
	echo "https://getpocket.com/auth/authorize?request_token=$CODE&redirect_uri=https://gist.github.com/LauriM/5453874"
	echo ""

	echo "Press enter when you have authorized the application."
	read null

	echo ""

	ACCESS_TOKEN=`curl -H "Content-Type: application/json" -X POST -d '{"consumer_key":"'$CONSUMER_KEY'","code":"'$CODE'"}' https://getpocket.com/v3/oauth/authorize`

	echo "Edit this scripts header to include the following access token:"
	echo "$ACCESS_TOKEN"
	exit
fi

if [ -z "$1" ]; then
	echo -n "Enter url: "
	read URL
else
	URL=$1
fi

curl -H "Content-Type: application/json" -X POST -d '{"url":"'$URL'","consumer_key":"'$CONSUMER_KEY'","access_token":"'$ACCESS_TOKEN'"}' https://getpocket.com/v3/add
