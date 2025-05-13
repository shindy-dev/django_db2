#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""

import os
import sys

# manage.py は、Django プロジェクトの管理コマンドを実行するためのユーティリティです。
# manage.py makemigrations は、モデルの変更を検出してマイグレーションファイルを作成します。マイグレーションファイルは、データベースのスキーマを変更するための手順を記述したものです。
# manage.py migrate は、マイグレーションファイルを適用してデータベースのスキーマを更新します。
# manage.py runserver は、開発用のウェブサーバーを起動します。これにより、ローカルでアプリケーションをテストできます。
# manage.py createsuperuser は、Django の管理画面にアクセスするためのスーパーユーザーを作成します。
# manage.py collectstatic は、静的ファイルを収集して、指定されたディレクトリに配置します。これにより、静的ファイルを本番環境で提供できるようになります。

def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'shindjango.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
