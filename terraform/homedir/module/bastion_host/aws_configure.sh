#!/bin/bash

echo aws configure `whoami` : 

aws configure set aws_access_key_id YOUR_ACCESS_KEY_ID
aws configure set aws_secret_access_key YOUR_SECRET_ACCESS_KEY
aws configure set default.region MY_REGION
aws configure set output json

cat $HOME/.aws/credentials

# 설정 파일을 root 사용자 홈 디렉토리로 복사
sudo cp -r /home/ec2-user/.aws /root/

sudo su - <<EOF
echo aws configure \`whoami\` : 
cat $HOME/.aws/credentials 
EOF