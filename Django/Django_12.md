[TOC]

# Django_12

## 00. Restframework 준비

> [Home - Django REST framework](https://www.django-rest-framework.org/#)

- `05_django_rest` 폴더 생성 및 가상환경 설정

    ```bash
    $ pip install django
    ```
    
    ```bash
    $ django-admin startproject api .
    ```
    
    ```bash
    $ pip install djangorestframework
    ```
    
    ```python
    # settings.py
    
    INSTALLED_APPS = [
    'rest_framework',
        ...,
    ]
    ```
    
    ```bash
    $ python manage.py startapp musics
    ```
    
    ```python
    # settings.py
    
    INSTALLED_APPS = [
        'musics.apps.MusicsConfig',
        ...,
    ]
    ```


​    

---



## 01. Model

- Artist / Music / Comment 3개의 모델을 만든다.

    ```python
    # musics/models.py
    
    class Artist(models.Model):
        name = models.TextField()
    
        def __str__(self):
            return self.name
    
    
    class Music(models.Model):
        artist = models.ForeignKey(Artist, on_delete=models.CASCADE)
        title = models.TextField()
    
        def __str__(self):
            return self.title
    
    
    class Comment(models.Model):
        music = models.ForeignKey(Music, on_delete=models.CASCADE)
        content = models.TextField()
    
        def __str__(self):
        return self.content
    ```
    
    ```bash
    $ python manage.py makemigrations
    $ python manage.py migrate
    ```
    
    ```bash
    $ python manage.py createsuperuser
    ```
    
    ```python
    # movies/admin.py
    
    from .models import Artist, Music, Comment
    
    admin.site.register(Artist)
    admin.site.register(Music)
    admin.site.register(Comment)
    ```
    
    - admin 계정을 미리 만들고 **실습을 위한 데이터들을 미리 넣어 놓는다.** ( ex. 가수 2명 / 가수당 노래 2개 / 노래당 댓글 2개)
    - 데이터를 직접 넣긴했지만 분명 편한 작업이 아니다.
    
    

`dumpdata`

> [django-admin and manage.py | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/django-admin/#dumpdata)
>
> [Serializing Django objects | Django documentation | Django](https://docs.djangoproject.com/en/2.2/topics/serialization/#serialization-formats)

- 응용 프로그램과 관련된 데이터베이스의 모든 데이터를 표준 출력으로 출력한다.
- `$ python manage.py dumpdata [app_label[.ModelName] [app_label[.ModelName] ...]]` 형태로 사용한다.
- `dumpdata`의 출력 결과물은 `loaddata` 의 입력으로 사용될 수 있다.

    ```bash
    # 수기로 입력한 데이터를 json 형태의 출력 결과물로 만들어보자.
    # --indent 옵션을 주지 않으면 한 줄로 작성된다.
    
    $ python manage.py dumpdata --indent 2 musics > dummy.json
    ```
    
    - db 와 manage.py 가 위치한 동일선상에 `dummy.json` 파일이 생성된다.


​    

`loaddata`

> [django-admin and manage.py | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/django-admin/#loaddata)

- fixture 의 내용을 검색하여 데이터베이스로 로드한다.
- `fixture`
    - fixture 는 데이터베이스의 직렬화(serialized) 된 내용을 포함하는 파일 모음이다.
    - 각 fixture 는 고유 한 이름을 가지며, fixture 를 구성하는 파일은 여러 응용 프로그램에서 여러 디렉토리에 배포 될 수 있다.
- django 는 설치된 모든 app 의 디렉토리에서 `fixtures` 폴더를 찾는다.



- loaddata 도 확인해보기 위해 다음과 같이 파일구조를 생성한다.

        musics/
          fixtures/
            musics/
              dummy.json

- 기존 데이터를 초기화 후 load 하기 위해 `db.sqlite3` 파일을 지운 후 migrate 작업을 진행한다.

    ```bash
$ python manage.py migrate
    $ python manage.py loaddata musics/dummy.json
    ```
    
    - admin 에서 데이터를 확인해보면 동일하게 입력되어 있다는 것을 확인할 수 있다.



---



## 02. Music List

- 아래와 같이 URL 을 설정하는 이유는 모든 모델들에 대한 정보를 표현할 것이기 때문에, `musics/` 로 시작하지 않는다.

- 일반적인 API들은 URL을 이렇게 버전을 명시해서 작성한다.

    ```python
    # musics/views.py
    
    from .models import Music
    
    def music_list(request):
        musics = Music.objects.all()
    
        
        
    # api/urls.py
    
    from django.urls import path, include
    
    urlpatterns = [
        path('api/v1/', include('musics.urls')), 
    		...,
    ]
    
    
    
    # musics/urls.py
    
    from django.urls import path
    from . import views
    
    
    urlpatterns = [
        path('musics/', views.music_list),
    ]
    ```

    - 여기까지는 평소에 만들던 방식과 동일하다.
    - 그런데, 요청 들어오는 것과 반환하는 방식이 다르다.

        >  [Views - Django REST framework](https://www.django-rest-framework.org/api-guide/views/#function-based-views)

    - 먼저 요청 들어온 것은 다음과 같이 어떠한 HTTP method 대해서 처리할 것인지 정의한다.

        ```python
        # musics/views.py
        
        from rest_framework.decorators import api_view
        
        
        @api_view(['GET'])
        def music_list(request):
            musics = Music.objects.all()
        ```



- 다음으로, REST Framework에서는 리턴 값이 다르다. 기존에는 `render` 함수를 통해 HTML(템플릿)을 반환하지만 API에서는 `Response`를 통해 `Serializer` 를 반환한다.

- 사용자에게 보기 편한 응답이 아니라 데이터만 주는 것으로, json 형식을 활용해서 반환한다.

- 특정한 dictionary 혹은 queryset 등의 파이썬 형식의 데이터 타입을 반환하도록 해주는 것이 Serializer 이다.

- `serializers.py`
    - 구조는 `ModelForm` 과 굉장히 유사하다.

        ```python
        # musics/serializers.py
        
        from rest_framework import serializers
        from .models import Music
        
        
        class MusicSerializer(serializers.ModelSerializer):
            class Meta:
            model = Music
                fields = ('id', 'title', 'artist_id')
        ```
    
        ```python
        # musics/views.py
        
        from rest_framework.response import Response
        from .serializers import MusicSerializer
        
        @api_view(['GET'])
        def music_list(request):
            musics = Music.objects.all()
            serializer = MusicSerializer(musics, many=True)
            return Response(serializer.data)
        ```
        - MusicSerializer 에 내가 보내 줄 `musics` 를 인자로 넣고, `many=True` 를 설정하자.
    - 이를 설정하는 이유는 동일한 유형의 **데이터(Music 인스턴스)의 집합**이므로 설정하는 것이다.
        - `musics` 는 queryset, 즉 일종의 리스트인데 우리가 응답하려고 하는 것은 `json`이다. 따라서 `Serializer`가 해주는 것은 리스트를 하나 하나씩 `json` 타입으로 바꿔주는 고마운 도구이다.
        - 응답하는 함수도 다른데 `REST Framework`에서 사용하는 `Response` 를 사용한다.
        - 마지막으로 결과로 보내줄 데이터는 `.data` 로 가져온다.
        
        
    
- `/api/v1/musics/` 로 요청을 보내보자.



---



## 03. Music Detail

```python
# musics/views.py

from django.shortcuts import render, **get_object_or_404**

@api_view(['GET'])
def music_detail(request, music_pk):
    music = get_object_or_404(Music, pk=music_pk)
    serializer = MusicSerializer(music)
    return Response(serializer.data)

  
  
# musics/urls.py

urlpatterns = [
    ...,
    path('musics/<int:music_pk>/', views.music_detail),
]
```

- music 은 결과가 하나의 인스턴스다. 그래서 `many=True` 는 작성하지 않는다.

- `/api/v1/musics/1/` 로 요청을 보내 detail 을 확인해보자.

- `many=True` 차이를 보면 아래와 같다. list 와 detail 의 결과를 각각 보면 각각`[]` 와 `{}` 로 감싸져 있는 것을 볼 수 있다.

    ```json
    // /api/v1/musics/
    
    [
        {
            "id": 1,
            "title": "Girls Like You",
            "artist_id": 2
        },
        {
            "id": 2,
            "title": "Sunday Morning",
            "artist_id": 2
        },
        {
            "id": 3,
            "title": "viva la vida",
            "artist_id": 1
        },
        {
            "id": 4,
            "title": "paradise",
            "artist_id": 1
        }
]
    ```
    
    ```json
    // /api/v1/musics/1/
    
    {
        "id": 1,
        "title": "Girls Like You",
        "artist_id": 2
    }
    ```
    
    

---



## 04. API Document

> [axnsan12/drf-yasg](https://github.com/axnsan12/drf-yasg)

- 보통 API는 사용자를 위해 사용법에 대한 가이드 문서를 제공한다.



**설치 및 등록**

- 이 문서화를 해주는 라이브러리가 있다. Swagger/OpenAPI 2.0 를 모두 지원하는 `drf-yasg` (Yet another Swagger generator) 를 사용 해보자.

    ```bash
$ pip install drf-yasg
    ```
    
    ```python
    # settings.py
    
    INSTALLED_APPS = [
       ...
       'drf_yasg',
       ...
    ]
    ```



**url 설정**

- 공식문서를 보면서 차근차근 작성해보자.

    ```python
    # musics/urls.py
    
    from drf_yasg.views import get_schema_view
    from drf_yasg import openapi
    
    schema_view = get_schema_view(
       openapi.Info(
            title='Music API',
            default_version='v1',
            # 아래 주석은 선택 인자입니다.
            # description="음악관련 API 서비스입니다.",
            # terms_of_service="https://www.google.com/policies/terms/",
            # contact=openapi.Contact(email="edujunho.hphk@gmail.com"),
            # license=openapi.License(name="SSAFY License"),
       ),
    )
    
    urlpatterns = [
        ...,
        path('redocs/', schema_view.with_ui('redoc'), name='api_docs'),
        path('swagger/', schema_view.with_ui('swagger'), name='api_swagger'),
    ]
    ```

    - 2가지 종류로 document 를 지원한다.
        1. `/docs/` : ReDoc 스타일
        2. `/swagger/` : Swagger 스타일
    - `Info()` 함수의 title 과 default_version 는 필수 인자이다.
    - 두 주소 모두 접속해서 확인해보자.

        <img width="1680" alt="Screen_Shot_2019-10-17_at_2 18 40_PM" src="https://user-images.githubusercontent.com/18046097/67998167-beeee080-fc9a-11e9-920f-ed2dd4ca236d.png">

        <img width="1680" alt="Screen_Shot_2019-10-17_at_2 18 51_PM" src="https://user-images.githubusercontent.com/18046097/67997953-dbd6e400-fc99-11e9-9d4c-60a1de033410.png">

    

---



## 05. Artist List

- 가수 목록 데이터 응답을 작성해보자.

    ```python
    # musics/serializers.py
    
    from .models import Music, Artist
    
    
    class ArtistSerializer(serializers.ModelSerializer):
        class Meta:
            model = Artist
        fields = ('id', 'name',)
    ```
    
    ```python
    # musics/views.py
    
    from .serializers import MusicSerializer, ArtistSerializer
    from .models import Music, Artist
    
    
    @api_view(['GET'])
    def artist_list(request):
    artists = Artist.objects.all()
        serializer = ArtistSerializer(artists, many=True)
        return Response(serializer.data)
    ```
    
    ```python
    # musics/urls.py
    
    urlpatterns = [
        path('musics/', views.music_list),
        path('musics/<int:music_pk>/', views.music_detail),
        path('artists/', views.artist_list),
        path('docs/', schema_view.with_ui('redoc'), name='api_docs'),
        path('swagger/', schema_view.with_ui('swagger'), name='api_swagger'),
    ]
    ```
    
    

---



## 06. Artist Detail

- 가수의 세부정보 응답을 만들어보자.

    ```python
    # musics/views.py
    
    @api_view(['GET'])
    def artist_detail(request, artist_pk):
        artist = get_object_or_404(Artist, pk=artist_pk)
        serializer = ArtistSerializer(artist)
        return Response(serializer.data)
    ```

    ```python
    # musics/urls.py
    
    urlpatterns = [
        ...,
        path('artists/<int:artist_pk>/', views.artist_detail),
        ...,
    ]
    ```



- 확인해보면 artist 가 가지고 있는 music 들이 출력되지 않는다.

- music 에는 artist 정보가 있지만, artist 에는 music 정보가 없기 때문이다. (N 에서만 1 의 정보를 가지고 있기 때문)

- 1:N 관계에서 실제 데이터베이스에는 N인 music 에만 artist 의 외래 키 값이 저장되어 있을 뿐이기 때문이다.

- DetailSerializer 를 작정해보자. Serializer는 데이터의 형식을 지정해주는 것과 동일한데, 기존의 Artist 오브젝트에 추가적인 내용이 필요하기 때문이다.

    ```python
    # musics/serializers.py
    
    class ArtistDetailSerializer(ArtistSerializer):
        music_set = MusicSerializer(many=True)
    
        class Meta(ArtistSerializer.Meta):
            fields = ArtistSerializer.Meta.fields + ('music_set',)
    ```

    - 또는 다음과 같이 작성해도 된다.

        ```python
        # musics/serializers.py
        
        class ArtistDetailSerializer(serializers.ModelSerializer):
            music_set = MusicSerializer(many=True)
        
            class Meta:
                model = Artist
                fields = ('id', 'name', 'music_set',)
        ```



```python
# musics/views.py

from .serializers import MusicSerializer, ArtistSerializer, ArtistDetailSerializer

@api_view(['GET'])
def artist_detail(request, artist_pk):
    artist = get_object_or_404(Artist, pk=artist_pk)
    serializer = ArtistDetailSerializer(artist)
    return Response(serializer.data)
```

- 다시 `/api/v1/artists/1/` 로 요청을 보내보면, 해당 artist 의 music 들도 같이 응답으로 주는 것을 확인할 수 있다.

  ```json
  {
      "id": 1,
      "name": "Coldplay",
      "music_set": [
          {
              "id": 3,
              "title": "viva la vida",
              "artist_id": 1
          },
          {
              "id": 4,
              "title": "paradise",
              "artist_id": 1
          }
      ]
  }
  ```

  

- `music_set` 이 아닌 다른 이름으로 사용하고 싶다면, (1 또는 2 선택)
  
  1. models.py 에서 related_name 설정 (작성 후 마이그레이션 작업이 필요하다.)
  
     ```python
     # musics/models.py
     
     class Music(models.Model):
         artist = models.ForeignKey(Artist, on_delete=models.CASCADE, related_name='musics')
         ...
     ```
  
  2. serializers.py 에서 직접 설정 (진행)
  
     ```python
     # musics/serializers.py
     
     class ArtistDetailSerializer(ArtistSerializer):
     musics = MusicSerializer(source='music_set', many=True)
     
         class Meta(ArtistSerializer.Meta):
          fields = ArtistSerializer.Meta.fields + ('musics',)
     ```
  
     

 - 오류가 뜬다면 서버를 재시작하자.



---



## 07. Create Comment

- 요청에 따라 데이터를 보여주는 것 뿐만이 아닌 **데이터를 새로 생성** 해보자.

- 생성은 `POST` 요청이어야 한다.

    ```python
    # musics/serializers.py
    
    from .models import Music, Artist, Comment
    
    
    class CommentSerializer(serializers.ModelSerializer):
        class Meta:
            model = Comment
            fields = ('id', 'content', 'music_id',)
    ```

    ```python
    # musics/views.py
    
    from .serializers import MusicSerializer, ArtistSerializer, ArtistDetailSerializer, CommentSerializer
    
    
    @api_view(['POST'])
    def comments_create(request, music_pk):
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save(music_id=music_pk)
        return Response(serializer.data)
        # return Response({"message": "댓글이 정상적으로 작성되었습니다.")
    ```

    - `raise_exception=True` 는 검증에 실패하면 400 Bad Request 오류를 발생시킨다.

        ```python
        # 아래 코드를 짧게 설정한 것이다.
        
        if not serializer.is_valid():
        raise ValidationError(serializer.errors)
        ```

    ```python
    # musics/urls.py
    
    urlpatterns = [
        ...,
        path('musics/<int:music_pk>/comments/', views.comments_create),
        ...,
    ]
    ```

    

- 먼저 현재 comment 확인하기 위해 Music Detail 에서 Comment 를 확인하도록 하자.

    ```python
    # musics/serializers.py
    
    class MusicDetailSerializer(MusicSerializer):
        comments = CommentSerializer(source='comment_set', many=True)
        class Meta(MusicSerializer.Meta):
        fields = MusicSerializer.Meta.fields + ('comments',)
    ```
    
    ```python
    # musics/views.py
    
    from .serializers import MusicSerializer, ArtistSerializer, ArtistDetailSerializer, CommentSerializer, MusicDetailSerializer
    
    
    @api_view(['GET'])
    def music_detail(request, music_pk):
        music = get_object_or_404(Music, pk=music_pk)
        serializer = MusicDetailSerializer(music)
        return Response(serializer.data)
    ```
    
    

`Postman`

- Postman 을 사용해서 요청을 보내보자.
- **POST 요청은 url 마지막에 반드시 `/` 가 있어야한다.**
- POST 로 전달할 데이터는 `body` 에 작성해서 보내야 한다.
    
    > - postman 에서 path variable 설정
>
    > ![111](https://user-images.githubusercontent.com/18046097/67998879-5ead6e00-fc9d-11e9-8512-eec132a749af.png)



<img width="965" alt="Screen_Shot_2019-10-17_at_3-906563e7-a63f-4098-921e-ef59e131a1a1 19 02_PM" src="https://user-images.githubusercontent.com/18046097/67997597-1e97bc80-fc98-11e9-94bb-369b2eb4560f.png">

<img width="517" alt="Screen_Shot_2019-10-17_at_3-85619bc4-dd49-47bb-80e5-246c9772dc2a 19 36_PM" src="https://user-images.githubusercontent.com/18046097/67997596-1e97bc80-fc98-11e9-8f37-fb932f09432e.png">



---



## 08. Update and Delete Comment

- 같은 주소로 다른(PUT, DELETE) http method 로 요청을 보내서 수정 삭제를 같은 주소로 구현 해보자.

- 수정은 `PUT`, 삭제는 `DELETE` method를 사용한다.

    ```python
    # musics/views.py
    
    from .models import Music, Artist, Comment
    
    
    @api_view(['PUT', 'DELETE'])
    def comments_update_and_delete(request, comment_pk):
        comment = get_object_or_404(Comment, pk=comment_pk)
        if request.method == 'PUT':
            serializer = CommentSerializer(data=request.data, instance=comment)
            if serializer.is_valid(raise_exception=True):
                serializer.save()
                return Response({'message': 'Comment has been updated!!'})
        else:
            comment.delete()
            return Response({'message': 'Comment has been deleted!!'})
    ```

    ```python
    # musics/urls.py
    
    urlpatterns = [
        ...,
        path('comments/<int:comment_pk>/', views.comments_update_and_delete, name='comments_update_and_delete'),
        ...,
    ]
    ```

    - PUT, DELETE 도 마찬가지로 Postman 에서 테스트를 해보자.
    - 수정 및 삭제 요청을 보내보고 admin 페이지에서 잘 삭제 되었는지 확인해본다.

    

- 수정

    <img width="963" alt="Screen_Shot_2019-10-17_at_3-95c633e5-853f-45dd-af79-72bbadd6be78 31 35_PM" src="https://user-images.githubusercontent.com/18046097/67997594-1e97bc80-fc98-11e9-8147-8daf11b4c1d4.png">

    <img width="490" alt="Screen_Shot_2019-10-17_at_3-95c2a4de-7bf9-4d4b-a174-a97279e0602a 31 45_PM" src="https://user-images.githubusercontent.com/18046097/67997592-1dff2600-fc98-11e9-97a6-2b7f2cf27396.png">

- 삭제

    <img width="965" alt="Screen_Shot_2019-10-17_at_3-46029253-d7e4-480a-91f0-b66494a75b50 32 40_PM" src="https://user-images.githubusercontent.com/18046097/67997598-1f305300-fc98-11e9-847d-02ca1823c66b.png">

    <img width="504" alt="Screen_Shot_2019-10-17_at_3-7a68b5da-ba15-4be7-a210-8e456239c0d9 32 49_PM" src="https://user-images.githubusercontent.com/18046097/67997590-1dff2600-fc98-11e9-91a5-1a7574c57bd2.png">

- 다른 method 요청

    <img width="962" alt="Screen_Shot_2019-10-17_at_3 33 42_PM" src="https://user-images.githubusercontent.com/18046097/67999068-1f335180-fc9e-11e9-9e95-867921a43127.png">
    
    

---



## 09. 추가 데이터 제공하기

- artist 가 가지고 있는 모든 music 개수 데이터 제공하기

    ```python
    # musics/serializers.py
    
    class ArtistDetailSerializer(ArtistSerializer):
        musics = MusicSerializer(source='music_set', many=True)
        musics_count = serializers.IntegerField(source='music_set.count')
    
        class Meta(ArtistSerializer.Meta):
        fields = ArtistSerializer.Meta.fields + ('musics', '**musics_count**',)
    ```
    
    <img width="510" alt="Screen_Shot_2019-10-17_at_3 36 47_PM" src="https://user-images.githubusercontent.com/18046097/67999128-5275e080-fc9e-11e9-83bc-ef49be22bfc8.png">

---



## 심화

- Query Params 로 넘겨 받은 값으로 filtering 하기

  ```python
  def set_if_not_none(mapping, key, value):
      if value is not None:
          mapping[key] = value
  
  def music_list(request):
  		params = {}
      artist_pk = request.GET.get('artist_pk')
      set_if_not_none(params, 'artist_id', artist_pk)
  
  		musics = Music.objects.filter(**params)
  		serializer = MusicSerializer(musics, many=True)
      return Response(serializer.data)
  ```

  