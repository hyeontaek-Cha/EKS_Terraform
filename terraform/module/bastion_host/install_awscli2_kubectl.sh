#!/bin/bash

# 기존 AWS CLI1 버전 제거
sudo yum remove awscli -y

# AWS CLI v2 다운로드 및 설치
echo "Downloading AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo "Unzipping AWS CLI v2..."
unzip awscliv2.zip

echo "Installing AWS CLI v2..."
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# AWS CLI v2 설치 파일 제거
rm -rf awscliv2.zip aws/

# kubectl 1.27버전 다운로드
echo "Downloading kubectl..."
curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl.sha256"

# kubectl 바이너리 검증
echo "Verifying kubectl binary..."
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# kubectl 실행 권한 부여 및 이동
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin

# 시스템 전체에 경로 추가 및 alias 설정
echo 'export PATH=$PATH:/usr/local/bin' | sudo tee /etc/profile.d/awscli2.sh

# aws cli 자동 완성 활성화
echo complete -C '/usr/local/bin/aws_completer' aws | sudo tee -a /etc/profile.d/awscli2.sh

# kubectl 자동 완성 활성화
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' | sudo tee -a /etc/profile.d/awscli2.sh
echo "Enable kubectl autocomplete"

# kubectl 자동완성을 alias 'k'에도 적용
echo 'complete -o default -F __start_kubectl k' | sudo tee -a /etc/profile.d/awscli2.sh

# /etc/sudoers 파일에 secure_path 추가
sudo sed -i '/#\?Defaults\s\+secure_path\s*=/c\Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' /etc/sudoers

# 환경 변수 수정, 적용
source /etc/profile

# AWS CLI v2 및 kubectl 설치 확인 (ec2-user)
echo "AWS CLI version (`whoami`):"
aws --version

echo "kubectl version (`whoami`):"
kubectl version --client --short

# AWS CLI v2 및 kubectl 설치 확인 (root)
sudo su - <<EOF

echo "AWS CLI version (\`whoami\`):"
/usr/local/bin/aws --version

echo "kubectl version (\`whoami\`):"
/usr/local/bin/kubectl version --client --short
EOF

echo "AWS CLI v2 and kubectl installation and setup completed."