FROM ubuntu/nginx:1.24-24.04_edge

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH="$CONDA_DIR/bin:$PATH"

# 必要パッケージのインストール
RUN apt update && apt upgrade -y && \
    apt install -y git wget bzip2 && \
    apt autoremove -y && apt autoclean -y

# Miniforge のインストール（バージョン固定）
RUN wget --no-check-certificate https://github.com/conda-forge/miniforge/releases/download/23.11.0-0/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p $CONDA_DIR && rm Miniforge3-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda init && $CONDA_DIR/bin/conda clean --all --yes

# Conda環境作成と依存インストール（まとめて実行）
COPY docker/requirements.txt /root/requirements.txt
RUN chmod +x /root/requirements.txt
RUN /bin/bash -c "source $CONDA_DIR/etc/profile.d/conda.sh && conda create -n django python=3.12.10 -y && conda activate django && \
    pip install --no-cache-dir -r /root/requirements.txt && \
    conda clean --all --yes"

# Conda環境を有効にするためのコマンドを追記
RUN sed -i '$a conda activate django' /root/.bashrc

# キャッシュ等削除
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*

# ポート公開（Web/Django）
EXPOSE 8000

WORKDIR /home/dev/github/django_db2

# サーバ初期化後に処理したいスクリプトをコピー
COPY docker/scripts/postprocessing.sh /var/custom/postprocessing.sh
RUN chmod +x /var/custom/postprocessing.sh

# エントリーポイントの設定
COPY docker/scripts/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["0.0.0.0:8000"]