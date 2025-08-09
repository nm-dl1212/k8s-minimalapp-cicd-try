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


# デプロイメント
名前空間を先に作っておく。
```sh
kubectl create ns todo-prod
```

secretを作成する。
ファイル中の`POSTGRES_PASSWORD`のセクションを任意の値で書き換える。
```sh
cp k8s-manifests/config/db-secret.yaml.template k8s-manifests/config/db-secret.yaml
```

config/* を先にアプライする。
これらはargo-cdの自動デプロイの対象外。
```sh
kubectl apply -n todo-prod -f k8s-manifests/config/
```

algo-cdにアプリケーションを作登録する。
```sh
kubectl apply -f k8s-manifests/argocd/ 
```
deployment/* のマニフェストを対象に、自動デプロイが実行される
**ここで参照しているのはローカルのマニフェストファイルではなく、githubレポジトリの方であることが重要!!!**


以降、deployment/* 以下のマニフェストに修正が入ったときのみ、自動デプロイが実行される。