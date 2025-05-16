#!/bin/bash
set -e  # エラーがあれば即終了

# マーカーパス
MARKER_FILE="/var/.entrypoint_initialized"

# 初回起動チェック
if [ ! -f "$MARKER_FILE" ]; then
    # 初回起動時処理

    # git pull モード指定
    git config --global pull.rebase true
    # git pull
    (cd /home/dev/github/shindjango && git clone -q https://github.com/shindy-dev/shindjango.git .)

    # マーカーを作成
    touch "$MARKER_FILE"
fi

# /var/custom 内のすべての .sh ファイルを実行
if [ -d /var/custom ]; then
  for script in /var/custom/*.sh; do
    if [ -f "$script" ]; then
      chmod +x "$script"
      "$script"
    fi
  done
fi

source /opt/conda/etc/profile.d/conda.sh
conda activate django
# Djangoのマイグレーション
cd /home/dev/github/shindjango
# マイグレーションの作成
python manage.py makemigrations
# マイグレーションの適用
python manage.py migrate
exec python manage.py runserver "$@"
