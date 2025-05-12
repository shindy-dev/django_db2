#!/bin/bash
set -e  # エラーがあれば即終了

# マーカーパス
MARKER_FILE="/var/.entrypoint_initialized"

# 初回起動チェック
if [ ! -f "$MARKER_FILE" ]; then
    # 初回起動時処理

    # git pull
    (cd /home/dev/github/shindjango && git pull -q)

    # マーカーを作成
    touch "$MARKER_FILE"
fi

# icr.io/db2_community/db2のEntrypoint
# docker pull icr.io/db2_community/db2 && docker inspect icr.io/db2_community/db2 で確認
/var/db2_setup/lib/setup_db2_instance.sh


# 最後に bash を起動するなど
exec /bin/bash