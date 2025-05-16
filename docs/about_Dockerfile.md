# Dockerfile 解説ドキュメント

このドキュメントでは、`ubuntu/nginx:1.24-24.04_edge` イメージをベースにしたDockerfileの構成について詳しく解説します。

---

## ベースイメージの指定

```
FROM ubuntu/nginx:1.24-24.04_edge
```

Ubuntu 24.04ベースの Nginx 組み込みイメージを使用。Webサーバとしての機能を提供しつつ、Python環境も追加構築する目的。

---

## 環境変数の設定

```
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH="$CONDA_DIR/bin:$PATH"
```

- `DEBIAN_FRONTEND=noninteractive`：apt実行時に対話的プロンプトを表示しない。
- `CONDA_DIR`：Miniforgeのインストール先。
- `PATH`：condaコマンドをパスに追加。

---

## パッケージのインストール

```
RUN apt update && apt upgrade -y &&     apt install -y git wget bzip2 &&     apt autoremove -y && apt autoclean -y
```

- 必要最低限の開発用ツール（git, wget, bzip2）をインストール。
- システムを最新状態に更新後、不要なキャッシュを削除。

---

## Miniforgeのインストール

```
RUN wget ... && bash Miniforge3... && conda init ...
```

- Miniforge（軽量なCondaディストリビューション）を指定バージョンでインストール。
- 初期化とキャッシュ削除を含め、効率的な環境構築。

---

## Python/依存パッケージのインストール

```
COPY docker/requirements.txt /root/requirements.txt
RUN chmod +x /root/requirements.txt
RUN /bin/bash -c "source ... && conda create ... && pip install ..."
```

- Django用のPython 3.12.10仮想環境を作成し、`requirements.txt`に基づく依存関係をインストール。

---

## 起動時にConda環境を有効化

```
RUN sed -i '$a conda activate django' /root/.bashrc
```

- bashシェル起動時に自動で `django` 環境が有効化されるよう設定。

---

## 不要ファイルの削除

```
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*
```

- 追加で不要なキャッシュ等を削除し、イメージサイズを削減。

---

## ポートの公開と作業ディレクトリの指定

```
EXPOSE 8000
WORKDIR /home/dev/github/shindjango
```

- Django開発サーバ用のポート8000を開放。
- 作業ディレクトリを指定し、CMD等の実行場所を定義。

---

## スクリプトの配置と実行権限付与

```
COPY docker/scripts/postprocessing.sh /var/custom/postprocessing.sh
COPY docker/scripts/entrypoint.sh /usr/local/bin/
RUN chmod +x ...
```

- コンテナ起動後の初期処理スクリプトを設置し、実行権限を付与。

---

## エントリーポイントとデフォルトコマンド

```
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["0.0.0.0:8000"]
```

- カスタムエントリーポイントスクリプトを指定。
- Django開発サーバを `0.0.0.0:8000` で起動。

---

## 補足

このDockerfileは、PythonとNginxを組み合わせたWebアプリ環境（特にDjango）構築のためのテンプレートです。Miniforgeを用いることで軽量かつ柔軟なPython環境を提供し、依存関係の管理もCondaで一元化されています。