"""
ASGI config for django_db2 project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

# asgi.py は、Django プロジェクトの ASGI (Asynchronous Server Gateway Interface) 設定を定義するファイルです。
# ASGI は、Django アプリケーションとウェブサーバー間の非同期通信を可能にするインターフェースです。
# このファイルは、ASGI サーバーが Django アプリケーションを起動するために必要な設定を提供します。

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "django_db2.settings")

application = get_asgi_application()
