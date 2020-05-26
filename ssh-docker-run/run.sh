#!/bin/sh

IAM=$1
echo "$1" >> oauth.txt
#echo "$IAM" >> iam2.txt

#docker login --username iam --password ${IAM} cr.yandex

#cat iam4.txt | sudo docker login --username iam --password-stdin
cat oauth.txt | sudo docker login --username oauth --password-stdin cr.yandex

sudo docker pull cr.yandex/$2/test-image:latest

sudo docker run -d cr.yandex/$2/test-image:latest
