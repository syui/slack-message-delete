#!/bin/zsh

d=${0:a:h}
f=$d/history.json
e=~/.config/slack/api.txt

# token
# https://api.slack.com/custom-integrations/legacy-tokens
if [ -f $e ];then
	token=`cat $e`
else
	if [ -z "$1" ];then
		exit
	fi
	token=$1
fi
slack=https://slack.com/api

# channels.list
# https://api.slack.com/methods/channels.list
url="$slack/channels.list?token=$token"
json_channel=`curl -sL $url| jq .`
oldest=`echo $json_channel|jq -r '.channels[0]|.created'`
channel=`echo $json_channel|jq -r '.channels[0].id'`
name=`echo $json_channel|jq -r '.channels[0].name'`

if [ "$name" != "general" ];then
	exit
fi

latest=`date "+%s"`


for (( ii=1;ii<=1000;ii++ ))
do
	# channels.history
	# https://api.slack.com/methods/channels.history
	url=$slack/channels.history
	json_history=`curl -s -F token=$token -F channel=$channel -F count=1000 $url | jq .`
	history_length=`echo $json_history| jq '.messages|length'`
	if [ $history_length -eq 0 ];then
		exit
	fi
	
	# chat.delete
	# https://api.slack.com/methods/chat.delete
	ts_list=`echo $json_history|jq -r '.messages|.[].ts'`
	ts_list_attachments=`echo $json_history|jq -r '.messages|.[].attachments|.[].ts'`
	url=$slack/chat.delete
	for ((i=1;i<=`echo "$ts_list"|wc -l`;i++ ))
	do
		ts=`echo "$ts_list"| awk "NR==$i"`
		as_user=true
		curl -H "Content-Type: application/x-www-form-urlencoded" -X POST -d token=$token -d channel=$channel -d ts=$ts -d as_user=$as_user $url
	done
	#for ((i=1;i<=`echo "$ts_list_attachments"|wc -l`;i++ ))
	#do
	#	ts=`echo "$ts_list_attachments"| awk "NR==$i"`
	#	as_user=true
	#	curl -H "Content-Type: application/x-www-form-urlencoded" -X POST -d token=$token -d channel=$channel -d ts=$ts -d as_user=$as_user $url
	#done
done
