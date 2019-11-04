from django.urls import path
from . import views

app_name = 'utilities'
urlpatterns = [
    path('', views.index, name='index'),
]