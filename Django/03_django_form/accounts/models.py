from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models


# Create your models here.
class User(AbstractUser):
    # django 는 맞춤 모델을 참조하는 AUTH_USER_MODEL 설정 값을 제공함으로써
    # 기본 User 모델을 오버라이드하도록 할 수 있다.
    followers = models.ManyToManyField(
        settings.AUTH_USER_MODEL, related_name='followings'
    )
