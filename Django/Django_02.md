[TOC]

# Django_02

## 00. HTML Form Tag

**Form**

- 웹에서 사용자 정보를 입력하는 여러(text, button, checkbox, file, hidden, image, password, radio, reset, submit) 방식을 제공하고, **사용자로부터 할당된 데이터를 서버로 전송하는 역할**을 담당하는 HTML 태그
- form은 한 페이지에서 다른 페이지로 데이터를 전달하기 위해서 사용한다.
- `<form>` 에 2개의 속성(Attribute) 지정 가능
    - **action** —> 입력 데이터가 **전송될 URL** 지정
    - **method** —> 입력 데이터 **전달 방식** 지정

**Input**

- form 태그 중에서 가장 중요한 태그로 **사용자로부터 데이터를 입력 받기 위해** 사용된다.
- input 태그의 속성
    - `id` : 하나의 페이지 안에서 유일**,** Javascript에서 사용하기 위해 쓴다. 
    - `name` : 중복 가능, 폼을 제출했을 때 name이라는 이름에 설정된 값을 넘겨서 값을 가져올 수 있다. 주요 용도는 GET/POST 방식으로 서버에 전달하는 파라미터(name 은 key , value 는 value)로 `?key=value&key=value` 형태로 전달된다.

**label**

- 폼의 양식에 이름을 붙이는 태그 —> 입력 양식(input, button, textarea) 등을 설명하는 이름표
- 주요 속성은 `for` 이고 label 태그와 입력 양식(input, button 등)을 연결할 때 사용한다. 연결한 입력 양식창(input, button)의 id를 사용하여 연결한다.



---



## 01. HTML Form  - GET

### 1.1 기본 개념

- 요청의 종류 중 GET 요청은 서버로부터 **정보를 조회**하는 데 사용한다. 데이터를 서버로 전송할 때 body가 아닌 **쿼리 스트링을 통해 전송**한다.
- **서버의 데이터나 상태를 변경 시키지 않아야 하기 때문에 조회(html)를 할 때 사용**한다. 우리는 서버에 요청을 하면 HTML 문서 파일 한 장을 받는데 이때 사용하는 요청의 방식이 GET 방식이다.



**throw & catch**

- `form` 태그의 `action` 속성에 시작과 끝 모두 막아야 한다! (안그러면 주소창에 이상한 url 생김)

- **throw**

    ```python
    # pages/views.py
    
    def throw(request):
        return render(request, 'throw.html')
    ```

    ```python
    # django_intro/urls.py
    
    path('throw/', views.throw),
    ...
    ```

    ```django
    <!--pages/templates/throw.html-->
    
    <form action="/catch/" method="GET">
    		<input type="text" name="message">
    		<input type="submit">
    </form>
    ```

    

- **catch**

    ```python
    # pages/views.py
    
    def catch(request):
        message = request.GET.get('message')
    		context = {'message':message}
        return render(request, 'catch.html', context)
    ```

    ```python
    # django_intros/urls.py
    
    path('catch/', views.catch),
    ...
    ```

    ```django
    <!-- pages/templates/catch.html -->
    
    <h1>너가 던져서 내가 받은건 {{ message }}야!</h1>
    ```

    

