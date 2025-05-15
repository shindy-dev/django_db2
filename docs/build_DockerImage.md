# Dockerイメージの作成とDocker HubへPush

## Dockerfileの作成
[Dockerfile](Dockerfile)  
[AIによるこのプロジェクトのDockerFile解説](aboutDockerfile)

## イメージの作成
Dockerfileのあるディレクトリで以下を実行
```bash
# docker build . -t イメージ名:タグ名  --platform=linux/amd64
docker build . -t shindjango:latest  --platform=linux/amd64
```

## 作成したイメージをDocker Hubへpush
事前に[Docker Hub](https://hub.docker.com/)でリポジトリを作成した後、ローカルで以下を実行
```bash
# dockerにログイン
docker login -u アカウント名 -p パスワード

# ローカルのイメージをリポジトリに紐付け
# docker tag ローカルイメージ名:タグ名 アカウント名/リモートリポジトリ名:タグ名
docker tag shindjango:latest shindy0810/shindjango:latest

# pushを実行
# docker push アカウント名/リモートリポジトリ名:タグ名
docker push shindy0810/shindjango:latest
```

## イメージの更新

```bash
# docker build . -t アカウント名/リモートリポジトリ名:タグ名  --platform=linux/amd64
docker build . -t shindy0810/shindjango:latest  --platform=linux/amd64
# pushを実行
# docker push アカウント名/リモートリポジトリ名:タグ名
docker push shindy0810/shindjango:latest
```