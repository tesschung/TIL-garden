####  Django Framework

1104 과목평가 준비를 위해서 간단하게 요약한 README입니다.



- settings.py
- 명령어
- 지금까지 작성한 장고코드 전부 보기
- 코드 빈칸 채우기 몇 개, settings.py부터 세세하게 보기
- 나머지는 객관식
- 문제 "잘~" 읽어보기
- REST API안나옴



> 가상환경 사용이유

- 다른 라이브러리를 포함해서 사용하면 다른 라이브러리에 대한 의존성이 생긴다.
- 이러한 의존성 때문에 환경이 달라지면 프로그램이 잘 안돌아갈 수 있다.
- 때문에 특정한 프로그램을 위한 특정한 환경을 따로 만들어서,
- 그 환경에서 프로그램을 관리하는 방식을 선택해야한다.

```bash
# 1. 가상 환경 생성
$ python -m venv venv

# 2. 가상 환경 활성화
$ source venv/Scripts/activate

# 3. 가상환경 비활성화(어느 곳이든 관계 없음)
$ deactivate
```



.gitignore 생성 및 설정

```bash
vi .gitignore
```





> Django 기본 설정

```bash
$ pip install django

# 특정 버전 설치시
$ pip install Django==2.2.4

# 설치된 django 버전 확인
$ python -m django --version
```



> 프로젝트 생성

- `django-admin` `startproject` <프로젝트명> `.`

```bash
django-admin startproject django_intro .
```



> 서버 실행

- `python` `manage.py` `runserver`



> settings.py

웹사이트의 모든 설정을 포함

생성한 application을 등록, static files의 위치, database 세부 설정

Django project 내의 모든 환경 저장



> Application 생성

app 이름은 되도록 **복수형**으로 만든다.

```bash
$ python manage.py startapp pages
```



프로젝트는 application들의 집합이고, 실제 역할(기능)을 수행하는건 각각의 application들이 담당한다.



> settings.py : application 등록
```python
INSTALLED_APPS = [
  'local apps',
  'third party apps', 
  'Django apps'
]
LANGUAGE_CODE = 'ko-kr'
TIME_ZONE = 'Asia/Seoul'
```



> MTV

Model, Template(View), View(Controller) 라고 부르는데 실제로는 MVC 패턴이다.

- Model
- Template(View) : Interface (html) - 사용자에게 어떻게 데이터가 보여질 지 정의
- View(Controller) : Logic - 어떤 데이터를 보여줄 지 정의





> CSRF_token

- `{% csrf_token %}`을 설정하면 input type hidden 으로 특정한 hash 값이 담겨있는 것을 볼 수 있다.

> 403 forbidden 에러

`403 forbidden`에러: **서버에 요청은 도달했으나 서버가 접근을 거부**할 때 **반환하는 HTTP 응답 코드 / 오류 코드**. 이 에러 메시지는 **서버 자체 또는 서버에 있는 파일에 `접근할 권한`이 없을 경우**에 발생.

이러한 접근을 할 수 있도록 하는 것이 `{% csrf_token %}`→ 사내 인트라넷 서버를 사내가 아닌 밖에서 접속하려고 할 때도 해당 HTTP 응답 코드가 뜬다.





> 정적파일(static)

 웹 사이트의 구성 요소 중에서 image, css, js 파일과 같이 해당 내용이 고정되어 **응답을 할 때 별도의 처리 없이 파일 내용을 그대로 보여주면 되는 파일**



html에 

- `{% load static %}` 태그를 통해 이미지에 대한 주소를 생성한다.
- 기본적으로 Django는 `static` 태그를 통해 정적 파일을 로드할 때는 각 app의 `static` 폴더를 찾는다!

```html
{% load static %}

<!DOCTYPE html>
<html lang="en">
<head>
		...
    <link rel="stylesheet" href="{% static 'stylesheets/style.css' %}" type="text/css" />
</head>
<body>
    <h1>STATIC 파일 실습</h1>
    <img src="{% static 'images/simpson.jpg' %}" alt='simpson'>
</body>
</html>
```





> 프로젝트 폴더 urls.py를 수정하여 각 application에 해당하는 urls.py로 변경

```python
# django_intro/urls.py

from django.urls import path, include

urlpatterns = [
    path('utilities/', include('utilities.urls'),
    path('pages/', include('pages.urls')), 
    path('admin/', admin.site.urls),
]
```





> settings.py : base.html 등록





```html
<!-- django_intro/templates/base.html -->

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.0/css/bootstrap.min.css"
    integrity="sha384-PDle/QlgIONtM1aqA2Qemk5gPOE7wFq8+Em+G/hmo5Iq0CCmYZLv3fVRDJ4MMwEA" crossorigin="anonymous">
</head>

<body>
  <h1 class="text-center">Template Inheritnace</h1>
  <hr>
  <div class="container">
    {% block content %}
    {% endblock %}
  </div>
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
  </script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
    integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous">
  </script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.0/js/bootstrap.min.js"
    integrity="sha384-7aThvCh9TypR7fIc2HV4O/nFMVCBwyIUKL8XCtKE+8xgCgl/PQGuFsvShjr74PBp" crossorigin="anonymous">
  </script>
</body>

</html>
```

```python
# practice/settings.py

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'django_intro', 'templates')], # 추가
        'APP_DIRS': True,
        ...
    },

]
```

- `DIRS` : templates를 커스텀하여 경로를 설정할 수 있다.





> 개발환경

개발환경이 바뀌었을 때 일일이 패키지를 설치해줘야 하거나, 협업을 하게 됐을 때 개발중인 환경을 같이 넘겨줘야할 때가 있다.

이를 위해 개발환경을 기록하고 한번에 설치하기 위한 방법

- 개발환경 저장

  ```
  $ pip freeze > requirements.txt
  ```

- 개발환경 설치

  ```
  $ pip install -r requirements.txt
  ```

`requirements.txt` 에 있는 내용을 가지고 자동으로 패키지를 설치해줌으로써 해당 프로젝트가 어떤 버전의 패키지를 썼는지 기억하지 않아도 개발환경을 설정

github 에서 프로젝트를 받게되는 사람도 해당 파일이 있으면 가상환경 하나 만든 후 바로 설치가 가능





> Model & DB 기본개념

**QuerySet**

- objects를 사용하여 **다수의 데이터를 가져오는 함수를 사용할 때 반환되는 객체**
- 단일한 객체를 리턴할 때는 테이블(Class)의 인스턴스로 리턴됨





> admin.py : 관리자 변경 목록(change list) 커스터마이징

**list_display**

- admin 사이트에서 직접 레코드를 추가 해보자!

- `list_display` 는 admin 페이지에서 우리가 `models.py` 정의한 각각의 **속성(컬럼)들의 값(레코드)**를 보여준다.

  ```python
  # articles/admin.py
  
  from django.contrib import admin
  from .models import Article
  
  class ArticleAdmin(admin.ModelAdmin):
      list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
  
  admin.site.register(Article, ArticleAdmin)
  ```

  ```python
  # 또는 데코레이터를 사용해서도 할 수 있다.
  
  @admin.register(Article)
  class ArticleAdmin(admin.ModelAdmin):
      list_display = ('id', 'title', 'content', 'created_at', 'updated_at',)
  ```





> Django extensions



- Shell_plus 를 사용하면 models.py 에 등록한 모델을 자동으로 import해준다.

```bash
$ pip install django-extensions
```

```python
# settings.py

INSTALLED_APPS = [
    ...
    'django_extensions',
    ...
]
```





> embed() : 서버 일시정지 후 python shell 작동



> Variable routing : urls.py에 정의한 url로 받은 변수명



> URL namespace

```python
# articles/urls.py

app_name = 'articles'
urlpatterns = [
    ...
]
```



> RESTful API : Representational State Transfer



- GET 요청은 HTTP body가 아닌 `쿼리 스트링`으로 데이터를 보낸다. 우리는 해당 데이터를 주소창에서 볼 수 있다.
- POST 요청은 HTTP body에 `정보를 담아서` 보낸다. 아래의 요청에서는 csrf_token과 관련된 정보가 Body에 담겨져 요청을 보낼 때 같이 전달된 것을 알 수 있다.





> On_delete

- ForeignKey의 필수 인자이며, ForeignKey가 참조하고 있는 부모(Article) 객체가 사라졌을 때 달려 있는 댓글들을 어떻게 처리할 지 정의

- `CASCADE`: **부모 객체가 삭제 됐을 때 이를 참조하는 객체도 삭제**한다.
- `PROTECT`: 참조가 되어 있는 경우 오류 발생.
- `SET_NULL`: 부모객체가 삭제 됐을 때 모든 값을 NULL로 치환. (NOT NULL 조건시 불가능)
- `SET_DEFAULT`: 모든 값이 DEFAULT 값으로 치환 (DEFAULT 설정 있어야함. DB에서는 보통 default 없으면 null로 잡기도 함. 장고는 아님.)
- `SET()`: 특정 함수 호출.
- `DO_NOTHING`: 아무것도 하지 않음. 다만, 데이터베이스 필드에 대한 SQL `ON DELETE`제한 조건을 설정해야 한다.





> 1:N

- 한 테이블에 있는 두 개 이상의 레코드가 다른 테이블에 있는 하나의 레코드를 참조할 때, 두 모델 간의 관계를 일대다 관계라고 한다. 이때 참조하는 대상이 되는 테이블의 필드는 유일한 값 이어야 한다. (ex. PK)

Article : Comment = 1 : N

```python
# articles/models.py

class Article(models.Model):
	...

class Comment(models.Model):
    article = models.ForeignKey(Article, on_delete=models.CASCADE)
    content = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-pk',]

    def __str__(self):
        return self.content
```



- article.comment_set.all() : article은 comment가 있을 수도, 없을 수도 있으므로 QuerySet으로 부르는 것이 맞다.
- comment.articlem : 자신이 참조하는 게시글을 접근할 수 있다.



> Metadata

- `class Meta`와 같이 선언하여 모델에 대한 모델-레벨의 메타데이타를 선언





> Models.py에서의 related_name

- 위에서 확인한 것처럼 부모 테이블에서 역으로 참조할 때 `모델이름_set` 이라는 형식으로 참조한다. (**역참조**)

