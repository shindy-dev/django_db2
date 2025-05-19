"""
WSGI config for django_db2 project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

# wsgi.py は、Django プロジェクトの WSGI (Web Server Gateway Interface) 設定を定義するファイルです。
# WSGI は、Django アプリケーションとウェブサーバー間の通信を可能にするインターフェースです。

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "django_db2.settings")

application = get_wsgi_application()
