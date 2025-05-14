
from django.urls import path
from . import views

# urls.py は、Django アプリケーションの URL ルーティングを定義するファイルです。

# app_name は、URL 名前空間を定義するための変数です。
app_name = "home"

urlpatterns = [    
    path("", views.IndexView.as_view(), name="index"),
    path("<int:pk>/", views.DetailView.as_view(), name="detail"),
    path("<int:pk>/results/", views.ResultsView.as_view(), name="results"),
    path("<int:question_id>/vote/", views.vote, name="vote"),
]