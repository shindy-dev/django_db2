# How to build Docker Image & Push to Github Packages

## Create Dockerfile
[Dockerfile](../Dockerfile) - [About this file (Written by AI)](about_Dockerfile.md)

## Create Image
Dockerfileのあるディレクトリで以下実行
```bash
# docker build . -t イメージ名:タグ名  --platform=linux/amd64
docker build . -t django_db2:latest  --platform=linux/amd64
```

## Push Image to *[Github Packages](https://github.co.jp/features/packages)*

### 1. Generate  [tokens](https://github.com/settings/tokens) 
以下の権限を付与
- repo
- write:packages
- delete:packages

---

### 2. Push Image
```bash
# dockerにログイン
echo <your-token> | docker login ghcr.io -u <your-username> --password-stdin

# ローカルのイメージをリポジトリに紐付け
docker tag mydb2:<tag> ghcr.io/<your-username>/<image-name>:<tag>

# pushを実行
docker push ghcr.io/<your-username>/<image-name>:<tag>
```

---

### 3. Confirm Image Push
`https://github.com/<your-username>?tab=packages`にアクセスし、Pushされているか確認

関連リポジトリとの紐付けは任意で実施


## Rebuild & Push Image

```bash
# docker build . -t アカウント名/リモートリポジトリ名:タグ名  --platform=linux/amd64
# docker push ghcr.io/<your-username>/<image-name>:<tag>
docker build . -t ghcr.io/shindy-dev/django_db2:latest  --platform=linux/amd64

# pushを実行
# docker push ghcr.io/<your-username>/<image-name>:<tag>
docker push ghcr.io/shindy-dev/django_db2:latest
```
