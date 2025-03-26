#!/bin/bash

# Cập nhật hệ thống
echo "Cập nhật hệ thống..."
sudo apt update

# Cài đặt các gói cần thiết
echo "Cài đặt các gói cần thiết..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Thêm key GPG của Docker
echo "Thêm key GPG của Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Thêm repository của Docker
echo "Thêm repository của Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Cập nhật hệ thống lần nữa
echo "Cập nhật hệ thống lần nữa..."
sudo apt update

# Kiểm tra chính sách cài đặt Docker
echo "Kiểm tra chính sách Docker..."
apt-cache policy docker-ce

# Cài đặt Docker
echo "Cài đặt Docker..."
sudo apt install -y docker-ce

# Kiểm tra trạng thái Docker
echo "Kiểm tra trạng thái Docker..."
sudo systemctl status docker --no-pager

# Kéo image n8n từ Docker Hub
echo "Kéo image n8n từ Docker Hub..."
sudo docker pull n8nio/n8n

# Liệt kê các image Docker
echo "Danh sách image Docker:"
sudo docker images

# Cài đặt ngrok
echo "Cài đặt ngrok..."
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update
sudo apt install -y ngrok

# Cấu hình ngrok với token cá nhân (hãy thay thế bằng token thật của bạn)
NGROK_TOKEN="2sx36nSXbvo2J4gCU5rXwsYsvWW_3uuem4dszSAhrW2ZAkAPU"
echo "Thêm token vào ngrok..."
ngrok config add-authtoken $NGROK_TOKEN



# Chạy container Docker cho n8n
echo "Chạy container Docker cho n8n..."
sudo docker run -d --name n8n -p 5678:5678 \
    -e N8N_EDITOR_BASE_URL=wrongly-tolerant-humpback.ngrok-free.app \
    -e N8N_SECURE_COOKIE=false \
    -e GENERIC_TIMEZONE=Asia/Ho_Chi_Minh \
    n8nio/n8n
    
# Chạy ngrok để mở cổng HTTP
echo "Chạy ngrok..."
ngrok http --url=wrongly-tolerant-humpback.ngrok-free.app 5678 > /dev/null &