> **그래서 대체 `request` 에는 뭐가 들어있는데?**
>
> [Request and response objects | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/request-response/#module-django.http)
>
> ```python
> # pages/views.py
> 
> from pprint import pprint
> 
> def catch(request):
>     pprint(request)
>     pprint(request.scheme)
>     pprint(request.path)
>     pprint(request.method)
>     pprint(request.headers)  # New in Django 2.2
>     pprint(request.META)
>     pprint(request.GET)  # <QueryDict: {'message': ['호호호']}>
> ```
>
> - `request.headers` 를 해서 출력되는 건 크롬에서도 확인 가능하다.
>
> <img width="830" alt="Screen_Shot_2019-08-12_at_5-4e1d837b-2001-416f-ac17-f4f12a6b3ed4 35 01_PM" src="https://user-images.githubusercontent.com/52446416/63155960-a33a4d80-c04e-11e9-96b1-0d00354127c8.png">



### 1.2 GET 실습

**ASCII art**

http://artii.herokuapp.com/

```python
# pages/views.py

def art(request):
    return render(request, 'art.html')
    

def result(request)
    # 1. form 태그로 날린 데이터를 받는다. (GET 방식)
    word = request.GET.get('word')

    # 2. ARTII api로 요청을 보내 응답 결과를 text로 fonts에 저장한다.
    fonts = requests.get('http://artii.herokuapp.com/fonts_list').text
    # fonts --> str

    # 3. fonts(str)를 fonts(list)로 바꾼다.
    fonts = fonts.split('\n')

    # 4. fonts(list)안에 들어있는 요소중 하나를 선택해서 font라는 변수에 저장한다.
    font = random.choice(fonts)

    # 5. 위에서 우리가 만든 word와 font를 가지고 다시 요청을 보내 응답 결과를 result에 저장
    result = requests.get(
        f'http://artii.herokuapp.com/make?text={word}&font={font}'
    ).text

    context = {'result': result}
    return render(request, 'result.html', context)
```

```python
# django_intro/urls.py

path('result/', views.result),
path('art/', views.art),
...
```

```django
<!-- pages/templates/art.html -->

<h1>ASCII ART에 오신걸 환영합니다. ^---------^</h1>
    
<form action="/result/">
    영단어를 입력해주세요: <input type="text" name="word">
    <input type="submit" value="던지기">
</form>


<!-- pages/templates/result.html -->

<h1>ASCII ARTII</h1>
<pre>{{ result }}</pre>
```



----



## 02. HTML Form - POST

### 2.1 기본 개념

> **csrf_token**
>
> - **사이트 간 요청 위조(CSRF)**
>
>   - 웹 애플리케이션 취약점 중 하나로 **사용자가 자신의 의지와 무관하게 공격자가 의도한 행동을 하여 특정 웹페이지를 보안에 취약하게 한다거나 수정, 삭제 등의 작업을 하게 만드는 공격 방법**을 의미한다.
>   - `{% csrf_token %}`을 설정하면 input type hidden 으로 특정한 hash 값이 담겨있는 것을 볼 수 있다.
>
> - `{% csrf_token %}`이 없으면 403 에러가 발생 → 누군가 요청을 보내 내 DB 안에 있는 글/댓글 등을 삭제하는 것을 막기 위해서! 이러한 토큰이 있는 사람이 요청을 보냈을 때에만 요청을 처리해 응답(삭제/수정등)을 할 수 있도록 한다.
>
>   - `403 forbidden`에러: **서버에 요청은 도달했으나 서버가 접근을 거부**할 때 **반환하는 HTTP 응답 코드 / 오류 코드**. 이 에러 메시지는 **서버 자체 또는 서버에 있는 파일에 접근할 권한이 없을 경우**에 발생.
>   - 이러한 접근을 할 수 있도록 하는 것이 `{% csrf_token %}`→ 사내 인트라넷 서버를 사내가 아닌 밖에서 접속하려고 할 때도 해당 HTTP 응답 코드가 뜬다.
>
> - 해당 csrf attack 보안과 관련된 설정은 `settings.py`에서 `MIDDLEWARE`에 되어있음
>
>   - `settings.py`
>
>     ```python
>     MIDDLEWARE = [
>     	'django.middleware.security.SecurityMiddleware',
>     	'django.contrib.sessions.middleware.SessionMiddleware',
>     	'django.middleware.common.CommonMiddleware',
>     	'django.middleware.csrf.CsrfViewMiddleware', # 이곳
>     	'django.contrib.auth.middleware.AuthenticationMiddleware',
>     	'django.contrib.messages.middleware.MessageMiddleware',
>     	'django.middleware.clickjacking.XFrameOptionsMiddleware',
>     ]
>     ```
>
> - 실제로 **요청 과정에서 urls.py 이전에 Middleware의 설정 사항들을 순차적으로 거친다.** 응답은 아래에서 위로부터 미들웨어를 적용시킨다.
>
>   - 4번째 줄에 있는 **csrf 를 주석 처리하면 토큰이 없어도 POST 요청이 가능**

- POST 요청은 리소스를 생성/변경하기 위해 데이터를 HTTP body에 담아 전송한다.
- 서버의 데이터나 상태를 변경 시키기 때문에 동일한 요청을 여러 번 전송해도 응답의 결과는 다를 수 있다.
    - 데이터가 생성/수정/삭제 되기 때문!
- 원칙적으로 POST 요청을 html 파일로 응답하면 안된다. 

- **왜 POST 요청일 때 `{% csrf_token %}` 을 사용하는가?**
    - GET 요청은 DB에서 데이터를 꺼내는 것! (DB에 변화를 주는 게 아님!)
    - POST 요청은 DB에 조작(생성/수정/삭제)를 하는 것 (DB에 변화를 준다)
    - 즉, **GET**은 누가 요청해도 어차피 정보를 조회(HTML 파일을 얻는 것)하기 때문에 문제가 되지 않는다. **POST**는 DB에 조작이 가해지기 때문에 요청자에 대한 최소한의 검증을 하지 않으면 아무나 DB에 접근해서 데이터에 조작을 가할 수 있다.
    - `csrf_token`을 통해서 요청자의 최소한의 신원확인을 한다.

1. 기본 

    - **user_new**
      
      ```python
      # pages/views.py
      
      def user_new(request):
          return render(request, 'user_new.html')
      ```
      
      ```python
      # pages/urls.py
      
      path('user_new/', views.user_new),
      ...
      ```
      
      ```django
      <!--django_intro/templates/user_new.html-->
      
      <form action="/user_create/" method="POST">
          {% csrf_token %}
          이름: <input type="text" name="name">
          패스워드: <input type="password" name="pwd">
          <input type="submit" value="Submit">
      </form>
      ```
    - **user_create**
      
      ```python
      # pages/views.py
      
      def user_create(request):
          # print(request.POST)
          name = request.POST.get('name')
          pwd = request.POST.get('pwd')
      		context = {'name': name, 'pwd': pwd}
          return render(request, 'user_create.html', context)
      ```
      
      ```python
      # django_intro/urls.py
      
      path('user_create/', views.user_create),
      ...
      ```
      
      ```django
      <!-- django_intro/templates/user_create.html -->
      
      <p>이름: {{ name }}</p>
      <p>패스워드: {{ pwd }}</p>
      ```
      
      

---



## 03. 정적 파일 (static)

### 3.1 기본 개념

- static(정적)파일이란 웹 사이트의 구성 요소 중에서 image, css, js 파일과 같이 해당 내용이 고정되어 **응답을 할 때 별도의 처리 없이 파일 내용을 그대로 보여주면 되는 파일**

- 이미지 필드 없이(DB에 저장된 상태로 로드하게 아니라면) 이미지 파일을 로드하는 경우 이미지 파일에 대한 주소가 없기 때문에 `{% load static %}` 을 통해 주소를 만들어 준다.
  
    - 서버에 저장한 상태에서 사용자의 요청이 들어올 때 image를 제공하는 경우는 해당 이미지에 대한 주소 값이 지정되어 있다.
    
- 이미지도 **주소가 있어야 Django 이미지를 찾아 로드해서 보여줄 수 있다.**
  
- Django 가 아무렇게나 이미지 파일을 보여주는 것이 아니라 해당 주소 값을 읽어 이미지 파일을 보여준다.
  
    ```python
    # pages/views.py
    
    def static_example(request):
        return render(request, 'static_example.html')
    ```
    
    ```python
    # django_intro/urls.py
    
    path('static_example/', views.static_example),
    ...
    ```
    
    - `{% load static %}` 태그를 통해 이미지에 대한 주소를 생성한다.
    - 기본적으로 Django는  `static` 태그를 통해 정적 파일을 로드할 때는 각 app의 `static` 폴더를 찾는다!
    
    ```django
    <!--pages/templates/static_example.html-->
    
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
    
    - pages 앱에 templates 와 동일한 위치에 static 폴더 생성후 이미지 파일 및 css 파일 넣기
    
    - `static/images/simpson.jpg`
    
    - `static/stylesheets/style.css`
    
      ```css
      /* stylesheets/style.css */
      
      h1 {
        color: blue;
      }
      ```
    
    

---



## 04. URL 로직 분리

### 4.1 기본 개념

**두번째 app 생성 및 등록**

```bash
# 03_django/00_django_intro 폴더 내에서 진행

$ python manage.py startapp utilities
```

```python
INSTALLED_APPS = [
	'utilities.apps.UtilitiesConfig',
	...
]
```



**각각의 app 폴더에  `[urls.py](http://urls.py)` 생성 및 설정**

- `pages/urls.py` & `utilities/urls.py` 각각 생성 후 url 정의
- [https://docs.djangoproject.com/en/2.2/internals/contributing/writing-code/coding-style/#imports](https://docs.djangoproject.com/en/2.2/internals/contributing/writing-code/coding-style/#imports)

```python
# pages/urls.py

from django.urls import path
from . import views # relative imports for local components.

urlpatterns = [ 
		# 실제 앱의 url 등록은 아래로!
    path('static_example/', views.static_example),
    path('user_create/', views.user_create),
    path('user_new/', views.user_new),
    path('result/', views.result),
    ...
]
```



**프로젝트 폴더 `urls.py` 설정**

- `django_intro` 프로젝트 폴더의 `urls.py` 를 보자. 너무 주소가 많고 지저분하다.

- 그래서 우리는 app 마다 url 설정을 따로 할 것이다.

    ```python
    # django_intro/urls.py
    
    from django.urls import path, include
    
    urlpatterns = [
        path('utilities/', include('utilities.urls'),
        path('pages/', include('pages.urls')), 
        path('admin/', admin.site.urls),
    ]
    ```
    
    

**요청의 변화**

- 이제는 `/pages/dinner/` 와 같은 형태로 요청을 보내야 한다.
  
    - 프로젝트 폴더의 `urls.py` 에서 확인 후 나머지 부분은 `pages` 의 `urls.py` 에서 확인한다.
- 정상적으로 동작 하는지 확인 해보자! form이 아닌 html 파일은 문제가 없지만 form 태그를 작성해서 action 속성을 지정한 경우 문제가 생긴다.
- form의 경로도 전부 `/pages/경로/` 형태로 수정하자.
  
    - `art`, `lottery`, `throw`,  의 action 앞에 `/pages` 추가해야한다!
    
    

---



## 05. Django Namespace

### 5.1 기본 개념

- utilities 에 `templates` 폴더 생성 후 `index.html` 파일 생성

    ```python
    # utilities/views.py
    
    def index(request):
        return render(request, 'index.html')
    ```
    
    ```python
    # utilities/urls.py
    
    from django.urls import path
    from . import views
    
    urlpatterns = [
        path('', views.index),
    ]
    ```
    
    ```django
    <!--utilities/templates/index.html-->
    
    <!DOCTYPE html>
    <html lang="en">
    <head>
        ...
    </head>
    <body>
      <h1>두번째 장고 실습</h1>
    </body>
    </html>
    ```


​    

**이름 공간(namespace) 문제**

- `utilities/` 로 요청을 보내면 기존의 `utilities`  앱 내의 `index.html` 파일이 렌더된다.

- 하지만 `pages/index` 로 요청을 보내보면 기존의 `pages` 앱 내의 `index.html` 파일이 아닌 방금 나온 `utilities` 앱의 `index.html` 파일이 보인다.

- Django는 기본적으로 templates 파일들을 **한 곳에 모아** 특정 html 파일의 이름을 찾는데, 그 순서가 **`INSTALLED_APPS`에 등록한 순서대로이다. (static 도 마찬가지)**

- 순서를 pages 앱이 위에 있도록 바꾸면 `pages` 의 index.html이 렌더되는 것을 볼 수 있다. (다시 원래대로 돌리기)

- 이를 해결하기 위해 template의 폴더 구조를 `app_name/templates/app_name` 형태로 변경해 이름 공간을 분리한다.
  
- pages와 utilities의 `templates`, `static` 폴더 안의 모든 구조를 변경
  
- 이렇게만 수정하면 template을 찾을 수 없다는 에러가 나온다.

- Django는 기본적으로 앱 내의 `templates` 폴더만 찾는다.
    - 렌더 할 파일의 위치가 달라졌으니 `views.py` 를 수정해야 한다.
    - 모든 html 파일 앞에 `pages` 와 `utilities` 를 붙여주자!
    - utilities, pages에 해당하는 `index.html` 이 정상적으로 렌더 되는지 확인하기

    ```python
    # pages/views.py 
    
    return render(request, 'pages/index.html')
    
    ... 
    ```
    
    ```django
    <!-- templates/pages/static_example.html -->
    
    <img src="{% static 'pages/images/audrey.jpg' %}" alt="static_img">
    ```
    
    ```python
    # utilities/views.py
    
    return render(request, 'utilities/index.html')
    ```
    
    

---



## 06. Template Inheritance

https://docs.djangoproject.com/ko/2.2/misc/design-philosophies/#don-t-repeat-yourself-dry

### 6.1 기본 개념

- 상속은 기본적으로 코드의 **재사용성에 초점**을 맞춘다. 
- 반복되는 코드는 줄이는 것은 코드를 작성하는 사람의 기본이다.
- 기본적으로 `base.html` 이라는 파일에 모든 템플릿에서 사용할 기본 component 를 포함시킨다.

### 6.2 템플릿 상속

- `base.html` 파일을 `django_intro/templates/base.html` 에 생성 해보자.

- Django는 기본적으로 `app_name/templates` 를 바라보게 설정되어있다.
- 우리가 옮긴 위치는 `project폴더(django_intro)/templates` 이므로, Django는 현재 상태에서 해당 template 파일을 찾을 수 없다.
- 각 앱 내의 `templates` 폴더가 아닌 임의의 위치에 있는 template을 읽기 위해서는 Django에서 그 위치를 알려줘야 한다!

- `{% block 이름 %}`  - `{% endblock %}` 의 형태로 작성 후, 상속을 받는 `.html` 파일의 상단에 `{% extends 'base.html' %}`  이라고 작성

### 6.3 템플릿 상속 실습

**템플릿 상속을 위한 기본 세팅**

- `django_intro` 에서 `templates` 폴더 만든 후에 `base.html` 파일 생성

    ```django
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
    # django_intro/settings.py
    
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
    - `APP_DIRS`: True : INSTALLED_APPS 에 설정된 app 디렉토리에 있는 templates 를 템플릿으로 활용한다. (이게 Default가 True라 우리가 app의 template 안에 .html 을 두면 장고가 읽을 수 있었던거!)



우리가 지금까지 작성했던 모든 html 파일에 프로젝트 폴더에 있는 `base.html` 을 상속받아 보자.

- 실제로 모든 반복되는 코드를 (`!+ tab` )를 하나에 몰아 두고 최대한 반복을 줄일 수 있다.

    ```django
    <!-- 예시 django_intro/templates/base.html-->
    
    <!DOCTYPE html>
    <html lang="ko">
    
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Document</title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.0/css/bootstrap.min.css"
        integrity="sha384-PDle/QlgIONtM1aqA2Qemk5gPOE7wFq8+Em+G/hmo5Iq0CCmYZLv3fVRDJ4MMwEA" crossorigin="anonymous">
      {% block css %}
      {% endblock %}
    </head>
    
    ...
    ```

    ```django
    <!-- 예시 templates/pages/static_example.html-->
    
    {% extends 'base.html' %}
    {% load static %}
    
    {% block css %}
    <link rel="stylesheet" href="{% static 'pages/stylesheets/style.css' %}">
    {% endblock %}
    
    {% block content %}
    <h1>static</h1>
    <img src="{% static 'pages/images/audrey.jpg' %}" alt="static_img">
    {% endblock  %}
    ```

    - **`{% extends '' %}` 는 반드시 문서 최상단에 위치해야 한다.**



---



## 7. 개발환경 관리

https://pip.pypa.io/en/stable/reference/pip_freeze/

개발환경이 바뀌었을 때 일일이 패키지를 설치해줘야 하거나, 협업을 하게 됐을 때 개발중인 환경을 같이 넘겨줘야할 때가 있다.

이를 위해 개발환경을 기록하고 한번에 설치하기 위한 방법이 있다.

- 개발환경 저장

  ```bash
  $ pip freeze > requirements.txt
  ```

- 개발환경 설치

  ```bash
  $ pip install -r requirements.txt
  ```

`requirements.txt` 에 있는 내용을 가지고 자동으로 패키지를 설치해줌으로써 해당 프로젝트가 어떤 버전의 패키지를 썼는지 기억하지 않아도 개발환경을 설정 할 수 있다. 

github 에서 프로젝트를 받게되는 사람도 해당 파일이 있으면 가상환경 하나 만든 후 바로 설치가 가능하다.

**python 버전은 README 에 명시하는 것이 좋다.**

















