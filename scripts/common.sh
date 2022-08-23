#! /bin/bash
# 更换 ubuntu 源
sudo sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
sudo sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
sudo apt clean
sudo apt-get update -y

# 下载安装脚本并安装 Docker
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh --mirror Aliyun
# 启动 Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
# docker 镜像加速
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo apt-get install -y selinux-utils ebtables socat conntrack ipset vim 
# 关闭防火墙
sudo ufw disable
# 关闭 selinx
sudo setenforce 0
echo SELINUX=disabled | sudo tee -a /etc/selinux/config
# 关闭 swap
sudo swapoff -a
sudo sed -ri 's/.*swap.*/#&/' /etc/fstab