- related_name 값은 django 가 기본적으로 만들어 주는 `_set` 명령어를 임의로 변경할 수 있다.

  ```python
  # articles/models.py
  
  class Comment(models.Model):
      article = models.ForeignKey(Article, on_delete=models.CASCADE, related_name='comments')
    ...
  ```

- 위와 같이 변경하면 `article.comment_set` 은 더이상 사용할 수 없고 `article.comments` 로 대체된다.

> > 1:N 관계에서는 거의 사용하지 않지만 M:N 관계에서는 반드시 사용해야 할 경우가 발생한다.

article.**comment_set**.all() => article.**comments**.all()





> 댓글 개수 출력

```
# 1. {{ comments|length }}

# 2. {{ article.comment_set.all|length }}

# 3. {{ comments.count }} 는 count 메서드가 호출되면서 comment 모델 쿼리를 한번 더 보내기 때문에 매우 작은 속도차이지만 더 느려진다.
```









> static & media file

- Static file
  - JS, CSS, Image 파일처럼 웹 서비스에서 사용하려고 `미리 준비 해놓는 파일`.
  - 파일 자체가 고정되어 있고, 서비스 중에도 추가되거나 변경되지 않고 `고정된 파일`.
  - logo 같은 것
- Media file
  - 사용자가 웹에서 올리는 파일.
  - 파일 자체는 고정 이지만, 언제/어떤 파일이 정적 파일로 제공 되는지는 예측할 수 없는 파일.



**`STATICFILES_DIRS`**

- Default: [] (Empty list)

- 개발 단계에서 사용하는 실제 정적 파일이 위치한 경로를 지정하는 설정 항목

- 여러 경로에 정적 파일을 배치 하였을 때, 그 위치를 설정해서 정적 파일을 찾을 수 있다.

  ```python
  # settings.py
  
  STATIC_URL = '/static/' # 웹 페이지에서 사용할 정적 파일의 최상위 URL 경로(실제 파일이 위치한 디렉토리 아님)
  
  STATICFILES_DIRS = [ # 정적 파일이 위치한 경로
      os.path.join(BASE_DIR, 'crud', 'assets'), # 쉼표(,)를 빠뜨리게 되면 에러가 난다. crud/assets/ 로 가서 정적 파일이 있는지 찾는다.
  ]
  ```

  - 일반적으로 공용으로 사용되는 정적파일들을 assets 폴더에 놓는 경우가 많다.(ex. bootstrap)



