from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.

# views.py は、Django アプリケーションのビューを定義するファイルです。
# ビューは、HTTP リクエストを受け取り、HTTP レスポンスを返す関数またはクラスです。

def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")