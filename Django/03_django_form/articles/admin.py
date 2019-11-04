from django.contrib import admin

from .models import Article, Comment, Hashtag


# Register your models here.
class ArticleAdmin(admin.ModelAdmin):
    list_display = ('pk', 'title', 'content', 'created_at', 'updated_at')


admin.site.register(Article, ArticleAdmin)


class CommentAdmin(admin.ModelAdmin):
    list_display = ('pk', 'content', 'created_at', 'updated_at', 'article_id')


admin.site.register(Comment, CommentAdmin)


class HashtagAdmin(admin.ModelAdmin):
    list_display = ('content',)


admin.site.register(Hashtag, HashtagAdmin)


# @admin.register(Comment)
# class CommentAdmin(admin.ModelAdmin):
#     list_display = ('pk', 'content', 'created_at', 'updated_at', 'article_id',)
