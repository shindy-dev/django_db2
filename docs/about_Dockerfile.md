# Dockerfile 解説（Python + Miniforge + Django 環境）【APT版】

この Dockerfile は、`python:3.11-slim` イメージをベースに、Miniforge（Conda）を利用して Django 環境を構築するためのものです。パッケージ管理には `apt` を使用しています。

---

## 🧱 ベースイメージと環境変数

```dockerfile
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH="$CONDA_DIR/bin:$PATH"
```

- `python:3.11-slim` をベースとした軽量なPython環境。
- Conda のインストール先と PATH を設定。
- `DEBIAN_FRONTEND=noninteractive` により、非対話形式で apt を実行。

---

## 📦 必要パッケージのインストール（APT使用）

```dockerfile
RUN apt update && apt upgrade -y && apt install -y && \
    git wget bzip2 && \
    apt autoremove -y && apt autoclean -y
```

- `apt update && upgrade` により最新状態へ更新。
- `git`, `wget`, `bzip2` をインストール。
- `autoremove` で不要パッケージを削除し、`autoclean` で古いキャッシュを削除。

---

## 🐍 Miniforge（Conda）のインストール

```dockerfile
RUN wget --no-check-certificate https://github.com/conda-forge/miniforge/releases/download/23.11.0-0/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p $CONDA_DIR && rm Miniforge3-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda init && $CONDA_DIR/bin/conda clean --all --yes
```

- Miniforge（Condaの軽量版）をダウンロード・インストール。
- Condaの初期化とキャッシュクリアを実行。

---

## 📚 Python環境と依存パッケージのセットアップ

```dockerfile
COPY docker/requirements.txt /root/requirements.txt
RUN chmod +x /root/requirements.txt
```

- 必要なPythonパッケージを指定した `requirements.txt` をコンテナにコピーし、実行可能に。

```dockerfile
RUN /bin/bash -c "source $CONDA_DIR/etc/profile.d/conda.sh && conda create -n django python=3.12.10 -y && conda activate django && \
    pip install --no-cache-dir -r /root/requirements.txt && \
    conda clean --all --yes"
```

- Conda環境 `django` を作成し、Python 3.12.10 をインストール。
- pip で依存パッケージをインストールし、キャッシュ削除。

---

## 🔁 Conda環境を自動有効化

```dockerfile
RUN sed -i '$a conda activate django' /root/.bashrc
```

- `.bashrc` に Conda環境のアクティベートコマンドを追記。

---

## 🧹 キャッシュ削除と軽量化

```dockerfile
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*
```

- コンテナ内の不要な一時ファイルやキャッシュを削除。

---

## 🌐 ポートと作業ディレクトリ

```dockerfile
EXPOSE 8000
WORKDIR /home/dev/github/shindjango
```

- Django の開発サーバーで使用する 8000 番ポートを公開。
- 作業ディレクトリを指定。

---

## 📜 スクリプトの配置と設定

```dockerfile
COPY docker/scripts/postprocessing.sh /var/custom/postprocessing.sh
RUN chmod +x /var/custom/postprocessing.sh

COPY docker/scripts/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
```

- 後処理スクリプト・エントリースクリプトを配置し、実行権限を付与。

---

## 🚀 起動設定

```dockerfile
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["0.0.0.0:8000"]
```

- コンテナ起動時に `entrypoint.sh` を実行。
- `CMD` の引数は Django のサーバーアドレス指定などに使用可能。

---
