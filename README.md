# [shindjango](https://github.com/shindy-dev/shindjango)

## 概要
Django勉強用リポジトリ  
ここには環境構築から実際のサイト作成手順を具体的に記載する  
Djangoの概要については[こちら](docs/aboutDjango.md)

## 環境
- ### [Docker Desktop](https://www.docker.com/ja-jp/products/docker-desktop/) on macOS
    version 28.0.4, build b8034c0

    今回使用するイメージ：[shindy0810/shindjango](https://hub.docker.com/r/shindy0810/shindjango)  
    ┗[Db2 Community Edition for Docker](https://www.ibm.com/docs/ja/db2/11.5.x?topic=deployments-db2-community-edition-docker)のDockerイメージ(Red Hat Enterprise Linux 9)をベースにDjango用のライブラリをインストールしたイメージ  
    ┗[どのようにイメージを作成したか](docs/buildDockerImage.md)  

    tips. Red HatはLinuxベースのOSであり、Linuxコンテナは通常Linuxカーネルに依存するため、Linux上での実行が前提となる。しかし、Docker DesktopではmacOSではLinux仮想マシン（VM）、WindowsではWSL2などの仮想基盤を用いることで、非Linux OS上でもLinuxコンテナの実行を可能としている

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

## 環境構築
### Dockerイメージ取得
[Docker Desktop on macOS](#Docker-Desktop-on-macOS)に記載したイメージをpull（取得）する
```bash
docker pull shindy0810/shindjango:latest --platform=linux/amd64
```

---

### .env作成
環境依存の設定を.envファイル（任意のパスに作成）に記載する  
※DB2を使用するために必要な設定
```
LICENSE=accept
DB2INSTANCE=db2inst1
DB2INST1_PASSWORD=db2inst1
DBNAME=
BLU=false
ENABLE_ORACLE_COMPATIBILITY=false
UPDATEAVAIL=NO
TO_CREATE_SAMPLEDB=false
REPODB=false
IS_OSXFS=true
PERSISTENT_HOME=true
HADR_ENABLED=false
ETCD_ENDPOINT=
ETCD_USERNAME=
ETCD_PASSWORD=
```

項目説明  
- LICENSE は、このイメージに含まれる Db2 ソフトウェアの契約条件に同意します。
- DB2INSTANCE は Db2 インスタンス名を指定します。
- DB2INST1_PASSWORD は、 Db2 インスタンスのパスワードを指定します。
- DBNAME は、指定された名前で初期データベースを作成します (データベースが必要ない場合は空のままにします)
- BLU は、 Db2 インスタンスの BLU Acceleration を使用可能 (true) または使用不可 (false) に設定します。
- ENABLE_ORACLE_COMPATIBILITY は、インスタンスの Oracle 互換性を有効 (true) または無効 (false) に設定します
- より高い Db2 レベルで新規コンテナーを実行している既存のインスタンスがある場合は、UPDATEAVAIL を YES に設定できます。
- TO_CREATE_SAMPLEDB は、サンプル (定義済み) データベースを作成します (true)
- REPODB は、Data Server Manager リポジトリー・データベースを作成します (true)
- IS_OSXFS は、オペレーティング・システムを macOS として認識します (true)
- PERSISTENT_HOME はデフォルトで、true に設定されており、Docker for Windows を実行している場合にのみ false として指定する必要があります
- HADR_ENABLED は、インスタンスの Db2 HADR を構成します (true)。 以下の 3 つの環境変数は、HADR_ENABLED が true に設定されていることに依存します。
- ETCD_ENDPOINT は、ユーザー自身が指定した ETCD キー値ストアを指定します。 コンマ (スペースなし) を区切り文字としてエンドポイントを入力します。 HADR_ENABLED が true に設定されている場合、この環境変数が必要です。
- ETCD_USERNAME は、ETCD のユーザー名資格情報を指定します。 空のままにすると、 Db2 インスタンスが使用されます。
- ETCD_PASSWORD は、ETCD のパスワード資格情報を指定します。 空のままにすると、 Db2 インスタンス・パスワードが使用されます。  
参考：https://www.ibm.com/docs/ja/db2/11.5.x?topic=system-macos

---

### コンテナの起動
以下のコマンドで既存のコンテナやボリューム（もしあれば）の削除、作成、コンテナに入るまでまとめて行う（「.env」のパスは適宜修正）

macOS  
```bash
docker stop shindjango || true && docker rm shindjango || true && \
docker volume rm v_shindjango || true && \
docker volume create v_shindjango && \
docker run -itd -h shindjango --name shindjango --restart=always \
--privileged -p 8000:8000 -p 50000:50000 --env-file .env \
-v v_shindjango:/database --platform=linux/amd64 shindy0810/shindjango:latest && \
docker exec -it shindjango /bin/bash
```

Windows
```powershell
docker stop shindjango
docker rm shindjango
docker volume rm v_shindjango
docker volume create v_shindjango

docker run -itd -h shindjango --name shindjango --restart=always `
--privileged -p 8000:8000 -p 50000:50000 --env-file ".env" `
-v v_shindjango:/database --platform=linux/amd64 shindy0810/shindjango:latest

docker exec -it shindjango /bin/bash
```

#### 1. 停止と削除（失敗しても続行）

```bash
docker stop shindjango || true && docker rm shindjango || true
```

- `docker stop shindjango`: コンテナ `shindjango` を停止
- `|| true`: 失敗してもエラーを無視して続行
- `docker rm shindjango`: 停止したコンテナを削除

---

#### 2. DB格納用ボリューム削除（失敗しても続行）

```bash
docker volume rm v_shindjango || true
```

- `v_shindjango` ボリュームを削除
- 存在しなくても `|| true` により続行

---

#### 3. DB格納用ボリューム作成

```bash
docker volume create v_shindjango
```

- 新しいボリューム `v_shindjango` を作成

---

#### 4. コンテナ起動

```bash
docker run -itd -h shindjango --name shindjango --restart=always \
--privileged -p 8000:8000 -p 50000:50000 --env-file ~/.env \
-v v_shindjango:/database --platform=linux/amd64 shindy0810/shindjango:latest
```

- `-itd`: インタラクティブ・バックグラウンドモード
- `-h shindjango`: ホスト名の設定
- `--name`: コンテナ名を `shindjango` に指定
- `--restart=always`: 自動再起動設定
- `--privileged`: 特権モードで起動
- `-p`: ポートマッピング(8000はdjangoサーバのポート、50000はdb2サーバのポート)
- `--env-file`: 環境変数を `.env` ファイルから
- `-v`: ボリュームを `/database` にマウント
- `--platform`: 明示的にプラットフォームを指定
- `shindy0810/shindjango:latest`: 使用するイメージ

---

#### 5. コンテナの中に入る

```bash
docker exec -it shindjango /bin/bash
```

- 起動したコンテナに `bash` で入る。

## shindjangoプロジェクト作成プロセス
`shindjango`プロジェクト作成
```bash
django-admin startproject shindjango .
```

Djangoで使うDBの作成
```bash
# db2インスタンス操作用のユーザーに切り替え
su db2inst1
# db2サーバの起動
db2start
# mysite/settings.pyのDATABASESに設定したDBの作成
db2 create db shindb
# db2の操作終了
exit
```
Djangoサーバの初期設定〜起動まで
```bash
# shindbに対してshindjangoアプリで定義したmodelを反映（modelを更新する度に要実行）
python manager.py migrate
# 管理者ユーザーの作成
python manager.py createsuperuser
# サーバー起動（「0:8000」は「0.0.0.0:8000」と同義）
python manager.py runserver 0:8000
```
runserver実行後、以下のメッセージが表示されたら起動成功   
```
(django)[root@shindjango shindjango]# python manager.py runserver 0:8000
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



## 参考文献一覧
* [Djangoドキュメント](https://docs.djangoproject.com/ja/5.2/)
* [Mac M1 Docker DesktopでDb2を動かす #db2 - Qiita](https://qiita.com/kayokok/items/0d23efeece19c4f31e8b)