> [이미지 파일 필드 사용](https://docs.djangoproject.com/ko/2.2/faq/usage/#how-do-i-use-image-and-file-fields)
>
> - `FileField`/ `ImageField`를 사용할 때는 `MEDIA_ROOT`를 설정해야 한다.
>
> [Model field reference | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/fields/#imagefield)
>
> [MEDIA_ROOT& MEDIA_URL](https://docs.djangoproject.com/ko/2.2/ref/settings/#media-root)



### 기본 설정

1. 사용자가 올린 이미지 파일 업로드 경로 설정(`settings.py`)

- 이전에 `STATICFILES_DIRS` (실제로 파일이 있는 위치)를 설정 했던 것처럼 경로 설정이 필요하며, 업로드 한 파일에 접근하는 URL도 설정해야 한다.

  

**`MEDIA_ROOT`**

- Default: '' (Empty string)
- 업로드가 끝난 파일을 배치할 최상위 경로를 지정하는 설정이다. `STATICFILES_DIRS`과 비슷한 역할을 한다. (실제 해당 파일의 업로드가 끝나면 어디에 파일이 저장되게 할 지 경로)
- `MEDIA_ROOT`는 `STATIC_ROOT`와 값이 달라야한다.



**`MEDIA_URL`**

- Default: '' (Empty string)

- `STATIC_URL`과 역할이 비슷하다. **업로드 된(stored files) 파일의 주소를 만들어 주는 역할.**

- 반드시 `/`로 끝나야 하며 문자열로 설정해야 한다.

- `MEDIA_URL`는 `STATIC_URL`와 값이 달라야한다.

- 아무 값이나 작성해도 된다. 하지만 일반적으로 `/media/`를 사용한다.

  ```python
  # settings.py
  
  ...
   
  MEDIA_URL = '/media/' 
  # STATIC_URL과 비슷. 업로드 된 파일의 주소(URL)를 만들어 줌 (실제 이미지 파일이 업로드 된 디렉토리를 의미하는 것은 아님)
  
  MEDIA_ROOT = os.path.join(BASE_DIR, 'media') 
  # STATICFILES_DIRS 동일. 정적 파일의 업로드가 끝나면 파일이 어디에 저장될지를 설정하는 경로
  ```

  

2. 사용자가 업로드 한 파일 제공하기 (Serving files uploaded by a user during development)

> [Serving files uploaded by a user during development](https://docs.djangoproject.com/ko/2.2/howto/static-files/#serving-files-uploaded-by-a-user-during-development)

- 개발하는 단계에서 사용자가 업로드 한 media 파일을 우리 프로젝트의 `MEDIA_ROOT`경로로 업로드 하도록 한다. (배포 단계에서 사용하면 안된다.)

- 이렇게 사용자로부터 업로드된 파일이 우리 프로젝트 내부에 들어오기는 했지만, 실제로 사용자가 보게 하기 위해서는 `article.image.url`을 통해서 불러온다.

- 이때 url을 만들어 주는 친구가 `static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)`이다.

- 이 url 을 작성하는 이유는 파일이 업로드가 되어서 프로젝트 내부에 존재하기는 하지만 이 파일로 접근하는 url 이 없어서 만들어 줘야 하는데, 저 코드가 사용자가 업로드한 파일로 접근하는 url을 생성해준다.

- 즉, [`urls.py`](http://urls.py/)에 앞으로 업로드 될 모든 media에 대해 적용 가능한 주소를 붙여준다고 생각하면 된다.

  ```python
  # crud/urls.py
  
  ...
  from django.conf import settings
  from django.conf.urls.static import static
  
  # 1
  ...
  urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
  
  # 2
  urlpatterns = [
      ... 
  ] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
  
  
  # 첫번째 인자: 어떤 URL을 정적으로 추가 할지 (Media file URL)
  
  # 두번째 인자: 실제 해당 미디어 파일은 어디에 있는지 / 이때 document_root는 키워드인자로 Media File 이 위치한 경로로 전달.
  ```

  - 위에서 작성한 `[settings.py](<http://settings.py>)`설정을 바탕으로 업로드 된 파일의 주소(`MEDIA_ROOT`역할) 또한 만들어 준다. 업로드 된 파일을 가져오기 위해서는 그 파일에 접근하는 URL(`MEDIA_URL`역할)이 필요하다.

- 설정을 마무리 하고 처음에 올렸던 이미지 파일의 요청 경로를 개발자 도구의 network 탭을 통해 확인 해보자

  - 경로가 `http://주소/media/sample.png`로 바뀌었을 것이다.

- 다시 한번 이미지를 업로드 해보고 `media`라고 이름 지어준 폴더에 잘 업로드 되었는지 확인 해보자.

  <img width="238" alt="7-5" src="https://user-images.githubusercontent.com/52446416/65941892-16651b00-e467-11e9-8c5d-85f8ba6b3fad.png">
  <img width="850" alt="7-6" src="https://user-images.githubusercontent.com/52446416/65941894-16fdb180-e467-11e9-9f95-5d16f9c4d5b2.png">

  

- `article.image.url`== `/media/sample.png`

- 우리는 `detail.html` 페이지에서 아래와 같이 설정 해 주었기 때문에 `article.image.url`을 확인해보면 image의 경로를 볼 수 있다.

  ```bash
  # shell_plus
  
  In [1]: article = Article.objects.get(pk=37)                                          
  # 이미지 주소 
  In [2]: article.image.url      
  Out[2]: '/media/sample.png'
  
  In [3]: article.image.name               
  Out[3]: 'sample.png'
  
  # 실제 로컬에 이미지 파일이 저장된 경로
  In [4]: article.image.path               
  Out[4]: '/Users/junhokim/Dropbox/ssafy/ssafy_02/03_django/02_django_crud/media/sample.
  png'
  ```



> **Django에서 media 파일(사용자가 업로드한 파일)은 urls.py 에 경로 지정을 해야 하지만, static file은 아닌 이유는?**
>
> [Managing static files (e.g. images, JavaScript, CSS) | Django documentation | Django](https://docs.djangoproject.com/en/2.2/howto/static-files/#managing-static-files-e-g-images-javascript-css)
>
> - django 는 개발단계에서 `INSTALLED_APPS`의 `django.contrib.staticfiles`를 사용하면 `DEBUG = True`로 설정된 경우 `runserver`에 의해 자동으로 실행된다.
> - 하지만 이걸 `INSTALLED_APPS`에서 지우면 MEDIA 처럼 url.py 에 추가로 작성해야 한다.(하지만 이 방법은 insecure 하기 때문에 배포단계에서는 부적합)
>   - [Deploying static files | Django documentation | Django](https://docs.djangoproject.com/en/2.2/howto/static-files/deployment/#deploying-static-files)



3. 이미지 수정

- 이미지도 edit 페이지를 통해 새로운 이미지로 수정할 수 있지만, text와 는 다르게 수정 할 때 이미지를 무조건 업로드 하지 않으면 오류가 발생한다. (글만 수정하는 건 안된다는 의미!)

  - 이미지는 바이너리 데이터(하나의 덩어리)라서 텍스트처럼 **일부만 수정 하는게 불가능**하다. 그렇기 때문에 `Input value`에 넣어서 수정하는 방식을 사용하는 게 아니고, 새로운 사진으로 덮어 씌우는 방식을 사용한다.
- `<input type='file'>`type이 file인 경우에 value 속성을 지원하지 않는다.
  

  
- [참고 1]: 글만 수정하고 싶으면 글을 수정하고 같은 이미지 파일을 업로드 하면 된다. 같은 이름의 파일이 업로드 되면, **django에서 파일명 뒤에 랜덤 문자열을 자동으로 생성하여 다른 이미지 파일로 인식**한다. (기존에 저장되어 있는 이미지에 대한 정보를 불러 오지 않더라도 새로운 이미지를 업로드해서 바꿔 넣는 것)

  > **업로드 이미지 확인**<img width="1371" alt="7-7" src="https://user-images.githubusercontent.com/52446416/65942166-b02cc800-e467-11e9-8261-1886b1175fbc.png">

  

- [참고 2]: 기존 사진을 다시 보여주는 형태는 가능하다. (기존 사진 보여주기)

  ```python
  # articles/views.py
  
  def update(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      if request.method == 'POST':
          article.title = request.POST.get('title')
          article.content = request.POST.get('content')
          article.image = request.FILES.get('image')
          article.save()
          return redirect(article)
      else:
          context = {'article': article}
          return render(request, 'articles/update.html', context)
  ```

  ```django
  <!-- articles/update.html-->
  
  {% extends 'base.html' %}
  
  {% block content %}
    <h1 class="text-center">UPDATE</h1>
    <img src="{{ article.image.url }}" alt="{{ article.image }}">
    <form action="" method="POST" enctype="multipart/form-data">
      ...
      <label for="image">IMAGE</label>
      <input type="file" name="image" id="image" accept="image/*"><br>
      <input type="submit" value="submit">
    </form>
    <hr>
    <a href="{{ article.get_absolute_url }}">[back]</a><br>
    <a href="{% url 'articles:index' %}">[메인페이지]</a>
  {% endblock %}
  ```

  - 실제 수정을 진행 해보고 이미지가 잘 수정 되었는지 확인하기



4. `admin 페이지`를 활용해 이미지 파일이 어떻게 저장 되는지 확인

   ```python
   # articles/admin.py
   
   class AricleAdmin(admin.ModelAdmin):
       list_display = ('pk', 'title', 'content', 'image', 'created_at', 'updated_at',)
       ...
   
   
   admin.site.register(Article, AricleAdmin)
   ```

   

### 2.2 추가 설정

- 한가지 문제가 생긴다. 이미지 필드 설정 이전에 작성했던 이전 게시물 들을 보여주는 detail 페이지에서 image 속성을 읽어 오지 못해 페이지를 띄우지 못한다.

<img width="779" alt="7-8" src="https://user-images.githubusercontent.com/52446416/65942329-07cb3380-e468-11e9-9fc1-e3afe2a043f4.png">



1. 방법 1 (진행)

   - static 에 이미지가 없을 때 사용할 이미지를 미리 넣어두고 보여주는 방법
   - `articles/static/articles/images`폴더 안에 `no_image.png`이미지 넣기

   ```django
   <!-- articles/detail.html -->
   
   {% extends 'base.html' %}
   {% load static %}
   
   {% block content %}
     <h1 class='text-center'>DETAIL</h1>
     {% if article.image %}
       <img src="{{ article.image.url }}" alt="{{ article.image }}">
     {% else %}
       <img src="{% static 'articles/images/no_image.png' %}" alt="no_image">
     {% endif %}
     <h2>{{ article.pk }} 번째 글</h2>
   ```

   

2. 방법 2

   ```django
   <!-- articles/detail.html -->
   
   {% block content %}
     <h1>DETAIL</h1>
     {% if article.image %}
       <img src="{{ article.image.url }}" alt="{{ article.image }}">
     {% endif %}
   	...
   ```

   

- 문제가 하나 더 남았다. 이미지 업로드를 개발하기 전에 작성했던 게시글들의 수정 페이지가 접속되지 않는다. 이 게시글들은 `{{ article.image }}`값이 전혀 없기 때문이다. 그래서 위처럼 `update.html`도 조건문으로 분기한다.

  <img width="787" alt="7-9" src="https://user-images.githubusercontent.com/52446416/65942474-524cb000-e468-11e9-9428-69b4737d7388.png">

  ```django
  <!-- articles/update.html -->
  
  {% extends 'base.html' %}
  {% load static %}
  
  {% block content %}
    <h1 class="text-center">UPDATE</h1>
    {% if article.image %}
      <img src="{{ article.image.url }}" alt="{{ article.image }}">
    {% else %}
      <img src="{% static 'articles/images/no_image.png' %}" alt="no_image">
    {% endif %}
    ...
  ```
  
  

------



## 03. Image Resizing

>  **Pillow / PilKit / django-imagekit**
>
> - `Pillow` : Pillow는 PIL 프로젝트에서 fork 되어서 나온 라이브러리. PIL이 Python3를 지원하지 않기 때문에 Pillow를 많이 씀.(`ImageField()`사용시 필수 라이브러리)
> - `pilkit` : Pillow를 쉽게 쓸 수 있도록 도와주는 라이브러리. 다양한 Processors 지원
> - `django-imagekit` : 이미지 썸네일 helper Django 앱(실제 이미지를 처리할 때는 Pilkit을 사용)



### 3.1 이미지 사이즈 조절

- detail 페이지를 보게 되면, 이미지가 원본 그대로 업로드 되어서 너무 크거나 너무 작다.

- 또한, 실제 원본 이미지를 서버에 그대로 로드 할 경우 문제가 비용 문제가 생긴다.

- html img 태그에서 직접 사이즈를 조정할 수도 있지만(`width`와 `height`로 조정), 용량 문제도 있기 때문에 업로드 될 때의 이미지 자체를 resizing 할 필요가 있다.

- resizing은 `django-imagekit`모듈을 활용한다.

  ```bash
  # 설치 순서가 필요하다!
  
  # django-imagekit 을 사용하기 위해 사전 설치 필요
  $ pip install Pillow
  $ pip install pilkit 
  
  $ pip install django-imagekit
  ```

- 설치한 모듈을 INSTALLED_APSS에 등록한다.

  ```python
  # settings.py
  
  INSTALLED_APPS = [
      'articles.apps.ArticlesConfig',
      'jobs.apps.JobsConfig',
      'imagekit',
      ...
  ]
  ```

- **원본 이미지를 재가공하여 저장 (원본x, 썸네일o)**

  ```python
  # articles/models.py
  
  from imagekit.models import ProcessedImageField
  from imagekit.processors import Thumbnail
  
  
  # Create your models here.
  class Article(models.Model):
      title = models.CharField(max_length=20)
      content = models.TextField()
      image = ProcessedImageField(
          processors=[Thumbnail(200, 300)], # 처리할 작업 목록
          format='JPEG', # 저장 포맷
          options={'quality': 90}, # 추가 옵션들
          upload_to='articles/images', # 저장 위치 (MEDIA_ROOT/articles/images)
      )
      created_at = models.DateTimeField(auto_now_add=True)
      updated_at = models.DateTimeField(auto_now=True)
  ```

- 마이그레이션 진행

  ```bash
  $ python manage.py makemigrations
  
  $ python manage.py migrate
  ```

  - `ProcessedImageField()`의 parameter로 들어가 있는 값들은 makemigrations 후에 변경이 되더라도 **다시 makemigrations 를 해줄 필요 없다**. 바로바로 반영이 된다.

- 서버를 실행하고 이미지를 업로드 해보자.

  - 개발자 도구로 이미지의 요청 경로를 확인.
  - 기본적으로 `media`라는 폴더 아래 `articles/images`에 저장되는 이유는 `MEDIA_ROOT`를 media 파일로 설정했기 때문이다!

  <img width="246" alt="7-10" src="https://user-images.githubusercontent.com/52446416/65942850-2120af80-e469-11e9-9795-e79686adc9a7.png">
  <img width="803" alt="7-11" src="https://user-images.githubusercontent.com/52446416/65942851-2120af80-e469-11e9-9db6-604ab813a87b.png">

  

- 주의할 점은 코드를 수정한 후 업로드 되는 이미지에만 위 설정이 적용된다. **기존의 이미지들은 변하지 않는다.**사진을 업로드하는 시점에 이미지를 변환하고 저장하기 때문이다.

- admin 페이지에서 이미지끼리 주소를 비교 해보자

  <img width="1337" alt="7-12" src="https://user-images.githubusercontent.com/52446416/65942914-49a8a980-e469-11e9-9568-79ec987cebdb.png">

  

> [부록] 원본 ImageField로 부터 생성 (원본 O, 썸네일 O)
>
> ```python
> # articles/models.py
> 
> from imagekit.processors import Thumbnail
> from imagekit.models import ProcessedImageField, ImageSpecField
> from django.urls import reverse
> from django.db import models
> 
> 
> # Create your models here.
> class Board(models.Model):
>     title = models.CharField(max_length=10)
>     content = models.TextField()
>     image = models.ImageField(blank=True)
>     image_thumbnail = ImageSpecField(
>         source='image',  # 원본 ImageField 명
>         processors=[Thumbnail(200,300)],    
>         format='JPEG',  
>         options={'quality': 90},
>     )
>     created_at = models.DateTimeField(auto_now_add=True)
>     updated_at = models.DateTimeField(auto_now=True)
> ```
>
> ```django
> <img src="{{ article.image.url }}" alt="{{ article.image }}">
> <img src="{{ article.image_thumbnail.url }}" alt="{{ article.image }}">
> ```
>
> - `{{ article.image_thumbnail.url }}`를 사용하기 전 까지는 CACHE 폴더에 생성되지 않는다.
>
> <img width="417" alt="7-13" src="https://user-images.githubusercontent.com/52446416/65942973-693fd200-e469-11e9-8fc6-de99b1c1ecbf.png">



### 3.2 브라우저 캐싱

- 개발자 도구 - Network 를 통해 확인해보면 처음에 이미지를 업로드 하고 다시 새로 고침 했을 때의 이미지의 크기는 `memory cache`라고 뜨지만

  <img width="1235" alt="7-14" src="https://user-images.githubusercontent.com/52446416/65942974-693fd200-e469-11e9-9b11-8f0ad145a819.png">

- 캐시 삭제 후에 새로고침을 하게 되면 이미지 용량만큼 로드된 것을 볼 수 있다.

  <img width="1231" alt="7-15" src="https://user-images.githubusercontent.com/52446416/65942975-693fd200-e469-11e9-968c-1fc9f9d8e9c3.png">

- 즉, 한번 받은 데이터는 브라우저 cache 에 저장한 이후에 같은 요청이 들어오면 임시 저장된 브라우저 cache에서 꺼내 보여 준다.



------



## 04. 이미지 업로드 경로 커스텀

> `models.py`에서 instance와 filename을 사용할 수 있는 이유
>
> [Model field reference | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/fields/#django.db.models.FileField.upload_to)
>
> - `upload_to` : 함수처럼 호출이 가능하다. (upload_path를 통해서 호출된다.) 해당 함수가 호출이 되면서 2개의 인자를 받는다.
> - `instance` : 대부분의 경우에서, 이 객체는 아직 데이터베이스에는 저장이 안된다. 그래서 pk 값이 아직 없을 수 있다.
>
> ```python
> # articles/models.py
> 
> from IPython import embed
> 
> def articles_image_path(instance, filename):
>     embed()
>     return f'articles/{instance.pk}/images/{filename}'
> ```
>
> ```bash
> In [1]: instance                       
> Out[1]: <Article: 제목제목>
> 
> In [2]: filename                       
> Out[2]: 'sample.jpg'
> 
> In [3]: type(instance)                       
> Out[3]: articles.models.Article
> 
> In [4]: instance.pk                       
> 
> In [5]: instance.title                       
> Out[5]: '제목제목'
> 
> In [6]: instance.image                       
> Out[6]: <ProcessedImageFieldFile: sample.png>
> 
> In [7]: instance.image.url                       
> Out[7]: '/media/sample.png'
> ```
>
> - `filename` : 사용자가 업로드한 파일의 이름이다. 



- 지금까지는 간단하게 `/media/articles/images/`처럼 고정적인 폴더에 이미지가 업로드 되도록 작성했다.

- 이러면 하나의 폴더에 모든 이미지가 업로드 되어 추후에 관리가 어렵다. 이미지가 업로드 되는 위치를 깔끔하게 만들어 보자!

  ```python
  # articles/models.py
  
  def articles_image_path(instance, filename):
      return f'articles/{instance.pk}번글/images/{filename}'
      # 경로 : MEDIA_ROOT/articles/{instance.pk}번글/images/{filename}
  
  # instance --> 파라미터 instance는 Article 모델의 객체를 의미한다.
  # filename --> 업로드한 이미지 파일의 이름 
  
  # Create your models here.
  class Article(models.Model):
      title = models.CharField(max_length=20)
      content = models.TextField()
      image = ProcessedImageField(
          ...
          upload_to=articles_image_path,
      )
  ```

- 업로드 했을 때 문제가 하나 있다. `instance.pk`는 **처음 레코드가 작성되는 순간에는 pk가 없는 상태이기 때문에**(`pk`는 `None`이라서) `media/articles/None번글`이라는 폴더에 저장된다. (다만, 수정 시에는 레코드가 이미 pk값이 있기 때문에 `몇번 글`로 폴더가 만들어져서 그곳에 파일이 잘 저장된다.)

  <img width="241" alt="7-16" src="https://user-images.githubusercontent.com/52446416/65942977-69d86880-e469-11e9-83f0-0af05c722c04.png">

- 그래서 실제 개발 단계에서는 이런 식으로 하지 않는다.

- 로그인을 통해 유저 정보를 받고, 보통 `instance.user.pk`또는 `instance.user.username`처럼 업로드 한 사람의 정보로 폴더를 구조화하는 경우가 많다. 다시 원래대로 돌려놓자!



------



## 05. favicon

> [파비콘(Favicon)의 모든 것](https://webdir.tistory.com/337)
>
> https://www.favicon-generator.org/

- 접속 했을 때, 상단 탭에 보여지는 아이콘.
- 즐겨찾기에 웹페이지를 등록할 때도 사용.
- `static/articles/favicon/`폴더에 favicon 이미지 파일 저장



1. ico

   ```django
   <!-- crud/templates/base.html -->
   
   {% load static %}
   <!DOCTYPE html>
   <html lang="ko">
   
   <head>
     ...
     <link rel="shortcut icon" href="{% static 'articles/favicon/favicon.ico' %}" type="image/x-icon">
     <title>Document</title>
   </head>
   ```

   

2. PNG

   ```django
   <!-- crud/templates/base.html -->
   
   {% load static %}
   <!DOCTYPE html>
   <html lang="ko">
   
   <head>
     ...
     <link rel="shortcut icon" href="{% static 'articles/favicon/favicon.png' %}">
     <title>Document</title>
   </head>
   ```



[TOC]

---

`03_django_form 폴더 생성`



## 00. HTML Form

- 우리는 지금까지 HTML Form 를 통해서 사용자로부터 데이터를 받았다.
- 이렇게 직접 사용자의 데이터를 받으면 HTML을 작성하고, 입력된 데이터의 유효성을 검증하고, 필요시에 입력된 데이터를 검증 결과와 함께 다시 표시하며, 유효한 데이터에 대해 요구되는 동작을 수행하는 것을 올바르게 하기" 위해서는 꽤 많은 노력이 필요한 작업이다.
- Django는 일부 과중한 작업과 반복 코드를 줄여줌으로써, 이 작업을 훨씬 쉽게 만든다.

### 0.1 New Project

- 가상 환경 설정

- 프로젝트 시작

  ```
  03_django_form 폴더 생성
  ```

  ```bash
  $ django-admin startproject myform .
  $ python manage.py startapp articles
  ```

- `settings.py` 및 `.gitignore`설정

  ```python
  # settings.py
  
  INSTALLED_APPS = [
  		'articles.apps.ArticlesConfig',
      ...
  ]
  
  LANGUAGE_CODE = 'ko-kr'
  
  TIME_ZONE = 'Asia/Seoul'
  ```

  

### 0.2 Article Model

- 테이블 구조

  ```python
  # articles/models.py
  
  class Article(models.Model):
      title = models.CharField(max_length=10)
      content = models.TextField()
      created_at = models.DateTimeField(auto_now_add=True)
      updated_at = models.DateTimeField(auto_now=True)
  		
      class Meta:
          ordering = ('-pk',)
  
      def __str__(self):
          return self.title
  ```

  ```bash
  $ python manage.py makemigrations
  $ python manage.py migrate
  ```

- admin 설정

  ```bash
  $ python manage.py createsuperuser
  ```

  ```python
  # articles/admin.py
  
  from django.contrib import admin
  from .models import Article
  
  # Register your models here.
  class ArticleAdmin(admin.ModelAdmin):
      list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
  
  admin.site.register(Article, ArticleAdmin)
  ```

- url 설정

  ```python
  # myform/urls.py
  
  from django.contrib import admin
  from django.urls import path, include
  
  urlpatterns = [
      path('articles/', include('articles.urls')),
      path('admin/', admin.site.urls),
  ]
  ```

  ```python
  # articles/urls.py
  
  from django.urls import path
  
  urlpatterns = [
      
  ]
  ```

  

### 0.3 CREATE & READ

- INDEX

  ```python
  # articles/views.py
  
  from django.shortcuts import render
  from .models import Article
  
  # Create your views here.
  def index(request):
      articles = Article.objects.all()
      context = {'articles': articles,}
      return render(request, 'articles/index.html', context)
  ```

  ```python
  # articles/urls.py
  
  from django.urls import path
  from . import views
  
  app_name = 'articles'
  urlpatterns = [
      path('', views.index, name='index'),
  ]
  ```

  ```django
  <!-- templates/articles/base.html 부트스트랩 없이 -->
  
  <!DOCTYPE html>
  <html lang="ko">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
  </head>
  <body>
    {% block content %}
    {% endblock %}
  </body>
  </html>
  ```

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    <h1>Articles</h1>
    <a href="#">[NEW]</a>
    {% for article in articles %}
      <p>{{ article.pk }}</p>
      <p>{{ article.title }}</p>
      <a href="#">[DETAIL]</a>
      <hr>
    {% endfor %}
  {% endblock %}
  ```

  

- CREATE

  ```python
  # articles/views.py
  
  from django.shortcuts import render, redirect
  
  
  def create(request):
      if request.method == 'POST':
          title = request.POST.get('title')
          content = request.POST.get('content')
          article = Article(title=title, content=content)
          article.save()
          return redirect('article:index')
      else:
          return render(request, 'article/create.html')
  ```

  ```python
  # articles/urls.py
  
  urlpatterns = [
      path('', views.index, name='index'),
      path('create/', views.create, name='create'),
  ]
  ```

  ```django
  <!-- articles/create.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    <h1>CREATE</h1>
    <form action="" method="POST">
      {% csrf_token %}
      <label for="title">TITLE</label>
      <input type="text" name="title" id="title"><br>
      <label for="content">CONTENT</label>
      <textarea name="content" id="content"></textarea><br>
      <input type="submit" value="submit">
    </form>
  {% endblock %}
  ```

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    <h1>Articles</h1>
    <a href="{% url 'articles:create' %}">[NEW]</a>
    ...
  {% endblock %}
  ```

  

- DETAIL

  ```python
  # articles/views.py
  
  def detail(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      context = {'article': article,}
      return render(request, 'articles/detail.html', context)
  ```

  ```python
  # articles/urls.py
  
  urlpatterns = [
      ...
      path('<int:article_pk>/', views.detail, name='detail'),
  ]
  ```

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    <h1>DETAIL</h1>
    <hr>
    <p>글 번호: {{ article.pk }}</p>
    <p>글 제목: {{ article.title }}</p>
    <p>글 내용: {{ article.content }}</p>
    <p>글 생성 시각: {{ article.created_at|date:"SHORT_DATE_FORMAT" }}</p>
    <p>글 수정 시각: {{ article.updated_at|date:"M, j, Y" }}</p>
    <a href="{% url 'articles:index' %}">[back]</a>
  {% endblock %}
  ```

  ```python
  # articles/models.py
  
  from django.urls import reverse
  
  # Create your models here.
  class Article(models.Model):
  
      ...
  
      def get_absolute_url(self):
          return reverse('articles:detail', kwargs={'article_pk': self.pk})
  ```

  ```python
  # articles/views.py
  
  def create(request):
      if request.method == 'POST':
          ...
          return redirect(article) # detail 로 경로 변경
      else:
          return render(request, 'articles/create.html')
  ```

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
      <a href="{{ article.get_absolute_url }}">[DETAIL]</a>
      <hr>
    {% endfor %}
  {% endblock %}
  ```

  

---



## 01. Django Form

> [Forms](https://docs.djangoproject.com/ko/2.2/ref/forms/#forms)
>
> [The Forms API](https://docs.djangoproject.com/en/2.2/ref/forms/api/#module-django.forms)
>
> [Form fields](https://docs.djangoproject.com/en/2.2/ref/forms/fields/#module-django.forms.fields)

- `Form`클래스는 Django form 관리 시스템의 핵심이다. Form 클래스는 form내 field들, field 배치, 디스플레이 widget, label, 초기값, 유효한 값과 (유효성 체크이후에) 비유효 field에 관련된 에러메시지를 결정한다.
- 또한 Form 클래스는 미리 정의된 포맷(테이블, 리스트 등등) 의 템플릿으로 그 자신을 렌더링하는 method나 (세부 조정된 수동 렌더링을 가능케하는) 어떤 요소의 값이라도 얻는 method를 제공한다.



### 1.1 Create

**들어가기 전**

- `Form`을 선언하는 문법은 `Model`을 선언하는 것과 비슷하고 같은 필드 타입을 사용한다. (또한, 일부 매개변수도 유사하다.)
- 두 가지 경우 모두 각 필드가 데이터에 맞는(유효성 규칙에 맞춘) 타입인지 확인할 필요가 없고, 각 필드가 보여주고 문서화 할 description을 가진다는 것에서 Form과 Model이 유사한 문법으로 구성된다는 점을 납득할 수 있다.

**Form 선언**

- Form을 생성하기 위해, Form클래스에서 파생된, `forms`라이브러리를 import 하고 폼 필드를 생성한다.

- app 폴더에 forms.py 파일을 작성한다.

  ```python
  # articles/forms.py
  
  from django import forms
  
  class ArticleForm(forms.Form): 
      title = forms.CharField(max_length=10)
      content = forms.CharField()
  ```

**새로운 view 로직 작성**

```python
# articles/views.py 

from .forms import ArticleForm

def create(request):
    # POST 요청이면 폼 데이터를 처리한다.
    if request.method == 'POST':
        # 폼 인스턴스를 생성하고 요청에 의한 데이타로 채운다 (binding)
        # 이 처리과정은 "binding"으로 불리며 폼의 유효성 체크를 할수 있도록 해준다.
        form = ArticleForm(request.POST)
        # 사용자가 ArticleForm 으로 보낸 데이터를 받아서 form 이라는 인스턴스를 생성. 
        # form 의 type은 ArticleForm 이라는 클래스의 인스턴스(request.POST 는 QueryDict 로 담긴다)
        
        # 폼이 유효한지 체크한다
        if form.is_valid():
            # form.cleaned_data 데이타를 요청받은대로 처리한다.
            title = form.cleaned_data.get('title')
            content = form.cleaned_data.get('content')
            article = Article.objects.create(title=title, content=content)
            return redirect(article)
    # GET 요청 (혹은 다른 메서드)이면 기본 폼을 생성한다.
    else:
        form = ArticleForm()
    # 상황에 따라 context 에 넘어가는 2가지 form
    # 1. GET : 기본 form 으로 넘겨짐
    # 2. POST : 검증에 실패(is_valid -> False)한 form(오류메세지를 포함한 상태)로 넘겨짐
    context = {'form': form,}
    return render(request, 'articles/create.html', context)
```

- 기존에는 사용자가 form으로 넘긴 데이터를 바로 DB에 저장

- 이제는 데이터의 유효성을 검사하고 정제 후 저장

- 주석을 제거한 create view

  ```python
  def create(request):
      if request.method == 'POST':
          form = ArticleForm(request.POST)
          if form.is_valid():
              title = form.cleaned_data.get('title')
              content = form.cleaned_data.get('content')
              article = Article.objects.create(title=title, content=content)
              return redirect(article)
      else:
          form = ArticleForm()
      context = {'form': form,}
      return render(request, 'articles/create.html', context)
  ```



**is_valid() / cleaned_data**

- is_valid()
  - https://docs.djangoproject.com/en/2.2/ref/forms/api/#django.forms.Form.is_valid
  - Form 객체의 유효성 검사를 하는 데 가장 주요한 역할을 한다. Form 객체가 생성되면( `form = ArticleForm(request.POST)`) 유효성 검사를 하고 데이터가 유효한지 아닌지 여부를 boolean 으로 반환한다.
- cleaned_data
  - 폼의 데이터가 유효하다면 `form.cleaned_data`속성을 통해 데이터 사용을 시작할 수 있다.
  - 기본 유효성 검사 도구를 이용해 입력 값을 **다듬고**잠재적으로 안전하지 않을 수 있는 입력 값을 정당화 하며, 해당 입력 값에 맞는 표준 형식으로 변환 해준다.
  - 깔끔한 데이터(cleaned_data)란 것은 정제되고, 유효성 체크가 되고(ex 빈 값이 없음 - NOT NULL조건), 파이썬에서 많이 쓰는 타입(딕셔너리)의 데이터이다.
    - `request`객체를 통해 직접 폼 데이터를 가져올 수는 있으나(`request.POST.get('title')`), 이 방식은 **절대** 추천하지 않는다.



**template 새롭게 작성**

```django
<!-- articles/create.html --> 

{% extends 'articles/base.html' %}
{% block content %}
  <h1>CREATE</h1>
  <form action="" method="POST">
    {% csrf_token %}
    {{ form.as_p }}
    <input type="submit" value="submit">
  </form>
  <a href="{% url 'articles:index' %}">[back]</a>
{% endblock %}
```

- create 페이지에서 변화된 모습을 확인해보자.

- 개발자도구로 HTML form 의 모습을 확인해보자.

  

> **`dot notation`(점 표기법)을 활용하여 각 부분 렌더링을 더 세부적으로 제어 할 수도 있다.**
>
> https://docs.djangoproject.com/en/2.2/topics/forms/#rendering-fields-manually
>
> 1. Rendering fields manually
>
>    ```django
>    <!-- articles/create.html --> 
>    
>    {% extends 'articles/base.html' %}
>    {% block content %}
>      <h1>CREATE</h1>
>      <form action="" method="POST">
>        {% csrf_token %}
>        {{ form.title.label_tag }}
>        {{ form.title }}
>        {{ form.content.label_tag }}
>        {{ form.content }}
>        <input type="submit" value="submit">
>      </form>
>      <a href="{% url 'articles:index' %}">[back]</a>
>    {% endblock %}
>    ```
>
> 2. Looping over the form’s fields (`{% for %}`)
>
>    ```django
>    <!-- articles/create.html -->
>    
>    {% extends 'articles/base.html' %}
>    {% block content %}
>      <h1>CREATE</h1>
>      <form action="" method="POST">
>        {% csrf_token %}
>        {% for field in form %}
>          {{ field.label_tag }}
>          {{ field }}
>        {% endfor %}
>        <input type="submit" value="submit">
>      </form>
>      <a href="{% url 'articles:index' %}">[back]</a>
>    {% endblock %}
>    ```



**Outputting forms as HTML**

>  https://docs.djangoproject.com/ko/2.2/ref/forms/api/#outputting-forms-as-html

- `as_p()`: 각 필드가 단락(paragraph)으로 렌더링
- `as_ul()`: 각 필드가 목록항목(list item)으로 렌더링
- `as_table()`: 각 필드가 테이블 행으로 렌더링



**Form Class 의 장점(자동화)**

- `[models.py](<http://models.py>)`에서 따로 `blank=True`와 같은 빈 값을 허용하는 옵션을 주지 않았다면, 자동으로 input tag에 `required`가 추가되어 생성된다. (직접 input tag를 만들 때는 각각 값을 넣어 줘야만 했다. 그렇지 않은 상태에서 빈 값을 입력하면 에러 페이지가 나온다)
- 입력된 값이 유효하지 않은 경우(ex.max_length) 에러 페이지를 띄우는 것이 아니라 에러 메시지를 form이 있는 페이지에 자동으로 보여준다.
  - `is_valid()`를 통과하지 못해 다시 `renturn render()`를 실행하기 때문이다.
  - 다만, `create/`페이지와 다른 점은 `ArticleForm(request.POST)`로 사용자가 입력한 값이 미리 설정되게 된다는 점이다.



**`form`데이터 확인해보기**

```bash
$ pip install ipython
```

```python
# articles/views.py

from IPython import embed

def create(request):
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        embed()
```

```bash
# form은 forms.py 의 ArticleForm 클래스의 인스턴스 객체이다. (아직 정제되지 않음)
In [1]: form       
Out[1]: <ArticleForm bound=True, valid=Unknown, fields=(title;content)>

In [2]: request.POST
Out[2]: <QueryDict: {'csrfmiddlewaretoken': ['fFjQdNw8stKQmvr2hjGMHDkyOiKofcs2pakM3KKC
e7HZPgfh52YXCO549IZN6VFK'], 'title': ['제목제목'], 'content': ['내용내용']}>

In [3]: type(form)                        
Out[3]: articles.forms.ArticleForm

# 유효성 검사
In [4]: form.is_valid()                   
Out[4]: True


# --- [중요] 유효성 검증 후 form 의 변화 --- #


In [5]: form
Out[5]: <ArticleForm bound=True, valid=True, fields=(title;content)>

# form 을 form.cleaned_data로 정제하고 나면 dict 자료형이 되고 그때서야 .get 메서드 사용 가능
In [6]: form.cleaned_data
Out[6]: {'title': '제목제목', 'content': '내용내용'}

In [7]: type(form.cleaned_data)
In [7]: dict

In [8]: form.cleaned_data.get('title')
Out[8]: '제목제목'

In [9]: form.as_p()
Out[9]: '<p><label for="id_title">Title:</label> <input type="text" name="title" value="제목제목" maxlength="10" required id="id_title"></p>\n<p><label for="id_content">Content:</label> <input type="text" name="content" value="내용내용" required id="id_content"></p>'

In [10]: form.as_table()
Out[10]: '<tr><th><label for="id_title">Title:</label></th><td><input type="text" name="title" value="제목제목" maxlength="10" required id="id_title"></td></tr>\n<tr><th><label for="id_content">Content:</label></th><td><input type="text" name="content" value="내용내용" required id="id_content"></td></tr>'
```

- `input`, `textarea`같은 html tag 들이 모두 form 안으로 들어갔다.



### 1.2 Widget

>  [Widgets | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/forms/widgets/#module-django.forms.widgets)

- Django form 을 사용하면 기본적으로 field 에 맞는 적합한 default widget 를 사용한다.

  - https://docs.djangoproject.com/en/2.2/ref/forms/fields/#built-in-field-classes

- 그런데 다른 widget 을 사용하고 싶다면 `widget`인자를 통해 field 를 새로 정의할 수 있다.

- widget 인자의 속성을 통해서 어떤 tag를 사용할지 혹은 기타 속성 지정도 가능하다.

  ```python
  # articles/forms.py
  
  class ArticleForm(forms.Form):
      title = forms.CharField(max_length=10)
      content = forms.CharField(widget=forms.Textarea)
  ```

  - create 페이지에서 textarea 로 변경되었는지 확인해보자.

  - `Widget.attrs`인자를 통해서 더 세부적으로 속성을 추가할 수 있다.

    ```python
    # articles/forms.py
    
    class ArticleForm(forms.Form):
        title = forms.CharField(
            max_length=10,
            label='제목',
            widget=forms.TextInput(
                attrs={
                'class': 'my-title',
                'placeholder': 'Enter the title',
                }
            )
        )
        content = forms.CharField(
            label='내용',
            widget=forms.Textarea(
                attrs={
                    'class': 'my-content',
                    'placeholder': 'Enter the content',
                    'rows': 5,
                    'cols': 50,
                }
            )
        )
    ```

    - `label`: 실제 html label 태그와 동일
    - `widget`: input type을 지정하고 해당하는 속성을 지정할 수 있다.

  - 글이 잘 작성 되는지 확인 해보자! (개발자 도구로 tag 속성들이 추가 됐는지도 확인 해보기)



### 1.3 get_object_or_404

`get_object_or_404(class, *args, **kwargs)`

> https://docs.djangoproject.com/en/2.2/topics/http/shortcuts/#get-object-or-404

- 시작하기 전에 pk 값이 없는 detail 페이지로 요청을 보내 보자. (예를 들면, url 에 `articles/100/`이라고 입력 해보자. 존재하지 않는 pk로!) 에러 메시지가 500(Internal Server Error)으로 나온다.

- 500 에러는 내부 서버의 오류로 '서버에 오류가 발생하여 요청을 수행할 수 없다'는 의미다. 이 경우 사용자의 요청이 잘못된 경우이기 때문에 404 에러인 '서버에 존재하지 않는 페이지에 대한 요청이 있을 경우' 에 해당하는 에러로 바꿔서 처리해주는 것이 더 바람직하다.

- `get_object_or_404`는 해당 객체가 있다면 `objects.get(pk=article_pk)`을 실행하고 없으면 **ObjectDoesNotExist 예외**가 아닌 **Http404(HttpResponseNotFound)**를 raise 한다.

  - `pk=article_pk`에 해당하는 객체가 있으면 `article = Article.objects.get(pk=article_pk)`와 동일, 아니면 404 에러 발생.

- 참고로 `index`는 전체를 가져오기 때문에 특정 객체 하나만을 가져오는 `get_object_or_404`가 아닌 `get_list_or_404`를 사용한다. (프로젝트 상황에 따라 사용)

  ```python
  # articles/views.py
  
  from django.shortcuts import render, redirect, get_object_or_404
  
  def detail(request, article_pk):
      article = get_object_or_404(Article, pk=article_pk)
      context = {'article': article,}
      return render(request, 'articles/detail.html', context)
  ```

  >  위 코드는 아래와 동일하다.
  >
  > ```python
  > from django.http import Http404
  > 
  > def detail(request, article_pk):
  >     try:
  >         article = Article.objects.get(pk=article_pk)
  >     except Article.DoesNotExist:
  >         raise Http404("No Article matches the given query.")
  >     context = {'article': article,}
  >     return render(request, 'articles/detail.html', context)
  > ```

- 응용

  ```python
  # 응용 예시
  get_object_or_404(Article, title__startswith='A', pk=1)
  ```

- 변경 후에 다시 `articles/100`으로 요청을 보내보면 이제는 Page not found 라는 404 에러가 발생한다.

- 왜 사용해야 할까? (왜 404 error 가 나올 상황에 internal server error 가 발생할까?)

  - `.get()`메서드는 조건에 맞는 데이터가 없는 경우에 에러를 뿜게 설계되어 있다. **코드 단계에서 발생한 에러에 대해서 브라우저는 500 Internal Server Error**로 인식한다.
  - 클라이언트 입장에서 `서버에 오류가 발생하여 요청을 수행할 수 없다(500)`라는 원인이 정확하지 않은 에러를 마주하기 때문에 **올바른 에러를 예외처리하고 발생 시키는 것 또한 중요한 요소**이다.



### 1.4 Delete

```python
# articles/views.py

def delete(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    if request.method == 'POST':
        article.delete()
        return redirect('articles:index')
    else: 
        return redirect(article)
```

```python
# articles/urls.py

urlpatterns = [
    ...
    path('<int:article_pk>/delete/', views.delete, name='delete'),
]
```

```django
<!-- articles/detail.html -->

{% extends 'articles/base.html' %}
{% block content %}
  ...
  <p>글 수정 시각: {{ article.updated_at|date:"M, j, Y" }}</p>
  <form action="{% url 'articles:delete' article.pk %}" method="POST">
    {% csrf_token %}
    <input type="submit" value="DELETE">
  </form>
  <hr>
  <a href="{% url 'articles:index' %}">[back]</a>
{% endblock %}
```





### 1.5 Update

- `create.html`를 같이 사용할 것이기 때문에 추가로 템플릿을 만들지 않는다.

```python
# articles/views.py

def update(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            article.title = form.cleaned_data.get('title')
            article.content = form.cleaned_data.get('content')
            article.save()
            return redirect(article)
    else:  
      	# ArticleForm 을 초기화(이전에 DB에 저장된 데이터 입력값을 넣어준 상태)
        form = ArticleForm(initial={'title': article.title, 'content': article.content})
        # form = ArticleForm(initial=article.__dict__) # 딕셔너리 자료형이 되어 저장
	# context 로 넘어가는 form 은
    # 1. POST : 요청에서 검증에 실패하였을 때(form.is_valid()가 False일 때), 오류 메세지가 포함된 상태로 넘겨짐
    # 2. GET : 요청에서 초기화된 상태로 넘겨짐
    context = {'form': form,}
    return render(request, 'articles/create.html', context)
```

```python
# 주석을 제거한 코드

def update(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            article.title = form.cleaned_data.get('title')
            article.content = form.cleaned_data.get('content')
            article.save()
            return redirect(article)
    else:
        form = ArticleForm(initial=article.__dict__)
    context = {'form': form,}
    return render(request, 'articles/create.html', context)
```

```python
# articles/urls.py

urlpatterns = [
    ...
    path('<int:article_pk>/update/', views.update, name='update'),
]
```

```django
<!-- articles/detail.html -->

{% extends 'articles/base.html' %}
{% block content %}
  ...
  <p>글 수정 시각: {{ article.updated_at|date:"M, j, Y" }}</p>
  <a href="{% url 'articles:update' article.pk %}">[UPDATE]</a>
  ...
{% endblock %}
```







**`initial`**

> https://docs.djangoproject.com/en/2.2/ref/forms/fields/#initial

- 폼이 나타날 때 해당 필드의 초기 값.

- 우리가 html input 태그의 `value`속성을 사용했던 것과 동일하다.

- 이때 초기 값을 설정하는 인수는 `딕셔너리 자료형`이어야 한다.

  >  `article.__dict__`확인해보기
  >
  > ```python
  > # articles/views.py
  > 
  > def update(request, article_pk):
  > 		...
  >     else:
  >         embed()
  >         form = ArticleForm(initial=article.__dict__)
  > 		...
  > ```
  >
  > ```python
  > In [1]: article                  
  > Out[1]: <Article: 제목제목>
  > 
  > In [2]: dir(article)                  
  > Out[2]: 
  > ['DoesNotExist',
  >  'MultipleObjectsReturned',
  >  '__class__',
  >  '__delattr__',
  >  '__dict__',
  >  ...,
  >  'updated_at',
  >  'validate_unique']
  > 
  > In [3]: article.__dict__                  
  > Out[3]: 
  > {'_state': <django.db.models.base.ModelState at 0x10fb863c8>,
  >  'id': 4,
  >  'title': '제목제목',
  >  'content': '내용내용',
  >  'created_at': datetime.datetime(2019, 9, 15, 10, 39, 36, 729218, tzinfo=<UTC>),
  >  'updated_at': datetime.datetime(2019, 9, 15, 10, 39, 36, 729263, tzinfo=<UTC>)}
  > 
  > In [4]: exit
  > ```

  

**Create / Update 가 같은 template 을 공유한다.**

- create 로직

  - GET: 사용자 데이터를 입력할 form
  - POST: 새로운 글을 DB에 저장

- update 로직

  - GET: 기존의 사용자의 데이터가 입력된 form
  - POST: 수정된 글을 DB에 저장

- 문제점

  - 글을 작성하거나 수정할 때 항상 `<h1>CREATE</h1>`문구만 고정
  - 새 글 작성에서 뒤로 가기 버튼과 글 수정에서의 뒤로 가기 버튼의 동작 분기 필요 (Create → Index page / Update → Detail page)
  - 뒤쪽에서 해결 예정

  

------



## 02. ModelForm

> [Creating forms from ModelForm](https://docs.djangoproject.com/ko/2.2/topics/forms/modelforms/#creating-forms-from-models)

- Django 프레임 워크는 Model Class로부터 Form(폼)을 자동으로 생성하는 기능을 가지고 있다.
- 모델 클래스로부터 폼 클래스를 만들기 위해서는 아래와 같은 2개의 속성 지정을 해야 한다.
  - `django.form.ModelForm`클래스로부터 파생된 사용자 폼 클래스를 정의
  - 사용자 폼 클래스 안에 Meta 클래스(모델의 정보가 담긴다)를 정의하고 Meta 클래스 안 Model속성(attribute)에 해당하는 모델 클래스를 지정한다. 즉, 어떤 모델을 기반으로 폼을 작성할 것 인지를 `Meta.model`에 지정하는 것이다.



### 2.1 ModelForm 정의

- FormClass 에서는 Model에서 이미 정의한 필드를 반복해서 정의해야 했다. 하지만 Model에 이미 필드를 정의했기 때문에 다시 필드 유형을 정의하는 것은 불필요하다.

- Django에서는 model을 통해 Form Class를 만들수 있는 Helper(도우미)를 제공한다.

  - form에서 모델 정의를 다시 하는 대신에 ModelForm Helper 클래스를 사용하여 모델에서 form을 작성하는 것을 제공한다. (이게 훨씬 쉽고 간결하다)

  - ModelForm은 일반 Form과 완전히 같은 방식(객체생성)으로 view에서 사용할 수 있다.

    ```python
    # articles/forms.py
    
    from django import forms
    from .models import Article
    
    # class ArticleForm(forms.Form):
    #     title = forms.CharField(
    #         max_length=10,
    #         label='제목',
    #         widget=forms.TextInput(
    #             attrs={
    #             'class': 'my-title',
    #             'placeholder': 'Enter the title',
    #             }
    #         )
    #     )
    #     content = forms.CharField(
    #         label='내용',
    #         widget=forms.Textarea(
    #             attrs={
    #                 'class': 'my-content',
    #                 'placeholder': 'Enter the content',
    #                 'rows': 5,
    #                 'cols': 50,
    #             }
    #         )
    #     )
    
    class ArticleForm(forms.ModelForm):
        
        class Meta:
            model = Article
            fields = '__all__'
            # exclude = ('title',)
    ```

  - 기존 ArticleForm 클래스를 주석 처리하고, 같은 이름의 새로운 클래스를 정의한다.

    - 기존 class와 다르게 `ModelForm`을 상속받는다.
    - Model 정보를 받아, 해당 Model이 가지고 있는 field에 맞춰 input을 자동으로 만들어준다.

  - `class Meta`는 **Model 의 정보**를 작성하는 곳

  - `fields`를 작성하면, `models.py`에 지정 해놓은 CharField, TextField 를 자동으로 맞춰서 사용한다. (또는 `exclude`를 사용하여 특정 필드를 모델로부터 포함시키지 않을 수도 있다.)

  - `create.html`변화 확인 (자동으로 모델 필드에 맞춰서 input 태그를 생성해준다. 개발자 도구로 찍어보기)



### 2.2 Widgets

> https://docs.djangoproject.com/ko/2.2/topics/forms/modelforms/#overriding-the-default-fields

1. 첫번째 방식

   ```python
   class ArticleForm(forms.ModelForm):
       class Meta:
           model = Article
           fields = ('title', 'content',)
           widgets = {
               'title': forms.TextInput(attrs={
                   'class': 'title',
                   'placeholder': 'Enter the title',
                   }
               )
           }
   ```

2. 두번째 방식 **(권장)**

   ```python
   class ArticleForm(forms.ModelForm):
       title = forms.CharField(
           label='제목',
           max_length=10,
           widget=forms.TextInput(attrs={
               'class': 'title',
               'placeholder': 'Enter the title',
           })
       )
       class Meta:
           model = Article
           fields = ('title', 'content',)
   ```

   ```python
   # articles/forms.py
   
   class ArticleForm(forms.ModelForm):
       title = forms.CharField(
           max_length=10,
           label='제목',
           widget=forms.TextInput(
               attrs={
                   'class': 'my-title',
                   'placeholder': 'Enter the title',
               }
           )
       )
       content = forms.CharField(
           label='내용',
           widget=forms.Textarea(
               attrs={
                   'class': 'my-content',
                   'placeholder': 'Enter the content',
                   'rows': 5,
                   'cols': 50,
               }
           )
       )
       
       class Meta:
           model = Article
           fields = '__all__'
   ```

   

### 2.3 Create

> The `save()`method
>
> https://docs.djangoproject.com/ko/2.2/topics/forms/modelforms/#the-save-method

```python
# articles/views.py

def create(request):
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            article = form.save()
            return redirect(article)
    else:
        form = ArticleForm()
    context = {'form': form,}
    return render(request, 'articles/create.html', context)
```



**Form**과 **ModelForm**의 핵심 차이점

- Form
  - 어떤 모델에 저장해야 하는지 알 수 없기 때문에 유효성 검사를 하고 실제로 DB에 저장할 때는 `cleaned_data`와 `article = Article(title=title, content=content)`를 사용해서 따로 `.save()`를 해야 한다.
  - Form Class가 `cleaned_data`로 딕셔너리로 만들어서 제공해 주고, 우리는 `.get`으로 가져와서 Article 을 만드는데 사용한다.
- ModelForm
  - django 가 해당 모델에서 양식에 필요한 대부분의 정보를 이미 정의한다.
  - `forms.py`에 Meta 정보로 `models.py`에 이미 정의한 Article 을 넘겼기 때문에 어떤 모델에 레코드를 만들어야 할지 알고 있어서 바로 `.save()`가 가능하다.



### 2.4 Update

- ModelForm 은 Update 로직에서 매우 편리하다.

- 인자로 넣는 `instance`는 **수정 대상이 되는 객체를 지정**한다.

- create 로직과 다른 점은 기존의 데이터를 가져와 수정을 한다는 점이다. `article`인스턴스를 DB에서 가져와, ArticleForm에 `instance`의 인자로 넣는다.

  - `request.POST`: 사용자가 form을 통해 전송한 데이터
  - `instance`: 수정이 되는 대상

  ```python
  # articles/views.py
  
  def update(request, article_pk):
      article = get_object_or_404(Article, pk=article_pk)
      if request.method == 'POST':
          # Create a form to edit an existing Article, 
          # but use POST data to populate the form.
          form = ArticleForm(request.POST, instance=article)
          if form.is_valid():
              article = form.save()
              return redirect(article)
      else:
          # Creating a form to change an existing article.
          form = ArticleForm(instance=article)
      context = {'form': form,}
      return render(request, 'articles/create.html', context)
  ```

- `create.html`→ `form.html`

  - 이제 `create.html`이라는 파일은 create 페이지 뿐만 아니라 update에서도 사용하니, `form.html`으로 이름을 변경하자.

    ```
    # views 에서 create.html 을 모두 form.html 로 바꾼다.
    
    return render(request, 'articles/form.html', context)
    ```



**forms.py 의 위치**

- Form class는 `forms.py `뿐만 아니라 다른 위치 어느 곳에 두어도 상관없다.

  ```python
  # articles/models.py
  
  from django.db import models
  from django import forms 
  
  class Article(models.Model):
  		...
  
  class ArticleForm(forms.ModelForm):
      class Meta: 
          model = Article 
          fields = ('title', 'content',)
  		...
  ```

  - 하지만 되도록 app 폴더에 두며, Form class는 `[forms.py](<http://forms.py>)`에 작성하는 것이 컨벤션이다.



### 2.5 url resolver

> `request.resolver_match`까보기
>
> ```python
> # articles/views.py
> 
> def create(request):
>     embed()
> ```
>
> ```python
> In [1]: request                                               
> Out[1]: <WSGIRequest: GET '/articles/create/'>
> 
> In [2]: dir(request)               
> Out[2]: 
> ['COOKIES',
>  'FILES',
>  'GET',
>  'META',
>  'POST',
>  ...,
>  'resolver_match',
>  'scheme',
>  'session',
>  'upload_handlers',
>  'user',
>  'xreadlines']
> 
> In [3]: request.resolver_match               
> Out[3]: ResolverMatch(func=articles.views.create, args=(), kwargs={}, url_name=create, app_names=['articles'], namespaces=['articles'], route=articles/create/)
> 
> In [4]: dir(request.resolver_match)                           
> Out[4]: 
> ['__class__',
>  '__delattr__',
>  ...
>  'app_name',
>  'app_names',
>  'args',
>  'func',
>  'kwargs',
>  'namespace',
>  'namespaces',
>  'route',
>  'url_name',
>  'view_name']
> 
> In [5]: request.resolver_match.url_name                       
> Out[5]: 'create'
> ```



- resolver 는 웹 브라우저와 같은 DNS 클라이언트의 요청을 네임 서버로 전달하고 네임 서버로부터 정보(도메인 이름과 IP주소)를 받아 클라이언트에게 제공하는 기능을 수행한다.

  - url resolver 는 실제 url 과 `urls.py`에서 정의한 path 의 번역기
  - `reverse()`는 urlresolvers 모듈안에 있는 메서드다.
  - `articles:detail article.pk`같이 주소를 만들 때, app_name 과 path 의 name 에 일치하는, 실제 주소창에 입력되는 `/articles/1/`을 찾아주고, 해당 주소를 못 찾을 때 발생하는 에러가 `NoReverseMatch`다.
  - **결과적으로 resolver 라는 건 실제 주소창에 입력되는 주소와 장고 내부에서 사용하는 url 간에 서로 번역을 해주는 역할**을 한다고 생각하면 된다.

- 우리는 url resolver 를 활용하여 우리 로직의 2가지 문제점을 수정 할 것이다.

  - 새 글을 작성하고 기존 글을 수정할 때 `form.html`에는 항상 CREATE 라는 문구만 나오는 부분
  - 새 글 작성에서 뒤로 가기 버튼과 기존 글 수정에서 뒤로 가기 버튼은 동작 수정 (Create → Index / Update → Detail)

  ```django
  <!-- articles/form.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    {% if request.resolver_match.url_name == 'create' %}
      <h1>CREATE</h1>
    {% else %}
      <h1>UPDATE</h1>
    {% endif %}
    <form action="" method="POST">
      {% csrf_token %}
      {{ form.as_p }}
      <input type="submit" value="submit">
    </form>
    {% if request.resolver_match.url_name == 'create' %}
      <a href="{% url 'articles:index' %}">[back]</a>
    {% else %}
      <a href="{{ article.get_absolute_url }}">[back]</a>
    {% endif %}
  {% endblock %}
  ```

  

- 그런데 create 페이지 에서는 back 버튼이 제대로 동작하지만 update 페이지에서는 back 버튼에 아무런 반응이 없다.

  - update view 함수에서 article 객체를 템플릿에 넘겨준 적이 없기 때문이다.

    ```python
    # articles/views.py
    
    def update(request, article_pk):
        ...
        context = {'form': form, 'article': article,}
        return render(request, 'articles/form.html', context)
    ```

  

------



## 03. Bootstrap ModelForm

### 3.1 django-bootstrap4

> https://django-bootstrap4.readthedocs.io/en/latest/installation.html
>
> https://pypi.org/project/django-bootstrap4/

- 공식 문서를 같이 따라가며 이것저것 사용 해보자.

- form class 에 bootstrap 을 적용시켜주는 라이브러리

  ```
  $ pip install django-bootstrap4
  ```

  ```python
  # settings.py
  INSTALLED_APPS = [
    ...
    'bootstrap4',
  	...
  ]
  ```

- articles/base.html

  ```django
  {% load bootstrap4 %}
  <!DOCTYPE html>
  <html lang="ko">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    {% bootstrap_css %}
    <title>Document</title>
  </head>
  <body>
    <div class="container">
      {% block content %}
      {% endblock %}
    </div>
    {% bootstrap_javascript jquery='full' %}
  </body>
  </html>
  ```

- `articles/form.html`

  ```django
  {% extends 'articles/base.html' %}
  {% load bootstrap4 %}
  
  {% block content %}
    ...
    <form action="" method="POST">
      {% csrf_token %}
      {% bootstrap_form form layout='horizontal' %}
      {% buttons submit="Submit" reset="Cancel" %}{% endbuttons %}
    </form>
    ...
    {% endif %}
  {% endblock %}
  ```

  

------



## 04. Comment ModelForm

### 4.1 model 및 form 정의

- 모델 정의

  ```python
  # article/models.py
  
  class Comment(models.Model):
      article = models.ForeignKey(Article, on_delete=models.CASCADE)
      content = models.CharField(max_length=140)
      created_at = models.DateTimeField(auto_now_add=True)
      updated_at = models.DateTimeField(auto_now=True)
      
      class Meta:
          ordering = ('-pk',)
  
      def __str__(self):
          return self.content
  ```

  ```bash
  $ python manage.py makemigrations
  $ python manage.py migrate
  ```

- ModelForm 정의

  ```python
  # articles/forms.py
  
  from .models import Article, Comment
  
  
  class CommentForm(forms.ModelForm):
      
      class Meta:
          model = Comment
          fields = ('content',)
  ```

- admin 정의

  ```python
  # articles/admin.py
  
  from .models import Article, Comment
  
  
  class CommentAdmin(admin.ModelAdmin):
      list_display = ('pk', 'content', 'created_at', 'updated_at',)
  
  admin.site.register(Comment, CommentAdmin)
  ```



### 4.2 CREATE

>[Creating forms from models | Django documentation | Django](https://docs.djangoproject.com/en/2.2/topics/forms/modelforms/#the-save-method)

- `.save(commit=boolean)`

  - default : True
  - django ModelForm 의 save() 메서드는 선택인자로 commit 값을 작성할 수 있다.
  - `commit=False`와 함께 호출하면 **아직 DB 에 저장되지 않은 객체를 반환**한다.
  - 객체를 최종 저장하기 전에 값을 추가/변경하거나 특수하게 모델 저장 옵션 중 하나를 추가적으로 사용하려는 경우에 사용한다.

  ```python
  # articles/views.py
  
  from .models import Article, Comment
  from .forms import ArticleForm, CommentForm
  
  
  def detail(request, article_pk):
      article = get_object_or_404(Article, pk=article_pk)
      comment_form = CommentForm() # comment form 추가
      context = {'article': article, 'comment_form': comment_form,}
      return render(request, 'articles/detail.html', context)
  
  ...
  
  def comments_create(request, article_pk):
      if request.method == 'POST':
          comment_form = CommentForm(request.POST)
          if comment_form.is_valid():
              # Create, but don't save the new comment instance.
              comment = comment_form.save(commit=False)
              comment.article_id = article_pk
              comment.save()
      return redirect('articles:detail', article_pk)
  ```

  ```python
  # articles/urls.py
  
  urlpatterns = [
      ...,
      path('<int:article_pk>/comments/', views.comments_create, name='comments_create'),
  ]
  ```

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
    <hr>
    <form action="{% url 'articles:comments_create' article.pk %}" method="POST">
      {% csrf_token %}
      {{ comment_form }}
      <input type="submit" value="submit">
    </form>
    <hr>
    <a href="{% url 'articles:index' %}">[back]</a>
  {% endblock %}
  ```

  - 댓글 작성 후 admin 에서 확인



### 4.3 READ

```python
# articles/views.py

def detail(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    comments = article.comment_set.all() # 작성
    comment_form = CommentForm()
    context = {'article': article, 'comment_form': comment_form, 'comments': comments,}
    return render(request, 'articles/detail.html', context)
```

```django
<!-- articles/detail.html -->

{% extends 'articles/base.html' %}
{% block content %}
  ...
    <input type="submit" value="DELETE">
  </form>
  <hr>
  <p>댓글 목록</p>
  {% for comment in comments %}
    <p>댓글 {{ forloop.revcounter }} : {{ comment.content }}</p>
  {% empty %}
    <p><b>댓글이 없습니다.</b></p>
  {% endfor %}
  <hr>
  ...
{% endblock %}
```



### 4.4 DELETE

```python
# articles/views.py

def comments_delete(request, article_pk, comment_pk):
    if request.method == 'POST':
        comment = get_object_or_404(Comment, pk=comment_pk)
        comment.delete()
    return redirect('articles:detail', article_pk)
```

```python
# articles/urls.py

urlpatterns = [
    ...,
    path('<int:article_pk>/comments/<int:comment_pk>/delete/', views.comments_delete, name='comments_delete'),
]
```

```django
<!-- articles/detail.html -->

{% extends 'articles/base.html' %}
{% block content %}
  ...
  <p>댓글 목록</p>
  {% for comment in comments %}
    <div>
      댓글 {{ forloop.revcounter }} : {{ comment.content }}
      <form action="{% url 'articles:comments_delete' article.pk comment.pk %}" method="POST" style="display: inline;">
        {% csrf_token %}
        <input type="submit" value="DELETE">
      </form>
    </div>
  {% empty %}
    <p><b>댓글이 없습니다.</b></p>
  {% endfor %}
  ...
{% endblock %}
```



------



## 05. View decorators

> [View decorators | Django documentation | Django](https://docs.djangoproject.com/en/2.2/topics/http/decorators/#module-django.views.decorators.http)
>
> [405 Method Not Allowed](https://developer.mozilla.org/ko/docs/Web/HTTP/Status/405)

### 5.1 require_POST()

`require_POST()`

- view 가 POST 메서드만 요청만 승인하도록 하는 데코레이터

- 일치하지 않는 메서드 요청이라면 `405 Method Not Allowed`에러를 발생

  - 요청 방법이 서버에 의해 알려졌으나, 사용 불가능한 상태

- 데코레이터 예제

  ```python
  def hello(func):
      def wrapper():
          print('HIHI')
          func()
          print('HIHI')
      return wrapper
  
  
  @hello
  def bye():
      print('byebye')
  
  bye()
  ```

  ```python
  # 출력
  
  HIHI
  byebye
  HIHI
  ```

  

**views 변경**

```python
# articles/views.py

from django.views.decorators. http import require_POST


@require_POST
def delete(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    article.delete()
    return redirect('articles:index')


@require_POST
def comments_create(request, article_pk):
    comment_form = CommentForm(request.POST)
    if comment_form.is_valid():
        comment = comment_form.save(commit=False)
        comment.article_id = article_pk
        comment.save()
    return redirect('articles:detail', article_pk)


@require_POST
def comments_delete(request, article_pk, comment_pk):
    comment = get_object_or_404(Comment, pk=comment_pk)
    comment.delete()
    return redirect('articles:detail', article_pk)
```



```bash
$ pip freeze > requirements.txt
```

---





>  HTTP의 특성

- 비연결지향
- 상태정보유지안함 
- 클이언트와의 계속적인 관계 유지를 위해 쿠키와 세션 존재

> 쿠키 - 클라이언트(브라우저)

- 클라이언트의 로컬에 저장되는 키-값의 작은 데이터 파일(일정시간동안만 저장된다)
- 웹페이지 요청시 쿠기값과 함께 전송된다.
- 아이디자동완성, 공지메세지 하루안보기, 팝업체크, 비로그인 장바구니 담기
- 편의를 위한 기능, 유출되어도 큰 문제 없는 경우

> 세션 - 서버

- 로그인 정보유지
- 유지
- 클라이언트가 서버에 접속하면 서버가 특정 `session id` 를 발급하고 클라이언트는 session id 를 쿠키를 사용해 저장한다. 클라이언트가 다시 서버에 접속하면 해당 쿠키(session id 가 저장된)를 이용해 서버에 session id 를 전달한다.
  - 세션을 구별하기 위해 ID가 필요하고 **해당 ID만 쿠키를 이용해 저장**한다. 쿠키는 자동으로 서버에 전송되니 서버에서 session id 에 따른 처리를 할 수 있다.

> 쿠키와 세션

쿠키 :  클라이언트 로컬에 파일로 저장

세션: 서버에 저장(이때 session id는 쿠키의 형태로 클라이언트의 로컬에 저장)



> Sign Up

`Authentication(인증)` → 신원 확인

- 자신이 누구라고 **주장하는 사람의 신원을 확인**하는 것

`Authorization(권한, 허가)` → 권한 부여

- 가고 싶은 곳으로 가도록 혹은 **원하는 정보를 얻도록 허용**하는 과정







```python
# forms.py
# UserChangeForm 수정
from django.contrib.auth.forms import UserChangeForm
class CustomUserChangeForm(UserChangeForm):
  class Meta:
    model = get_user_model()
    fields = ('email', 'first_name', 'last_name', )

    
    
# views.py

from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import AuthenticationForm, PasswordChangeForm
from .forms import CustomUserChangeForm

@login_required
def update(request):
  if request.method == 'POST':
    # POST로 전달받은 데이터
    # 그리고 request한 유저의 모든 정보
    form = CustomUserChangeForm(request.POST, instan=request.user)
    if form.is_valid():
      form.save()
      return redirect('articles:index')
	else:
    ...
    
 
  

```







`user : article = 1 : N`

```python
from django.conf import settings

class Article(models.Model):
  ...
  user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
```



