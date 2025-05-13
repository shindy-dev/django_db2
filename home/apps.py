from django.apps import AppConfig

# home/apps.py は、Django アプリケーションの設定を定義するファイルです。
# このファイルでは、アプリケーションの名前やデフォルトの自動フィールドなどを設定します。

class HomeConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'home'
