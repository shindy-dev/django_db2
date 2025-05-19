# [django_db2](https://github.com/shindy-dev/django_db2)

## Abstract
Django勉強用リポジトリ  
ここには環境構築から実際のサイト作成手順を具体的に記載する  
Djangoの概要については[こちら](docs/about_Django.md)（AIまとめ）

## Environment
- ### [Docker Desktop](https://www.docker.com/ja-jp/products/docker-desktop/) on macOS
    version 28.0.4, build b8034c0

    今回使用するイメージ：[shindy0810/django_db2](https://hub.docker.com/r/shindy0810/django_db2)  

    tips. [How to build Docker Image](docs/how2_build_DockerImage.md)

- ### [Miniforge](https://github.com/conda-forge/miniforge)
    conda 23.11.0  
    ※今回使用するコンテナにインストール済みのためセットアップ不要  

    あくまでPythonのバージョン管理として利用し、パッケージ管理はpipで行う

    採用理由(主に消去法により採用)  
    * コンテナ内カーネルのPython環境を汚染したしたくないため
    * コンテナがamd64、ホストOSがmacOS(arm64)である都合上、pyenvでのpython環境構築（クロスコンパイル）が不可だったため
    * anacondaだと肥大化するため

- ### [Python](https://www.python.org/)
    version 3.12.10  
    ※今回使用するコンテナにインストール済みのためセットアップ不要  

    2025年5月時点でDjango4.2が対応している最新バージョンであったため当バージョンを採用

- ### Pythonライブラリ
    ※今回使用するコンテナにインストール済みのためセットアップ不要  
    - ### [django](https://github.com/django/django)==4.2.21
        webアプリのフレームワーク  
        2025年5月時点で最新のバージョンは5.2であるが、ibm_db_djangoの対応バージョンが4.2までであるため、互換性を考慮して当バージョンを採用

    - ### [ibm_db](https://github.com/ibmdb/python-ibmdb)==3.2.6
        Db2データベースとPythonを接続するための公式ドライバ  
        2025年5月時点で最新バージョンを採用  
        [wiki](https://github.com/ibmdb/python-ibmdb/wiki/APIs)

    - ### [ibm_db_django](https://github.com/ibmdb/python-ibmdb-django)==1.5.3.0
        DjangoからDb2データベースへ接続するための公式バックエンドドライバ
        2025年5月時点で最新バージョンを採用

    - ### [build](https://github.com/pypa/build)==1.2.2.post1
        Pythonパッケージのビルド用ライブラリ  
        2025年5月時点で最新バージョンを採用

## How to build Environment
### 1. Pull Image
```bash
docker pull shindy0810/django_db2:latest --platform=linux/amd64
```

---

### 2. Create *.env* for Database
環境依存の設定を.envファイル（任意のパスに作成）に記載する  
※Databaseを使用するために必要な設定
```
USER=dbuser
PASSWORD=dbuser
DBNAME=TESTDB
HOST=mydb2
PORT=50000
PCONNECT=True
```

項目説明  
- USER は DBへ接続するためのユーザー名を指定します。
- PASSWORD は、 DBへ接続するためのパスワードを指定します。
- DBNAME は、指定された名前のDBへ接続します。
- HOST は、指定されたIPでDBへ接続します。
- PORT は、指定されたポートでDBへ接続します。
- PCONNECT は永続的接続（persistent connection） を有効にするかどうかを選択します。
---

### 3. Boot Container

#### Create Custome Network
```bash
# コンテナ間通信用ネットワーク作成
docker network create mynet
```

#### Run Container
```bash
# デーモンプロセスとしてコンテナ起動
docker run -itd -h django_db2 --name django_db2 --restart=always --privileged -p 8000:8000 --env-file ~/.env --network mynet --platform=linux/amd64 shindy0810/django_db2:latest
```
- `-itd`: インタラクティブ・バックグラウンドモード
- `-h django_db2`: ホスト名の設定
- `--name`: コンテナ名を `django_db2` に指定
- `--restart=always`: 自動再起動設定
- `--privileged`: 特権モードで起動
- `-p`: ポートマッピング(8000はdjangoサーバのポート)
- `--env-file`: 環境変数を `.env` ファイルから
- `--network`: ネットワークを指定
- `--platform`: 明示的にプラットフォームを指定
- `shindy0810/django_db2:latest`: 使用するイメージ

---

#### Execute Container
```bash
# /bin/bashで実行
docker exec -it django_db2 /bin/bash
```

#### Remove & Run & Execute Container
- macOS  
    ```bash
    docker stop django_db2 || true && docker rm django_db2 || true && \
    docker run -itd -h django_db2 --name django_db2 --restart=always \
    --privileged -p 8000:8000 --env-file .env --network mynet \
    --platform=linux/amd64 shindy0810/django_db2:latest && \
    docker exec -it django_db2 /bin/bash
    ```

- Windows
    ```powershell
    docker stop django_db2
    docker rm django_db2

    docker run -itd -h django_db2 --name django_db2 --restart=always `
    --privileged -p 8000:8000 --env-file ".env" --network mynet `
    --platform=linux/amd64 shindy0810/django_db2:latest

    docker exec -it django_db2 /bin/bash
    ```
---


## django_db2プロジェクト作成プロセス
`django_db2`プロジェクト作成
```bash
django-admin startproject django_db2 .
```

Djangoサーバの初期設定〜起動まで
```bash
# shindbに対してdjango_db2アプリで定義したmodelを反映（modelを更新する度に要実行）
python manager.py migrate
# 管理者ユーザーの作成
python manager.py createsuperuser
# サーバー起動（「0:8000」は「0.0.0.0:8000」と同義）
python manager.py runserver 0:8000
```
runserver実行後、以下のメッセージが表示されたら起動成功   
```
(django)[root@django_db2 django_db2]# python manager.py runserver 0:8000
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
May 11, 2025 - 20:57:10
Django version 4.2, using settings 'mysite.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```
ホストOSから http://localhost:8000/admin/ にアクセスしてページが表示されることを確認
![admin](docs/adminpage.png)

ホームページ作成
```bash
python manage.py startapp home
```

## 参考文献一覧
* [Djangoドキュメント](https://docs.djangoproject.com/ja/5.2/)
