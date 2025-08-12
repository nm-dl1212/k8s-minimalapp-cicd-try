#!/bin/bash

# -----
# 設定: k8sでNodePortを公開しているサービスを、ローカルのPortにsocatで転送する。
# -----

set -e

# ユーザーと kubeconfig のパスを設定
USER_NAME=$(whoami)

# systemd サービスファイル作成関数
create_service() {
  local service_name=$1
  local k8s_svc_ip=$2
  local local_port=$3
  local service_port=$4

  cat <<EOF | sudo tee /etc/systemd/system/${service_name}.service > /dev/null
[Unit]
Description=Socat for ${service_name}
After=network.target

[Service]
User=${USER_NAME}
ExecStart=/usr/bin/socat TCP-LISTEN:${local_port},fork,bind=0.0.0.0 TCP:${k8s_svc_ip}:${service_port}
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
}

echo "=== Creating systemd services: PortForwarding Argo CD==="
create_service todo-app 192.168.49.2 30001 30001
sudo systemctl daemon-reload
sudo systemctl enable todo-app
sudo systemctl start todo-app
sudo systemctl status todo-app --no-pager

