#!/bin/bash

# -----
# 設定: ArgoCD と Argo Workflows のポートフォワードを設定する。
# -----

set -e

# ユーザーと kubeconfig のパスを設定
USER_NAME=$(whoami)
KUBECONFIG_PATH="/home/$USER_NAME/.kube/config"

# systemd サービスファイル作成関数
create_service() {
  local service_name=$1
  local namespace=$2
  local svc_name=$3
  local local_port=$4
  local remote_port=$5

  cat <<EOF | sudo tee /etc/systemd/system/${service_name}.service > /dev/null
[Unit]
Description=kubectl port-forward for ${service_name}
After=network.target

[Service]
User=${USER_NAME}
Environment=KUBECONFIG=${KUBECONFIG_PATH}
ExecStart=/usr/bin/kubectl port-forward -n ${namespace} svc/${svc_name} ${local_port}:${remote_port} --address 0.0.0.0
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
}

echo "=== Creating systemd services: PortForwarding Argo CD==="
create_service "pf-argocd" "argocd" "argocd-server" 2443 443
sudo systemctl daemon-reload
sudo systemctl enable pf-argocd
sudo systemctl start pf-argocd
sudo systemctl status pf-argocd --no-pager


echo "=== Creating systemd services: PortForwarding Argo Workflow ==="
create_service "pf-argo" "argo" "argo-server" 2746 2746
sudo systemctl daemon-reload
sudo systemctl enable pf-argo
sudo systemctl start pf-argo
sudo systemctl status pf-argo --no-pager

