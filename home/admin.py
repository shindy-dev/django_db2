from django.contrib import admin
from .models import Question, Choice

# admin.py は、Django アプリケーションの管理インターフェースを定義するファイルです。
# # Django の管理インターフェースは、アプリケーションのデータを管理するための Web ベースのインターフェースです。
# # このファイルでは、管理インターフェースに表示するモデルやフィールドを設定します。


class ChoiceInline(admin.TabularInline):
    '''
    ChoiceInline は、Choice モデルのインライン編集を定義するクラスです。
    Choice モデルは、Question モデルに関連付けられた選択肢を表します。
    TabularInline は、インライン編集を表形式で表示するためのクラスです。
    '''
    # model は、インライン編集するモデルを指定します。
    model = Choice
    # extra は、インライン編集で表示する空のフォームの数を指定します。
    extra = 3


class QuestionAdmin(admin.ModelAdmin):
    '''
    QuestionAdmin は、Question モデルの管理インターフェースを定義するクラスです。
    '''

    # fields は、管理インターフェースに表示するフィールドを指定します。
    # fields = ["pub_date", "question_text"]

    # fieldsets は、管理インターフェースのレイアウトを定義します。
    fieldsets = [
        (None, {"fields": ["question_text"]}),
        ("Date information", {"fields": ["pub_date"]}),
    ]

    # inlines は、Question モデルに関連付けられた Choice モデルのインライン編集を指定します。
    inlines = [ChoiceInline]

    list_display = ("question_text", "pub_date", "was_published_recently")

    list_filter = ["pub_date"]

    search_fields = ["question_text"]


# Question モデルを管理インターフェースに登録します。
admin.site.register(Question, QuestionAdmin)