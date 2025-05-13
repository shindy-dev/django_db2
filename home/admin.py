from django.contrib import admin
from .models import Question

# admin.py は、Django アプリケーションの管理インターフェースを定義するファイルです。
# # Django の管理インターフェースは、アプリケーションのデータを管理するための Web ベースのインターフェースです。
# # このファイルでは、管理インターフェースに表示するモデルやフィールドを設定します。

admin.site.register(Question)