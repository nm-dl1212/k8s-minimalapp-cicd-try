# 概要
Argo CDとArgo Workflowの使い方


# インストール
公式のGetting Startを参照


# 起動の確認
以下コマンドでサービスを確認する。

```sh
kubectl get svc -A
```

以下2つのサービスがデプロイされていることを確認。
- NAMESPACE: argo-cd, NAME: argo-cd
- NAMESPACE: argo, NAME: argo-server



# アクセス
以下のようにして、外部からのアクセスが利くようにport-forwardしておく。
永続化したいときはサービスに入れておく。
```sh
kubectl port-forward -n argocd svc/argocd-server 2443:443 --address 0.0.0.0
kubectl port-forward -n argo svc/argo-server 2746:2746 --address 0.0.0.0
```