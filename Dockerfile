FROM icr.io/db2_community/db2:12.1.1.0

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH="$CONDA_DIR/bin:$PATH"

# 必要パッケージのインストール
RUN dnf install -y git wget bzip2 && \
    dnf clean all

# Miniforge のインストール（バージョン固定）
RUN wget --no-check-certificate https://github.com/conda-forge/miniforge/releases/download/23.11.0-0/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm Miniforge3-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda init && \
    $CONDA_DIR/bin/conda clean --all --yes

# Conda環境作成と依存インストール（まとめて実行）
COPY docker/requirements.txt /root/requirements.txt
RUN chmod +x /root/requirements.txt
RUN /bin/bash -c "source $CONDA_DIR/etc/profile.d/conda.sh && \
    conda create -n django python=3.12.10 -y && \
    conda activate django && \
    pip install --no-cache-dir -r /root/requirements.txt && \
    conda clean --all --yes"

# Conda環境を有効にするためのコマンドを追記
RUN sed -i '$a conda activate django' /root/.bashrc

# コンテナ再起動時に既存のdb2インスタンス作成が権限エラーで失敗するのを防ぐため、権限付与コマンドを追記
# https://community.ibm.com/community/user/discussion/121-container-community-edition-docker-start-fails-dbi20187e
RUN sed -i '1a chown root:db2iadm1 /database/config/${DB2INSTANCE?}/sqllib/adm/fencedid' /var/db2_setup/lib/setup_db2_instance.sh

# キャッシュ等削除
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*

# ポートを公開（Web/Django、DB2）
EXPOSE 8000 50000

WORKDIR /home/dev/github/shindjango

COPY docker/scripts/entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
