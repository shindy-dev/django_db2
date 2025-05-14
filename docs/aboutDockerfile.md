
# Dockerfile 解説

この Dockerfile は、IBM Db2 の公式 Docker イメージをベースに、Python + Django 環境（Miniforge + Conda）を構築し、`shindy-dev/shindjango` リポジトリの Django プロジェクトをビルド・実行できるようにする構成です。以下に各ステップを解説します。

---

## 🔧 **全体構成の目的**
- ベース：`icr.io/db2_community/db2`
- Python: `Miniforge` を使用して Conda 環境を構築
- Django: 特定リポジトリからコードを取得してビルド
- コンテナ実行時に Django 環境が有効な状態に設定

---

## 🧱 **各ステップの解説**

---

```Dockerfile
FROM icr.io/db2_community/db2
```
- **ベースイメージ**に IBM Db2 のコミュニティエディションを指定。
- この時点で、Db2 サーバーが動作するための環境が整っています。

---

```Dockerfile
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH="$CONDA_DIR/bin:$PATH"
```
- `DEBIAN_FRONTEND=noninteractive`：パッケージインストール時の対話入力を無効に。
- `CONDA_DIR`：Miniforge をインストールするディレクトリを定義。
- `PATH`：conda を直接使えるように PATH を設定。

---

```Dockerfile
RUN dnf install -y -q git wget bzip2 && dnf clean all
```
- `dnf`（Red Hat系のパッケージマネージャ）で必要パッケージをインストール。
- `git`: コード取得用
- `wget`: Miniforge ダウンロード用
- `bzip2`: Pythonパッケージ圧縮形式などの対応
- `dnf clean all`: キャッシュ削除でイメージサイズを最適化

---

### Miniforge のインストール
```Dockerfile
RUN wget -q https://.../Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm Miniforge3-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda init && \
    $CONDA_DIR/bin/conda clean --all --yes
```
- Miniforge をバージョン固定でダウンロード・インストール
- `-b`: 非対話モードでインストール
- `-p`: インストール先ディレクトリ指定
- `conda init`: シェルの初期化設定
- `conda clean`: キャッシュ削除（軽量化）

---

### プロジェクトに移動
```Dockerfile
WORKDIR /home/dev/github/shindjango
```

---

### Conda 環境作成とパッケージインストール
```Dockerfile
RUN /bin/bash -c "source $CONDA_DIR/etc/profile.d/conda.sh && \
                  conda create -n django python=3.12.10 -y --quiet && \
                  conda activate django && \
                  pip install  --quiet --no-cache-dir -r requirements.txt && \
                  conda clean --all --yes"
```
- Conda シェルスクリプトを source で読み込み
- `django` という名前の Conda 環境を作成（Python 3.12.10 指定）
- 依存関係のインストール
- キャッシュ削除

---

### 不要キャッシュ削除
```Dockerfile
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*
```
- コンテナサイズをさらに削減

---

### ポートの公開
```Dockerfile
EXPOSE 8000 50000
```
- Django（8000）と Db2（50000）で使用されるポートを公開

---

### Conda 環境の有効化
```Dockerfile
RUN echo "conda activate django" >> ~/.bashrc
SHELL ["/bin/bash"]
```
- `.bashrc` に `conda activate django` を追記
- `SHELL` を bash に変更（sh では `conda activate` が使えないため）

---

## ✅ この Dockerfile の特徴
- Miniforge（軽量な Conda）ベースの環境構築
- ビルドと不要ファイル削除による軽量化
- Django プロジェクトの自動ビルド＆インストール
