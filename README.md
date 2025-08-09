# try-minikube

このプロジェクトは、ローカル環境でKubernetesクラスターを構築し、サンプルのToDoアプリケーション（`todo-app` ディレクトリ内）をデプロイ・動作確認する手順をまとめたものです。

## 概要

Minikubeを使ってローカルにKubernetesクラスターを立ち上げ、`todo-app`（Node.js/Express + MongoDB）をデプロイします。アプリの構成やマニフェストは `todo-app` ディレクトリに含まれています。

## 使い方

### 1. Minikubeのインストール

公式ドキュメントに従い、Minikubeをインストールしてください。

例（Linuxの場合）:

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### 2. クラスターの起動

```sh
minikube start
```

### 3. `todo-app` のデプロイ

`todo-app`ネームスペースを作成し、そこにKubernetesマニフェストに基づいてアプリを展開します。

```sh
cd todo-app
kubectl create ns todo-app 
kubectl apply -f k8s-manifests/ -n todo-app
```

### 4. アプリへのアクセス

サービスが起動したら、MinikubeのサービスURLを確認します

```sh
minikube service list
```

ssh先でminikubeを使用している場合は、以下のコマンドでminikubeのURLを0.0.0.0に転送します。
クライアントPCから、http://{ssh先PCのIP}:30001にアクセスすると、フロントエンドが表示されます。
```sh
sudo socat TCP-LISTEN:30001,fork,bind=0.0.0.0 TCP:xxx.xxx.xx.x:30001
```

### 5. アプリの削除

namespaceを削除することで、デプロイしたリソースを一括削除します。

```sh
kubectl delete ns todo-app

# または、マニフェストをデリーとしてアプリを削除する
kubectl apply -f k8s-manifests/ -n todo-app
```

### 6. クラスターの停止・削除

```sh
minikube stop
minikube delete
```

## ディレクトリ構成

```
.
├── README.md
└── todo-app
    ├── k8s-manifests/
    ├── backend/
    ├── frontend/
    └── ...
```
