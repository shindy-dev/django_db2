
from django.urls import path
from . import views

# urls.py は、Django アプリケーションの URL ルーティングを定義するファイルです。

urlpatterns = [
    path("", views.index, name="index"),
]