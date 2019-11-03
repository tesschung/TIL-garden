[TOC]

# Django_01

>**vscode setting for django**
>
>1. [install django extension ](https://github.com/vscode-django/vscode-django)
>
>2. `f1` - `Preferences: Open Settings(JSON)`
>
>   ```JSON
>   // settings.json
>   
>   "files.associations": {
>       "**/*.html": "html",
>       "**/templates/**/*.html": "django-html",
>       "**/templates/**/*": "django-txt",
>       "**/requirements{/**,*}.{txt,in}": "pip-requirements"
>   },
>   
>   "emmet.includeLanguages": {
>       "django-html": "html"
>   },
>   
>   "[django-html]": {
>       "editor.tabSize": 2
>   },
>   
>   // beautify
>   "beautify.language": {
>       "js": {
>           "type": ["javascript", "json"],
>           "filename": [".jshintrc", ".jsbeautifyrc"]
>           // "ext": ["js", "json"]
>           // ^^ to set extensions to be beautified using the javascript beautifier
>       },
>       "css": ["css", "scss"],
>       "html": ["htm", "html", "django-html"]
>       // ^^ providing just an array sets the VS Code file type
>   },
>   ```
>
>[DJANGO 디자인 철학](https://docs.djangoproject.com/en/2.2/misc/design-philosophies/)

----

## 00. Django Intro

### 0.1 폴더 구조 및 가상 환경 setting

**Why 가상환경?**

[Python 가상환경 venv 간단한 사용법 + 주의사항](https://seolin.tistory.com/96)

- 어떠한 프로그램을 만들 때, 보통은 독자적으로 파이썬의 순서한 고유 라이브러리만 써서 만들기도 하지만, 다른 사람이 개발한 라이브러리를 포함해서 사용하기도 한다. 즉, 의존성이 발생한다.

- 의존성 때문에, 본인의 컴퓨터에서 잘 작동하던 프로그램도, 다른 프로그램에 설치했을 때 잘 돌아가리라는 보장을 할 수 없음

- 파이썬의 경우도 같은 파이썬 버전, 똑같은 모듈 버전을 쓴다는 보장이 없다.

- 특정 프로그램만을 실행하기 위한 파이썬 환경을 따로 만들어서, 그 환경 속에서만 모듈을 관리하고, 앱을 실행 시켰다가, 다른 앱을 실행할 일이 생기면 그 가상 환경을 빠져 나오는 방식을 선택한다.

- 과거에는 가상환경을 파이썬 자체적으로 제공하지 않아서 별도의 패키지를 설치해야 했다.(`virtualenv`) 버전 3.5 이후부터는 파이썬에 `venv` 라는 이름으로 가상환경 모듈을 지원한다.

- 윈도우, 리눅스, 맥 구분없이 가상환경을 생성하는 방법은 동일
    
    - 윈도우는 `Scripts` 폴더 생성
    
- 리눅스, 맥은 `bin` 폴더 생성
  
    ```bash
    # path/to/venv 에 가상환경 구성하고 싶은 경로를 적으면 된다. 
    # 해당하는 폴더가 존재하지 않으면 파이썬이 알아서 가상환경 생성해 구성\
    # 만약에 파이썬이 한 PC에 여러 종류 설치되어 있으면, 해당 파이썬이 존재하는 절대 경로를 입력해서 설치
    
    $ python -m venv /path/to/venv
    ```
    
- `.gitignore` django  & vscode 설정

    ```
    TIL/
    	00_startCamp
    	01_python
    	02_web
    	03_django
    		00_django_intro
    		.gitignore
    ```



**가상 환경 참고 사항**

- **사정상(대전2반) 3.7을 사용하려면 일단 사용자 환경변수에서 37 을 35 위로 올리자.**

- 가상 환경 실행은 `venv` 파일이 존재하는 곳에서 한다.

- 가상 환경 생성 할 때 생성하는 폴더 이름인 `venv` 는 중복 되도 상관없다. 새로이 가상 환경을 생성하고 싶은 폴더로 이동해서 아래의 로직을 수행하면 된다.

    ```bash
    # 1. 가상 환경 생성
    $ python -m venv venv
    
    # 2. 가상 환경 활성화
    $ source venv/Scripts/activate
    
    # 3. 가상환경 비활성화(어느 곳이든 관계 없음)
    $ deactivate
    ```

    - 가상 환경 `deactivate` 의 경우 위치에 상관없이 가능하다.



**가상 환경 on/off**

- git bash 에서 활성화 (가상 환경 설정 폴더 안에서 진행)
    
    - vs code를 새로 켜지 않으면 activate 된 해당 터미널은 해당 가상환경으로 계속 잡혀있음
    
- 터미널을 어떤 걸로 켜든 새로 켜면 무조건 글로벌이고 가상 환경을 activate를 하면 가상 환경을 잡는다.
  
    ```bash
    # TIL/03_django/00_django_intro
    
    $ source venv/Scripts/activate
    
    $ pip list # 찍어보고 아무것도 없는거 보여주기
    $ pip list # deactivate 하고나서 방금전과 비교
    ```
    
- 비활성화 (위치 상관없이)

    ```bash
    $ deactivate
    ```

- vscode intergrate 터미널
    - `f1 `- `Python: Select Interpreter` - 해당 `venv` 선택 - 터미널 on/off (휴지통)
        - vscode 왼쪽 하단 버튼을 눌러도 된다.
    - 이제 켤 때마다 계속 자동으로 설정한 가상 환경을 activate 해준다.
    - 끄고 싶다면 `deactivate`
    - **반드시 반드시 가상환경을 켜고 마지막에 vscode terminal 을 켠다.**
    - 항상 현재 가상환경인지 `pip list` 를 통해 확인한다.



### 0.2 django 설치 및 실행

**django 설치**

- `venv` 가상환경 activate 후 설치 진행

- Django version `2.2.4` 로 설치됨 (2019.08.16 기준)

    ```bash
    $ pip install django
    
    # 특정 버전 설치시
    $ pip install Django==2.2.4
    
    # 설치된 django 버전 확인
    $ python -m django --version
    ```
    
    

**django project 생성**

- 가장 뒤에 `.` 유의! 저 `.`은 현재 폴더를 의미하며 현재 프로젝트에서 Django  프로젝트를 시작하겠다는 의미.

- Django 프로젝트 생성 시, django나 python에서 이미 사용 중인 이름은 피해야 한다.

- `-` 도 사용할 수 없음

    ```bash
    $ django-admin startproject djago_intro .
    ```
    
    

**서버 실행**

```bash
# manage.py 가 있는 곳에서 진행

$ python manage.py runserver
```

- `http://127.0.0.1:8000`으로 접속해 보면, 역동적인 로켓이 우리를 반겨준다.(`localhost:8000` 과 같은 주소)

    

**서버 종료**

- `ctrl + c`

> 서버 already in use 상황이 발생 한다면,
>
> ```bash
> $ netstat -ano | findstr 8000
> 
> $ taskkill /F /PID 해당pid번호
> ```



### 0.3 Project 폴더 구조

- `__init__.py`
    - 빈 파일입니다. 이 파일은 Python에게 이 디렉토리를 하나의 Python 패키지로 다루도록 지시합니다.
    - 우리가 직접 다룰 일은 없음
- `settings.py`
    - 웹사이트의 모든 설정을 포함. 이 곳에는 우리가 만드는 어떤 application이라도 등록이 되는 곳이며, static files의 위치, database 세부 설정 등이 들어감.
    - 즉, Django project 내의 모든 환경이 저장된 파일
- `urls.py`
    - 사이트의 url와 뷰의 연결을 지정해줍니다. 여기에는 모든 url 매핑 코드가 포함될 수 있지만, 특정한 어플리케이션에 매핑의 일부를 할당 해주는 것이 일반적입니다.
- `wsgi.py`
    - Web Server Gateway Interface
    - 파이썬 웹 프레임 워크에서 사용하는 웹 서버 규칙
    - (지금 당장 사용되지는 않고, 나중에 서버에 배포할 때 사용하게 되는 파일! 정도로만 설명)
- [`manage.py`](http://manage.py)
    - django 프로젝트와 다양한 방법으로 상호 작용하는 커맨드라인 유틸리티



### 0.4 Application 생성

- 실제로 어떠한 **역할(기능)**을 해주는 친구가 app.

- 아까 만든 프로젝트는 이러한 어플리케이션의 집합이고, 실제 요청을 처리하고 페이지를 보여주고 하는 것들은 이 어플리케이션의 역할.

- 하나의 프로젝트는 여러 개의 어플리케이션을 가질 수 있다.
    - 어플리케이션은 하나의 **역할 및 기능 단위로 쪼개는 것이 일반적**.
    - 그러나 작은 규모의 서비스에서는 잘 나누지 않는다.
    - 반드시 이렇게 나눠야 한다 같은 기준 또한 없다.
    
- app 이름은 되도록 **복수형**으로 만든다.

    ```bash
    $ python manage.py startapp pages
    ```

    

### 0.5 Application 폴더 구조

- `admin.py`
    - 관리자용 페이지 커스텀마이징 하는 곳.
- `apps.py`
    - 앱의 정보가 있는 곳. 일단, 우리는 수정할 일이 없다.
- `models.py`
    - 앱에서 사용하는 Model(Database)를 정의하는 곳.
- `tests.py`
    - 테스트 코드를 작성하는 곳. 우리가 우선 수정할 일 없다.
- `views.py`
    - 뷰들이 정의 되는 곳. 뷰를 간단하게 설명하면 우리가 보게 되는 페이지를 이야기 한다.
    - 사용자의 요청이 들어왔을 때 어떤 데이터를 보여줄 지 정의하는 곳.
    - flask에서 페이지 마다 정의 했었던 함수들이 여기에 작성된다.
    - 우리가 flask에서 `app.py` 에 작성한 코드는 Django에서 `urls.py` 와 `views.py` 로 쪼개진다.



### 0.6 Application 등록

- 방금 생성한 application을 사용하려면 장고 프로젝트한테, 우리가 이런 앱을 만들었어! 라고 알려주어야 사용 가능하다.
  
    - 공식문서에 맞게 **INSTALLED_APPS 및 project url은 상단에 추가, app url 은 하단으로 추가한다.**
- `pages > apps.py > class PagesConfig` 의 구조라서, `pages.apps.PagesConfig`로 작성을 한다. (모듈)
  
    > ` pages` 라고만 작성해도 된다.

> **trailing comma** 
>
> - 리스트형 데이터를 표현할 때 붙이는 Comma
>
> - 실수 방지와 Git과 같은 VCS을 통한 소스 코드 관리에서의 편의성을 위해 사용
>
> **INSTALLED_APPS 에 작성하는 app order**
>
> ```python
> INSTALLED_APPS = [
>     # Local apps
>     'blogs.apps.BlogsConfig',
> 
>     # Third party apps
>     'haystack',
> 
>     # Django apps
>     'django.contrib.admin',
>     'django.contrib.auth',
>     'django.contrib.contenttypes',
>     'django.contrib.sessions',
>     'django.contrib.sites',
> ]
> ```
>
> - This is important when overriding templates, static files, management commands and translations. Your local app should take precedence.
> - https://docs.djangoproject.com/ko/2.2/ref/settings/#installed-apps



### 0.7 추가 설정

- LANGUAGE_CODE

    ```python
    # setting.py
    
    LANGUAGE_CODE = 'ko-kr'
    ```

- TIME_ZONE
  
  ```python
  # setting.py
  
  TIME_ZONE = 'Asia/Seoul'
  ```
  
  - [https://en.wikipedia.org/wiki/List_of_tz_database_time_zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

- 새로고침해서 터미널에 시간이 바뀌고 한글화가 되었는지 확인해보자.

- 이제 페이지를 만들 준비가 다 되었다.



### 0.8 MTV 패턴

<img width="603" alt="Screen Shot 2019-08-16 at 5 12 18 PM" src="https://user-images.githubusercontent.com/52446416/63153329-045f2280-c049-11e9-8645-96a450873646.png">

Django에서는 Model, Template(View), View(Controller) 라고 부르는데 실제로는 MVC 패턴이다.

- Model
- Template(View) : Interface (html) - 사용자에게 어떻게 데이터가 보여질 지 정의
- View(Controller) : Logic - 어떤 데이터를 보여줄 지 정의



**Django에서 `.py` 3대장**

- `models.py` : 데이터베이스 관리

- `views.py` : 페이지 관리 (페이지 하나 당, 하나의 함수)

- `urls.py` : 주소(URL) 관리

- flask에서는 app.py 하나에서 다 했던 걸, 여기서는 나눠서 한다.

    <img width="753" alt="img_01-6dcda166-f486-488a-a11e-724dca5cbf5b" src="https://user-images.githubusercontent.com/52446416/63153229-c82bc200-c048-11e9-92b0-18352f088c56.png">
    
    

---



## 01. Django request - response

### 1.1 기본 개념

**`views.py`**

- view는 중간 관리자다.

- 여기서 우리가 접속해서 볼 페이지를 작성을 한다. 그 하나하나의 페이지를 view라고 부르자.

- `urls.py` 에서 요청에 맞게 해당 view를 실행시키면 이곳에서 DB등을 처리하고 최종적으로 사용자에게 무언가를 보여준다.

    ```python
    # pages/views.py
    
    def index(request): # 첫번째 인자는 반드시 request
    		return render(request, 'index.html') # render의 첫번째 인자도 반드시 request
    ```



**`urls.py`**

- 집배원 같은 역할을 함.

- 장고 서버로 요청(request)이 들어오면, 그 요청이 어디로 가야하는지 인식하고 관련된 함수(view)로 넘겨줌.

- `INSTALLED_APPS`에 등록된 앱을 위에서부터 하나씩 검사 하면서 찾기 때문에, 순서가 중요함. 아직은 이 순서 때문에 잘못 페이지 부르는 일이 발생하지 않지만, 나중에 복잡한 페이지 만들면 이 순서가 중요해진다.

- 거의 모든 상황에서 `views.py`와 함께 작성된다.

- `views.py` 만든 함수를 연결시켜준다.

    ```python
    # django_intro/urls.py
    
    from django.contrib import admin
    from django.urls import path 
    from pages import views  # 생성한 앱 pages 폴더 안의 views.py 파일
    
    urlpatterns = [
    		path('index/', views.index), # url 경로 마지막에 /를 붙이는 습관
        path('admin/', admin.site.urls), 
    ]
    ```



**`Templates`**

- `views.py`에서 지정한 `index.html` 파일을 만들자.

- Django에서 template이라고 부르는 HTML 파일은 기본적으로 app 폴더안의 `templates` 폴더 안에 위치한다.

- 지금 상황에서는 `pages > templates`의 구조를 가지게 된다.

- 우리가 `views.py`에서 `render(request, 'index.html')`이라고, 'index.html을 render하겠다' 라는 코드를 작성하게 되면, Django는 app 폴더 안의 templates 폴더 안에 있는 html 파일들 중에서 `index.html` 파일을 찾아 화면에 보여주게 된다.

- 폴더 구조 및 마크업 (이후 서버 실행)

    ```html
    <!-- pages/templates/index.html -->
    <h1>Hi django!</h1>
    ```



**앞으로의 코드 작성 순서**

- views.py : 만들고자 하는 페이지 view 함수 생성
- urls.py : views.py 에서 만든 함수에 주소 연결
- templates : 해당 함수가 호출 될 때, 보여질 페이지



---



## 02. Django Template

### 2.1 Template Variable

- `render()`를 사용하여 `views.py`에서 정의한 변수를 template 파일로 넘겨 사용
- `render()`의 세번째 인자로 `{'key': value}` 와 같이 딕셔너리를 넘겨줄 수 있다.
- 여기서 정의한 `key`에 해당하는 문자열이 template에서 사용 가능한 변수명이 된다.



`views.py`

> **django imports style guide**
>
> [https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/coding-style/#imports](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/coding-style/#imports)
>
> ```python
> # standard library
> import json
> 
> # third-party
> import bcrypt
> 
> # Django
> from django.http import Http404
> 
> # local Django
> from .models import LogEntry
> ```

```python
# pages/views.py

import random

...

def dinner(request):
    menu = ['족발', '햄버거', '치킨', '초밥']
    pick = random.choice(menu)
    return render(request, 'dinner.html', {'pick': pick})
```

```python
# 위와 같이 render 에 직접 작성해서 넘겨줘도 되지만 넘겨야 할 값이 많아지면 
# context 변수로 넘겨주는 것이 더 좋다.

def dinner(request):
    menu = ['족발', '햄버거', '치킨', '초밥']
    pick = random.choice(menu)
		context = {'pick': pick}
    return render(request, 'dinner.html', context)
```



`urls.py`

```python
# django_intro/urls.py

urlpatterns = [
		path('dinner/', views.dinner),
		...
]
```



`dinner.html`

```django
<!-- pages/templates/dinner.html -->

<h1>오늘 저녁은 {{ pick }}!</h1>
```



**2.1.1 실습 (랜덤 이미지 보여주기)**

lorem picsum 활용

- `views.py`

    ```python
    # pages/views.py
    
    def image(request):
        return render(request, 'image.html')
    ```

- `urls.py`

    ```python
    # django_intro/urls.py
    
    urlpatterns = [
        path('image/', views.image),
    		...
    ]
    ```

- `templates`

    ```html
    <!-- pages/templates/image.html -->
    
    <h1>랜 덤 이 미 지 다</h1>
    <img src="https://picsum.photos/500/500.jpg" alt="random-image">
    ```
    
    

### 2.2 Variable Routing

- 동적 라우팅: **주소 자체를 변수처럼 사용해서 동적으로 주소를 만드는 것.**

- **왜 써야 할까?**
    - `안녕/harry`  `안녕/john` 과 같이 인사하는 함수 작성. 100명의 사람이면? 100개의 html 파일 필요
    
    - 이때 뒤에 들어오는 사람의 이름을 **변수화** 할 수 있다.
    
    - 숫자가 들어온다면? `int()` 함수로 형변환을 시킬 수도 있다.

    - 하지만, `<int:변수이름>` 형태로 바로 형변환을 할 수도 있다.
    
    - default 는 `str` 이다.
    
        ```python
        # pages/views.py
        
        def hello(request, name):
        		context = {'name': name}
        return render(request,'hello.html', context)
        ```
        
        ```python
        # django_intro/urls.py
        
        urlpatterns = [
            # 혹은 path('hello/<name>/', views.hello),
            path('hello/<str:name>/', views.hello),
            ...
        ]
        ```
        
        ```django
        <!-- pages/templates/hello.html -->
        
        <h1>안녕하세요, {{ name }}님!</h1>
        ```
    
    
    ​    
    
- 2개 이상을 넘길 수도 있다.

    ```python
    # pages/views.py
    
    def hello(request, name):
        menu = ['짬뽕', '피자', '탕수육', '초밥']
        pick = random.choice(menu)
        context = {'name': name, 'pick': pick,}
        return render(request,'hello.html', context)
    ```
    
    ```django
    <!-- pages/templates/hello.html -->
    
    <h1>안녕하세요, {{ name }}님!</h1>
    <p>{{ name }}님이 오늘 먹을 메뉴는 {{ pick }}입니다!</p>
    ```
    
    

**당부의 얘기**

- 페이지 이것저것 추가로 만들어 보면서 새로운 페이지를 만들고자 할 때 어떻게 해야 하는지 직접 반복해서 만들어보고 익숙 해지자.
- 장고는 flask 보다 구조가 복잡해서 길을 잃을 수 있다. 어디서 새로운 페이지 만들었는지, 어디서 주소를 설정 하는지, 요청이 들어오면 어떤 파일들을 거치게 되는지 등 잘 기억이 안 날 수 있다.
- 웹 서비스를 제작 하는데 있어 필요한 페이지를 만드는 것은 정말 기본적인 것이라 익숙하게 할 수 있어야 한다.



### 2.3 Variable routing 실습

1. **자기소개(이름, 나이)**

- 앞에서 했던 introduce를 확장

    ```python
    # pages/views.py
    
    def introduce(request, name, age):
        context = {'name': name, 'age': age}
    return render(request, 'introduce.html', context)
    ```
    
    ```python
    # django_intro/urls.py
    
    urlpatterns = [
		path('introduce/<name>/<int:age>/', views.introduce),
    		...
    ]
    ```
    
    ```django
    <!--pages/templates/introduce.html-->
    
    <h1>{{ name }}의 나이는 {{ age }}살 입니다.</h1>
    ```

2. **숫자 2개를 variable routing 으로 받아 곱셈 결과 출력**

   ```python
   # pages/views.py
   
   def times(request, num1, num2):
   	num3 = num1 * num2 
   	context = {'num3': num3, 'num2': num2, 'num1': num1}
   	return render(request, 'times.html', context)
   ```

   ```python
   # django_intro/urls.py
   
   urlpatterns = [
   		path('times/<int:num1>/<int:num2>/', views.times),
   		...
   ]
   ```

   ```django
   <!-- pages/templates/times.html -->
   
   <h1>{{ num1 }}과 {{ num2 }}의 곱셈 결과는 {{ num3 }}입니다.</h1>
   ```

3. **반지름을 인자로 받아 원의 넓이를 구하기**

   ```python
   # pages/views.py
   
   def area(request, r):
       area = (r ** 2) * 3.14
       context = {'r': r, 'area': area}
       return render(request, 'area.html', context)
   ```

   ```python
   # django_intro/urls.py
   
   urlpatterns = [
   		path('area/<int:r>/', views.area),
   		...
   ]
   ```

   ```django
   <!-- pages/templates/area.html -->
   
   <h1>반지름의 길이가 {{ r }} 인 원의 넓이는 {{ area }} 입니다.</h1>
   ```

   

---



## 03. DTL (Django Template Language)

>  참고 링크
>
> https://docs.djangoproject.com/ko/2.2/ref/templates/language/
>
> https://docs.djangoproject.com/ko/2.2/ref/templates/language/

- flask에는 jinja2, django에는 DTL이 있다.
- django template에서 사용하는 내장 template system이다.
- 조건, 반복, 변수 치환, 필터 등의 기능을 제공한다.

### 3.1 기본 개념

- **기본 세팅**

    ```python
    # pages/views.py
    
    from datetime import datetime
    ...
    
    def template_language(request):
        menus = ['짜장면', '탕수육', '짬뽕', '양장피']
        my_sentence = 'Life is short, you need python'
        messages = ['apple', 'banana', 'cucumber', 'mango']
        datetimenow = datetime.now()
        empty_list = []
        context = {
            'menus': menus,
            'my_sentence': my_sentence,
            'messages': messages,
            'empty_list': empty_list,
            'datetimenow': datetimenow,
        }
        return render(request, 'template_language.html', context)
    ```
    
    

1. **반복(for)**

   ```django
   <!-- templates/template_language.html -->
   
   <h3>1. 반복문</h3>
   {% for menu in menus %}
   <p>{{ menu }}</p>
   {% endfor %}
   <hr>
   
   <!-- {{ forloop }}DTL for 문 안에 자동으로 생기는 객체 -->
   {% for menu in menus %}
   <p>{{ forloop.counter }} {{ menu }}</p>
   {% endfor %}
   <hr>
   
   {% for user in empty_list %}
   <p>{{ user }}</p>
   {% empty %}
   <!-- empty: for 태그 안에 optional 하게 있음. 빈리스트일 때 출력됨 -->
   <p>현재 가입한 유저가 없습니다.</p>
   {% endfor %}
   <hr>
   <hr>
   ```

   

2. **조건(if)**

   ```django
   <h3>2. 조건문</h3>
   {% if '짜장면' in menus %}
   <p>짜장면에는 고춧가루지 !</p>
   {% endif %}
   <hr>
   
   {% for menu in menus %}
     <!--for 태그가 반복한 횟수를 출력함 - index가 1부터 시작(0부터는 counter0)-->
     {{ forloop.counter }}번째 도는중..
     <!--forloop.first를 하면 이 for문이 첫번째로 도는거면 True(참)이 된다.-->
     {% if forloop.first %}
     <p>짜장면+고춧가루</p>
     {% else %}
     <p>{{ menu }}</p>
     {% endif %}
   {% endfor %}
   <hr>
   <hr>
   ```

   ```django
   <h3>3. length filter 활용</h3>
   {% for message in messages %}
     {% if message|length > 5 %}
     <p>{{ message }}, 글자가 너무 길어요.</p>
     {% else %}
     <p>{{ message }}, {{ message|length }}</p>
     {% endif %}
   {% endfor%}
   <hr>
   <hr>
   ```

   ```
   <=
   >=
   ==
   !=
   >
   <
   in
   not in
   is 
   모두 가능하다.
   ```

   

3. **lorem**
    - 이미 정의되어 있는 변수 호출이기 때문에 `{% %}` 이다.

        ```django
        <h3>4. lorem ipsum</h3>
        {% lorem %}
        <hr>
        {% lorem 3 w %}
        <hr>
        {% lorem 4 w random %}
        <hr>
        {% lorem 2 p %}
        <hr>
        <hr>
        ```
        
        - 기본 : 글씨
        - w : word
        - p : `<p>` `</p>`, 문단
        - random : 무작위



4. **글자 관련 필터**

- truncate는 자르다 라는 의미를 갖고 있음.

- chars는 `(공백)...` 즉, **4글자(1 char)를 포함한 길이**다.

- `title` : 단어를 대문자로 시작하고 나머지는 소문자로 만들어 문자열 제목으로 변환

- `capfirst` : 값의 첫 번째 문자를 대문자로 바꾼다. (단, 첫번째 문자는 반드시 '문자' 여야 한다)

- `random`: 주어진 리스트에서 요소를 랜덤하게 뽑아냄

    ```django
    <h3>5. 글자수 제한(truncate)</h3>
    <p>{{ my_sentence|truncatewords:3 }}</p> <!-- 단어 단위로 제한 -->
    <p>{{ my_sentence|truncatechars:3 }}</p> <!-- 문자 단위로 제한(3번째는 포함x) -->
    <p>{{ my_sentence|truncatechars:10 }}</p> <!-- 문자 단위로 제한(10번째는 포함x) -->
    <hr>
    <hr>
    ```
    
    ```django
    <h3>6. 글자 관련 필터</h3>
    <p>{{ 'abc'|length }}</p>
    <p>{{ 'ABC'|lower }}</p>
    <p>{{ my_sentence|title }}</p>
    <p>{{ 'abc def'|capfirst }}</p>
    <p>{{ menus|random }}</p>
    <hr>
    <hr>
    ```


​    

5. **연산**

   ```django
   <h3>7. 연산</h3>
   <p>{{ 4|add:6 }}</p>
   <hr>
   <hr>
   ```

   - [django-mathfilters](https://github.com/dbrgn/django-mathfilters) - 더 많은 연산 관련 자료
   - 기본적으로 연산과 같은 처리는 view 에서 최대한 해결하는 것이 좋다.



6. **날짜 표현**

- `{% now %}` 가 내장되어 있다.

- `DATETIME_FORMAT`, `SHORT_DATETIME_FORMAT`, `DATE_FORMAT`, `SHORT_DATE_FORMAT`

    ```django
    <h3>8. 날짜표현</h3>
    {{ datetimenow }}<br>       
    {% now "DATETIME_FORMAT" %}<br>  
    {% now "SHORT_DATETIME_FORMAT" %}<br> 
    {% now "DATE_FORMAT" %}<br>  
    {% now "SHORT_DATE_FORMAT" %} 
    <hr>
    {% now "Y년 m월 d일 (D) h:i" %} 
    <hr>
    {% now "Y" as current_year %}
    Copyright {{ current_year }}
    <hr>
    {{ datetimenow|date:"SHORT_DATE_FORMAT" }} 
    <hr>
    <hr>
    ```



7. **기타**

   ```django
   <h3>9. 기타</h3>
   {{ 'google.com'|urlize }}
   ```

   - 하이퍼 링크 생성

   

### 3.2 실습

- IS IT YOUR BIRTHDAY?

  ```python
  # pages/views.py
  
  def isbirth(request):
      # 1월 10일이면 예, 아니면 아니오
      today = datetime.now()
      if today.month == 1 and today.day == 10:
          result = True
      else:
          result = False
      context = {'result': result}
      return render(request, 'isbirth.html', context)
  ```

  ```python
  # django_intro/urls.py
  
  urlpatterns = [
  		path('isbirth/', views.isbirth),
  		...
  ]
  ```

  ```django
  <!-- templates/isbirth.html -->
  
  {% if result %}
  <h1>예! 오늘은 나의 생일입니다.</h1>
  {% else %}
  <h1>아니오! 오늘은 나의 생일이 아닙니다.</h1>
  {% endif %}
  ```

---



