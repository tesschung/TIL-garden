[TOC]

## 00. Sessions framework 

> 1. HTTP의 대표 특성 
>    - 비연결지향(connectionless) : 서버는 응답하고 접속을 끊음
>    - 상태정보유지안함(stateless, 무상태) : 연결을 끊는 순간 클라이언트 <-> 서버 간의 통신이 끝나며 상태 정보 유지 안함 (클라이언트와 서버 사이의 메시지가 완벽하게 각각 독립적)
>    - 사이트가 클라이언트와 계속적인 관계를 유지하는 것을 위해 쿠키와 세션이 존재한다.
> 2. 쿠키(Cookie) - 클라이언트(브라우저) 
>    - 클라이언트의 로컬에 저장되는 키-값의 작은 데이터 파일(이름, 값, 만료 날짜, 경로 정보). 일정시간 동안 데이터 저장 가능.
>    - 웹페이지에 접속하면 요청한 웹페이지를 받으며 쿠키를 로컬에 저장하고 클라이언트가 재 요청시에 웹페이지 요청과 함께 쿠키 값도 같이 전송
>    - 아이디 자동완성, 공지메세지 하루 안보기, 팝업 체크, 비로그인 장바구니 담기 등 편의를 위하되 지워지거나 유출 되도 큰 일은 없을 정보들을 저장
> 3. 세션(Session) \- 서버 
>    - 사이트와 특정 브라우저 사이의 "state"를 유지시키는 것
>    - 일정 시간동안 같은 브라우저로부터 들어오는 일련의 요구를 하나의 상태로 보고 상태를 유지하는 기술 == 웹 브라우저를 통해 서버에 접속한 이후 브라우저를 종료할 때까지 그 상태가 유지 (ex 로그인 정보 유지에 사용)
>    - 매 브라우저마다 임의의 데이터를 저장하게 하고, 이 데이터가 브라우저에 접속할 때 마다 사이트에서 활용될 수 있도록 한다.
>    - 클라이언트가 서버에 접속하면 서버가 특정 `session id`를 발급하고 클라이언트는 session id 를 쿠키를 사용해 저장한다. 클라이언트가 다시 서버에 접속하면 해당 쿠키(session id 가 저장된)를 이용해 서버에 session id 를 전달한다. 
>      - 세션을 구별하기 위해 ID가 필요하고 **해당 ID만 쿠키를 이용해 저장**한다. 쿠키는 자동으로 서버에 전송되니 서버에서 session id 에 따른 처리를 할 수 있다.
>    - Django 는 특정 session id 를 포함하는 쿠키를 사용해서 각각의 브라우저와 사이트가 연결된 세션을 알아낸다. 실질적인 세션의 data 사이트의 Database에 기본 설정 값으로 저장된다. (이는 쿠키 안에 데이터를 저장하는 것보다 더 보안에 유리하고, 쿠키는 악의적인 사용자에게 취약하기 때문)
>    - 서버는 브라우저에 기한이 짧은 임시 키 하나를 제공해 브라우저에 보내서 쿠키로 저장. 브라우저가 페이지를 돌아다닐 때 사용자의 중요한 정보들은 서버의 메모리나 DB 에 저장. 브라우저가 이 사이트의 페이지들에 접속할 때마다 http 요청에 임시 키를 실어서 전송하고 서버는 그 키를 보고 누구인지를 인식해서 응답을 보내준다.
>    - 쿠키를 지우면 로그아웃 되는건 서버에서는 세션의 사용자의 로그인 정보를 가지고 있지만,  그게 내꺼라는걸 증명할 세션 아이디가 쿠키에서 지워졌기 때문.
>    - 세션을 남발하면 사용자가 많을 때 서버에 부하가 걸린다.
> 4. 차이 
>    - 쿠키: 클라이언트 로컬에 파일로 저장
>    - 세션: 서버에 저장 (이때 session id 는 쿠키의 형태로 클라이언트의 로컬에 저장)
> 5. **캐시**
>    - 가져오는데 비용이 드는 데이터를 한 번 가져온 뒤에는 임시로 저장.
>    - 사용자의 컴퓨터 또는 중간 역할을 하는 서버에 저장

---

- 세션에 대한 사용 설정은 setting.py 에 이미 작성 되어있다. 

  ```python
  # myform/settings.py
  
  INSTALLED_APPS = [
      ...,
      'django.contrib.sessions',
      ...
  ]
  
  MIDDLEWARE = [
      ...,
      'django.contrib.sessions.middleware.SessionMiddleware',
      ...
  ]
  ```

  

**세션 사용하기**

>  https://docs.djangoproject.com/en/2.2/topics/http/sessions/ 

- 반드시 admin 계정으로 admin 페이지에 로그인 된 상태로 진행한다.

- session 을 먼저 개발자도구로 확인 해보자. (개발자 도구 - Application - Cookies)

  <img width="1470" alt="Screen_Shot_2019-09-22_at_8 16 51_PM" src="https://user-images.githubusercontent.com/52446416/67395962-c995df80-f5e1-11e9-9ddb-d8e31ba35ba0.png">

-  `sessio`n 정보는 view 의 인자로 들어가는 `request` 안에 존재한다. 직접 확인해보자. 

  ```python
  # articles/views.py
  
  def index(request):
      embed()
      ...
  ```

  ```python
  In [1]: request.session                                                               
  Out[1]: <django.contrib.sessions.backends.db.SessionStore at 0x106bc8cf8>
  
  In [2]: dir(request.session)                                                          
  Out[2]: 
  [...,
   '_get_session',
   '_get_session_from_db',
   '_get_session_key',
   '_hash',
   '_session',
   '_session_key',
   '_set_session_key',
   '_validate_session_key',
   ...,
   'has_key',
   'is_empty',
   'items',
   'keys',
   'load',
   'model',
   'modified',
   'pop',
   'save',
   'serializer',
   'session_key',
   'set_expiry',
   'set_test_cookie',
   'setdefault',
   'test_cookie_worked',
   'update',
   'values']
  
  In [3]: request.session._session                                                      
  Out[3]: 
  {'_auth_user_id': '1',
   '_auth_user_backend': 'django.contrib.auth.backends.ModelBackend',
   '_auth_user_hash': '5f903669d65e846adfbff9006c88c9cccc0bb2c2'}
  
  In [4]: request.session.items()                                                       
  Out[4]: dict_items([('_auth_user_id', '1'), ('_auth_user_backend', 'django.contrib.auth.backends.ModelBackend'), ('_auth_user_hash', '5f903669d65e846adfbff9006c88c9cccc0bb2c2')])
  
  In [5]: request.session.get('_auth_user_id')
  Out[5]: '1'
  ```

  - `auth_user` 라는 db 테이블의 첫 관리자 계정이라면 위처럼 id 가 1 인 현재 로그인된 관리자 계정의 session 정보를 활용할 수 있다.
  - 이 session 정보를 계속해서 서버로 보내기 때문에, 우리는 현재 django 사이트에서 이동하면서도 로그인된 상태를 유지할 수 있는 것이다.
  - 딕셔너리 형태로 되어있기 때문에 딕셔너리를 조작하는 것처럼 세션 정보를 업데이트 할 수 있다.



 **세션 데이터 저장하기(방문 횟수 저장하기)** 

- 세션을 간단하게 조작해서 현재 유저가 해당 웹사이트를 몇 번이나 방문 했는지 알려주도록 업데이트 해보자.

  ```python
  # articles/views.py
  
  def index(request):
      # session 에서 visits_num 키로 접근해 값을 가져온다. 
      # 그런데 위에서 확인했듯이 기본적으로 존재하지 않는 키이기 때문에 없다면(방문한 적이 없다면) 0 값을 가져오도록 한다.
      visits_num = request.session.get('visits_num', 0)
      # 그리고 가져온 값을 session 에 'visits_num' 새로운 키의 값으로 매번 1씩 증가한 값으로 할당한다.
      # 유저의 다음 방문을 위해.
      request.session['visits_num'] = visits_num + 1
      # session data 안에 있는 어떤 정보를 수정 했다면 장고는 수정한걸 알아채지 못하기 때문에 필요한 코드.
      request.session.modified = True
      articles = Article.objects.all()
      context = {'articles': articles, 'visits_num': visits_num,}
      return render(request, 'articles/index.html', context)
  ```

  - `request.session.modified = True` 를 기본 값으로 사용하고 싶다면 setting.py 에 아래와 같이 추가한다. 

    ```python
    # myform/settings.py
    
    SESSION_SAVE_EVERY_REQUEST = True
    ```

-  다시 한번 embed() 를 통해 어떻게 session 이 변했는데 확인해보자. 

  ```python
  # articles/views.py
  
  def index(request):
      visits_num = request.session.get('visits_num', 0)
      request.session['visits_num'] = visits_num + 1
      embed()
      ...
  ```

  ```python
  In [1]: request.session._session                                                      
  Out[1]: 
  {'_auth_user_id': '1',
   '_auth_user_backend': 'django.contrib.auth.backends.ModelBackend',
   '_auth_user_hash': '5f903669d65e846adfbff9006c88c9cccc0bb2c2',
   'visits_num': 1}
  
  In [2]: request.session.get('visits_num')                                            
  Out[2]: 1
  ```

  -  session 딕셔너리가 업데이트 된 것을 확인할 수 있다. 



-  이제 index 페이지에 나의 방문 횟수를 출력 해보자 

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    <h1>Articles</h1>
    <p><b>당신의 방문 횟수 : {{ visits_num }}{% if num_visits == 1 %} time{% else %} times{% endif %}.</b></p>
  ...
  ```



-  admin 을 로그아웃하고 다시 접속하면 visits_num 값은 초기화가 된다. 로그아웃하고 다시 로그인 할 때마다 매번 다른 `session_key` 값을 부여하기 때문이다. session 과 cookie, cached 에 대해 추가적인 개념들이 많기 때문에 여기까지만 진행한다. 



---



## 01. Accounts

- Django에는 기본적으로 회원가입 및 로그인과 같은 Auth 관련 기능이 (내부적으로) 이미 구현이 되어있다. 그래서 우리는 `createsuperuser` 를 통해 계정을 만들고, admin 페이지에서 로그인 할 수 있었다.

- 그동안 게시글과 관련된 기능들을 만들었다면, 이제는 인증과 관련된 새로운 기능들을 추가 하므로 새로운 app인 `accounts` 를 만들어 진행한다. (기능에 따른 app 구분이 바람직하기 때문)

- app 이름이 반드시 accounts 일 필요는 없지만, **auth 관련 기본 값들이 accounts 로 django 내부적으로 사용되고** 있기 때문에 되도록 accounts 라는 이름을 사용한다. 

  ```bash
  $ python manage.py startapp accounts
  ```

  ```python
  # settings.py
  
  INSTALLED_APPS = [
      'articles.apps.ArticlesConfig',
      'accounts.apps.AccountsConfig',
  ...
  ```

  ```python
  # myform/urls.py
  
  urlpatterns = [
      path('accounts/', include('accounts.urls')),
      ...
  ]
  ```

  ```python
  # accounts/urls.py
  
  from django.urls import path
  from . import views
  
  app_name = 'accounts'
  urlpatterns = [
      
  ]
  ```



---



## 02. Sign Up

> https://docs.djangoproject.com/ko/2.2/topics/auth/default/#module-django.contrib.auth.forms 
>
>`Authentication(인증)` → 신원 확인
>
>- 자신이 누구라고 **주장하는 사람의 신원을 확인**하는 것
>
>`Authorization(권한, 허가)` → 권한 부여
>
>- 가고 싶은 곳으로 가도록 혹은 **원하는 정보를 얻도록 허용**하는 과정

- 회원가입은 CRUD 로직에서 User 를 Create 하는 것과 같다.
- `class User` Model은 Django가 미리 만들어 놨고 이러한 User 모델과 연동된 ModelForm 인 `UserCreationForm`또한 이미 만들어져 있다. 

```python
# accounts/views.py

from django.contrib.auth.forms import UserCreationForm


def signup(request):
    if request.method == 'POST':
        pass
    else:
        form = UserCreationForm()
    context = {'form': form,}
    return render(request, 'accounts/signup.html', context)
```

```python
# accounts/urls.py

app_name = 'accounts'
urlpatterns = [
    path('signup/', views.signup, name='signup'),
]
```

```django
<!-- accounts/signup.html -->

{% extends 'articles/base.html' %}
{% load bootstrap4 %}

{% block content %}
<h1>회원가입</h1>
<form action="" method="POST">
  {% csrf_token %}
  {% bootstrap_form form %}
  {% buttons submit="회원가입" reset="Cancel" %}{% endbuttons %}
</form>
{% endblock  %}
```

-  회원가입을 해보고 admin 페이지에서 `사용자(들)` 에 새로운 계정이 생겼는지 확인 해보자. User Model은 admin 페이지에 이미 등록도 되어있다. 



---



## 03. Login

>  https://docs.djangoproject.com/ko/2.2/topics/auth/default/#django.contrib.auth.forms.AuthenticationForm 

- 새로운 User를 만들었으니, 만든 user 정보로 로그인을 해보자.
- 로그인도 Create 로직과 같고 Session 을 create 하는 것이다. 
  - session 은 사용자가 로그인 하면, 로그인한 사용자의 정보를 페이지가 전환 되더라도 로그아웃 버튼을 누르거나 session 만료 시간까지 유지한다.
- User 를 인증하는 ModelForm 은 `AuthenticationForm`을 사용한다. 



### 3.1 login()

>  https://docs.djangoproject.com/ko/2.2/topics/auth/default/#how-to-log-a-user-in 

- `login(request, user, backend=None)`

- 현재 세션에 연결하려는 인증 된 사용자가 있는 경우 `login()` 함수가 필요하다.

- django 의 session framework 를통해 user 의 ID 를 세션에 저장한다.

- 즉, 로그인을 한다.

  ```python
  # accounts/views.py
  
  from IPython import embed
  from django.contrib.auth import login as auth_login
  from django.shortcuts import render, redirect
  from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
  
  
  def login(request):
      if request.method == 'POST':
          form = AuthenticationForm(request, request.POST)
          if form.is_valid():
              auth_login(request, form.get_user())
              return redirect('articles:index')
      else:
          form = AuthenticationForm()
      context = {'form': form}
      return render(request, 'accounts/login.html', context)
  ```

-  login 함수 이름을 `auth_login`으로 변경해서 사용하는 이유는 view 함수인 login 과의 혼동을 방지하기 위함이다. 

  ```python
  # accounts/urls.py
  
  urlpatterns = [
      ...
      path('login/', views.login, name='login'),
  ]
  ```

  ```django
  <!-- accounts/login.html -->
  
  {% extends 'articles/base.html' %}
  {% load bootstrap4 %}
  
  {% block content %}
  <h1>로그인</h1>
  <form action="" method="POST">
    {% csrf_token %}
    {% bootstrap_form form %}
    {% buttons submit="로그인" reset="Cancel" %}{% endbuttons %}
  </form>
  {% endblock  %}
  ```



-  로그인을 진행하면 현재 로그인이 되어 있는지 확인할 수가 없기 때문에, 템플릿에서 현재 로그인 유저 이름을 출력 해보자. 

  ```django
  <!-- articles/base.html -->
  
  ...
  <body>
    <div class="container">
      <h3>Hello, {{ user.username }}</h3>
      <hr>
      {% block content %}
      {% endblock %}
    </div>
    {% bootstrap_javascript jquery='full' %}
  </body>
  </html>
  ```



---



## 04. Logout

>  https://docs.djangoproject.com/ko/2.2/topics/auth/default/#how-to-log-a-user-out 

-  로그아웃은 CRUD 패턴에서 Session을 Delete 하는 로직과 같다. 



### 4.1 logout()

- `logout(request)`

- logout 함수는 HttpRequest 객체를 인자로 받고 리턴 값은 없다.

- logout 함수를 호출하면 현재 request 에 대한 session data 를 완전히 정리한다.

- login 과 마찬가지로 logout view 함수와 이름을 다르게 하기 위해 `auth_logout` 으로 변경한다.

  ```python
  # accounts/views.py
  
  from django.contrib.auth import logout as auth_logout
  # from django.contrib.auth import login as auth_login, logout as auth_logout 처럼 작성 가능
  
  def logout(request):
      auth_logout(request)
      return redirect('articles:index')
  ```

  ```python
  # accounts/urls.py
  
  urlpatterns = [
      ...
      path('logout/', views.logout, name='logout'),
  ]
  ```

  ```django
  <!-- articles/base.html -->
  
  ...
  <body>
    <div class="container">
      <h3>
        Hello, {{ user.username }}
        <a href="{% url 'accounts:logout' %}">로그아웃</a>
      </h3>
      <hr>
      {% block content %}
      {% endblock %}
    </div>
    {% bootstrap_javascript jquery='full' %}
  </body>
  ```

  - 로그아웃을 누르면 유저이름이 사라진다.
  - 그런데 로그아웃 되었는데도 링크는 여전히 로그아웃이다. 매끄럽게 수정 해보자.



---



## 05. 로그인 사용자에 대한 접근 제한 

>  https://docs.djangoproject.com/ko/2.2/topics/auth/default/#authentication-in-web-requests 

- django 는 세션과 미들웨어를 통해 인증 시스템(authentication system)을 request 객체에 연결한다.
- request 는 현재 사용자를 나타내는 모든 요청에 `request.user` 를 제공한다.



### 5.1  is_authenticated 

>  https://docs.djangoproject.com/ko/2.2/ref/contrib/auth/#django.contrib.auth.models.User.is_authenticated 

- User model 의 속성(attributes) 들 중 하나.
- 사용자가 인증 되었는지 알 수 있는 방법이다.
- User 에 항상 `True` 이며 AnonymousUser 에 대해서만 항상 False 이다.
- 단, 이것은 권한(permission)과는 관련이 없으며 사용자가 활동중(active)이거나 유효한 세션(valid session) 을 가지고 있는지도 확인하지 않는다.



-  로그인과 비로그인 상태에서 보이는 링크를 다르게 설정한다. 

  -  로그인 상태 → 로그아웃 버튼 보이기 
  -  로그인 상태 → 로그아웃 버튼 보이기 

  ```django
  <!-- articles/base.html -->
  
  ...
  <body>
    <div class="container">
    {% if user.is_authenticated %}
      <h3>
        안녕, {{ user.username }}
        <a href="{% url 'accounts:logout' %}">로그아웃</a>
      </h3>
    {% else %}
      <h3>
        <a href="{% url 'accounts:login' %}">로그인</a>
        <a href="{% url 'accounts:signup' %}">회원가입</a>
      </h3>
    {% endif %}
    <hr>
    ...
  </body>
  </html>
  ```

  - `template` 어디에서도 `user` 라는 객체는 사용 가능하다. 우리가  `render(request,)` , `def(request)` 를 하면서 항상 넘겼던 request 객체 안에 user 정보가 들어있다. 



**로그인 후에는 로그인/회원가입 페이지 접근 제한** 

- 현재 로그인 상태에서도 주소창에 accounts/signup/ 또는 accounts/login/ 를 입력하면 접속이 가능하다. 

- 현재 로그인 상태에서도 주소창에 accounts/signup/ 또는 accounts/login/ 를 입력하면 접속이 가능하다. 

  ```python
  # accounts/views.py
  
  def signup(request):
      if request.user.is_authenticated:
          return redirect('articles:index')
      ...
  
  
  def login(request):
      if request.user.is_authenticated:
          return redirect('articles:index')
      ...
  ```



**회원가입 후 자동으로 로그인 상태 전환** 

-  현재는 회원 가입이 완료되면 로그인 되지 않은 상태로 index 페이지로 넘어가게 된다. 즉 회원가입후 다시 로그인을 해야 한다. 

- 회원 가입이 성공적으로 이루어지면 바로 로그인 상태로 전환하자. 

  ```python
  # accounts/views.py
  
  def signup(request):
      if request.user.is_authenticated:
          return redirect('articles:index')
  
      if request.method == 'POST':
          form = UserCreationForm(request.POST)
          if form.is_valid():
              # User 클래스의 인스턴스를 생성 후 auth_login 에 인자로 전달.
              user = form.save()
              auth_login(request, user)
              return redirect('articles:index')
      else:
          form = UserCreationForm()
      context = {'form': form,}
      return render(request, 'accounts/signup.html', context)
  ```

  - 이제는 회원가입과 동시에 로그인 상태로 된다. 



 **비 로그인시 게시글 작성 링크 가리기** 

```django
<!-- articles/index.html -->

{% extends 'articles/base.html' %}
{% block content %}
  <h1>Articles</h1>
  <p><b>당신의 방문 횟수 : {{ visits_num }}{% if num_visits == 1 %} time{% else %} times{% endif %}.</b></p>
  {% if user.is_authenticated %}
    <a href="{% url 'articles:create' %}">[NEW]</a>
  {% else %}
    <a href="{% url 'accounts:login' %}">[새 글을 작성하려면 로그인하세요]</a>
  {% endif %}
  ...
{% endblock %}
```

-  하지만 비 로그인 상태로도 url 에 직접 입력하면 작성 페이지로 갈 수 있다. 



### 5.2 login_required 

>  https://docs.djangoproject.com/en/2.2/topics/auth/default/#the-login-required-decorator 

**`login_required decorator`**

- 로그인 하지 않은 사용자의 경우 `settings.LOGIN_URL` 에 설정된 문자열 기반 절대 경로로 리다이렉트 된다. (LOGIN_URL 의 기본 값은 `'/accounts/login/'`, 우리가 두번째 app 이름을 accounts 로 했던 이유 중 하나)
- 로그인 된 사용자의 경우 정상적으로 view 를 실행한다.



**로그인 상태에서만 글을 작성/수정/삭제 할 수 있도록 변경** 

- `@login_required` 는 해당 view 함수를 실행 하려면 로그인이 필요하다는 조건을 만들어준다.

- 데코레이터 설정 시 해당 함수가 실행되기 전에 데코레이터에 설정된 함수가 먼저 실행된다. 

  ```python
  # articles/views.py
  
  from django.contrib.auth.decorators import login_required
  
  
  @login_required
  def create(request):
  
  
  @login_required
  def update(request, article_pk):
  
  
  @login_required
  @require_POST
  def delete(request, article_pk):
  ```

  -  이제 `articles/create/` 로 강제 접속 시 로그인 페이지로 리다이렉트 된다.
  -  그런데 `/accounts/login/?next=/articles/create/` 와 같은 주소가 생성된다. 



 **`"next"` query string parameter** 

- `@login_required` 은 기본적으로 인증 성공 후 사용자를 리다이렉트 할 경로를 **next 라는 문자열 매개 변수에 저장**한다.
- 우리가 url 로 접근하려고 했던 그 주소가 로그인이 되어있지 않으면 볼 수 없는 곳이라서, django 가 로그인 페이지로 강제로 돌려 보냈는데, 로그인을 다시 정상적으로 하면 원래 요청했던 주소로 보내 주기 위해 **keep 해주는 것**이다.

- 따로 처리 해주지 않으면 우리가 view에 설정한 redirect 경로로 이동하지만, next 에 저장된 주소로 이동되도록 만들기 위해 작업을 해보자. 

  ```python
  # accounts/viesw.py
  
  def login(request):
      if request.user.is_authenticated:
          return redirect('articles:index')
  
      if request.method == 'POST':
          form = AuthenticationForm(request, request.POST)
          if form.is_valid():
              auth_login(request, form.get_user())
              return redirect(request.GET.get('next') or 'articles:index')  # 추가
  ```

  >  `request.GET.get('next')` 확인해보기 
  >
  > ```python
  > def login(request):
  >     if request.user.is_authenticated:
  >         return redirect('articles:index')
  > 
  >     if request.method == 'POST':
  >         form = AuthenticationForm(request, request.POST)
  >         if form.is_valid():
  >             auth_login(request, form.get_user())
  >             embed()
  >             return redirect(request.GET.get('next') or 
  > ```
  >
  > ```python
  > In [1]: request.GET
  > Out[1]: <QueryDict: {'next': ['/articles/create/']}>
  > 
  > In [2]: request.GET.get('next')
  > Out[2]: '/articles/create/
  > ```



**로그인 상태에서만 댓글을 작성/삭제 할 수 있도록 변경** 

- 만약 `@require_POST` 가 있는 함수에 `@login_required` 가 설정 된다면 로그인 이후 `"next"` 매개변수를 따라 해당 함수로 다시 redirect 되면서 `@require_POST` 때문에 405 에러가 발생하게 될 것이다.

- 이 경우 두가지 문제가 발생하게 되는데 첫째로는 **redirect 중 POST 데이터의 손실**이 일어나며 둘째로는 애초에 **redirect 는 POST Request 가 불가능**하여 GET Request 로 요청이 보내진다. 

  - POST로 요청 들어옴 -> 로그인 검증 -> 로그인 페이지 (?next='/comments/create/') -> 로그인 성공 -> next로 redirect (GET Request) -> POST인지 검증 -> 405 에러 

- 때문에 POST 요청만 허용하는 `comment_create` 와 같은 함수는 아래와 같이 함수 내부에서 처리하도록 한다. (`login_required` 는 **GET 요청이 들어오는 View 에서만 사용**) 

  ```python
  # articles/views.py
  
  # 게시글 삭제도 마찬가지로 추가 수정
  @require_POST
  def delete(request, article_pk):
      if request.user.is_authenticated: # 추가
          article = get_object_or_404(Article, pk=article_pk)
          article.delete()
      return redirect('articles:index')
  
  
  @require_POST
  def comment_create(request, article_pk):
      if request.user.is_authenticated: # 추가
          comment_form = CommentForm(request.POST)
          if comment_form.is_valid():
              comment = comment_form.save(commit=False)
              comment.user = request.user
              comment.article_id = article_pk
              comment.save()
      return redirect('articles:detail', article_pk)
  
  
  @require_POST
  def comment_delete(request, article_pk, comment_pk):
      if request.user.is_authenticated: # 추가
          comment = get_object_or_404(Comment, pk=comment_pk)
          comment.delete()
      return redirect('articles:detail', article_pk)
  ```

  > 다음과 같이 작성할 수도 있다.
  >
  > ```python
  > # articles/views.py
  > 
  > from django.http import HttpResponse # 추가
  > 
  > 
  > def delete(request, article_pk):
  >     if request.user.is_authenticated: # 추가
  >         article = get_object_or_404(Article, pk=article_pk)
  >         article.delete()
  >         return redirect('articles:index')
  >     return HttpResponse('You are Unauthorized', status=401)
  > 
  > 
  > @require_POST
  > def comment_create(request, article_pk):
  >     if request.user.is_authenticated: # 추가
  >         comment_form = CommentForm(request.POST)
  >         if comment_form.is_valid():
  >             comment = comment_form.save(commit=False)
  >             comment.user = request.user
  >             comment.article_id = article_pk
  >             comment.save()
  > 		    return redirect('articles:detail', article_pk)
  > 		return HttpResponse('You are Unauthorized', status=401)
  > 
  > 
  > @require_POST
  > def comment_delete(request, article_pk, comment_pk):
  >     if request.user.is_authenticated: # 추가
  > 				comment = get_object_or_404(Comment, pk=comment_pk)
  >         comment.delete()
  >         return redirect('articles:detail', article_pk)
  >     return HttpResponse('You are Unauthorized', status=401)
  > ```



---



## 06. 회원탈퇴

-  유저를 탈퇴하는 것은 DB 에서 유저를 삭제하는 것과 같다. 

-  로그인 된 상태에서만 회원 탈퇴 링크를 만들어서 회원 정보를 삭제하도록 한다. 

  ```python
  # accounts/views.py
  
  from django.views.decorators.http import require_POST
  
  @require_POST
  def delete(request):
      request.user.delete()
      return redirect('articles:index')
  ```

  ```python
  # accounts/urls.py
  
  urlpatterns = [
      ...,
      path('delete/', views.delete, name='delete'),
  ]
  ```

  ```django
  <!-- articles/base.html --> 
  
  ...
  <body>
    <div class="container">
    {% if user.is_authenticated %}
      <h3>
        Hello, {{ user.username }}
        <a href="{% url 'accounts:logout' %}">로그아웃</a>
        <form action="{% url 'accounts:delete' %}" method="POST" style="display: inline;">
          {% csrf_token %}
          <input type="submit" value="회원탈퇴" class="btn btn-danger">
        </form>
      </h3>
    {% else %}
  ...
  
  ```

  -  admin 페이지에서 회원이 삭제 되었는지 확인해 본다. 



---



## 07. 회원 수정

>  https://docs.djangoproject.com/en/2.2/topics/auth/default/#module-django.contrib.auth.forms 

-  회원 정보를 수정하는 ModelForm은 `UserChangeForm` 을 사용한다. 

  ```python
  # accounts/views.py
  
  def update(request):
      if request.method == 'POST':
          pass
      else:
          form = UserChangeForm(instance=request.user)
      context = {'form': form,}
      return render(request, 'accounts/update.html', context)
  ```

  ```python
  # accounts/urls.py
  
  urlpatterns = [
      ...,
      path('update/', views.update, name='update'),
  ]
  ```

  ```django
  <!-- accounts/update.html -->
  
  {% extends 'articles/base.html' %}
  {% load bootstrap4 %}
  
  {% block content %}
  <h1>회원정보수정</h1>
  <form action="" method="POST">
    {% csrf_token %}
    {% bootstrap_form form %}
    {% buttons submit="정보수정" reset="Cancel" %}{% endbuttons %}
  </form>
  {% endblock  %}
  ```

  ```django
  <!-- articles/base.html -->
  
  ...
  <body>
    <div class="container">
    {% if user.is_authenticated %}
      <h3>
        Hello, {{ user.username }}
        <a href="{% url 'accounts:update' %}">정보수정</a>
  ...
  ```

  -  정보수정 페이지를 확인해보자. 



### 7.2 Custom Form

- 위와 같이 했을 때의 문제점은, 일반 사용자가 접근해서는 안될 정보들(fields)까지 모두 수정이 가능해진다. (비밀번호 - 알고리즘/소트/해시 등등)

- 그래서 `UserChangeForm` 을 상속받아 새로운 `CustomUserChangeForm` 을 만들어 접근 가능한 필드를 조정해야 한다.

  ```python
  # accounts/forms.py
  
  from django.contrib.auth.forms import UserChangeForm
  from django.contrib.auth import get_user_model
  
  class CustomUserChangeForm(UserChangeForm):
      class Meta:
          model = get_user_model()
          fields = ???
  ```

  - 두가지 의문점이 생긴다.
  - 1. `get_user_model()`은 무엇일까? / 2. fields 명들은 어떻게 알 수 있을까?





**`get_user_model()`**

>  https://docs.djangoproject.com/ko/2.2/topics/auth/customizing/#referencing-the-user-model 

- `User` 를 직접 참조하는 대신 `django.contrib.auth.get_user_model()` 을 사용하여 user model 을 참조해야한다.
- 이 함수는 현재 활성화(active)된 user model 을 리턴한다. 

- **자세한 설명은 User:Article 1:N / Custom User 에서 다룬다.**



 **`AbstractUser`**

- 관리자 권한과 함께 완전한 기능을 가지고 있는 User model 을 구현하는 클래스. 

![3iEnbH5](https://user-images.githubusercontent.com/52446416/67413870-f4416180-f5fc-11e9-8bd3-34d01f8e4029.png)

- django github 으로 가서 직접 UserChangeForm 을 확인해보자.  
- Meta 정보를 보면 User 라는 model 을 참조하는 ModelForm 이라는 것을 확인할 수 있다.
- 이번엔 User 클래스를 찾아가보자. (https://github.com/django/django/blob/04ac9b45a34440fa447feb6ae934687aacbfc5f4/django/contrib/auth/models.py#L384)
- 그런데 User 클래스는 비어있고 `AbstractUser` 를 상속받고 있다. AbstractUser 를 다시 따라가보자. (https://github.com/django/django/blob/04ac9b45a34440fa447feb6ae934687aacbfc5f4/django/contrib/auth/models.py#L316)
- `AbstractUser` 의 클래스 변수명들을 확인해보면 우리가 회원수정 페이지에서 봤던 필드들과 일치한다는 것을 할 수 있다.



- 필드명을 확인한 후 이제 우리가 수정시 사용할 필드만 선택해서 작성해보자. 

  ```python
  # accounts/forms.py
  
  class CustomUserChangeForm(UserChangeForm):
      class Meta:
          model = get_user_model()
          fields = ('email', 'first_name', 'last_name',)
  ```



- 이제 기존 UserChangeForm 이 아닌 CustomUserChangeForm 을 사용해 확인해보자. 

  ```python
  # accounts/views.py
  
  ...
  from .forms import CustomUserChangeForm
  
  def update(request):
      if request.method == 'POST':
          pass
      else:
          form = CustomUserChangeForm(instance=request.user)
      context = {'form': form,}
      return render(request, 'accounts/update.html', context)
  ```



- 실제 회원정보가 수정되도록 POST 요청 코드를 작성해보자. 

  ```python
  # accounts/views.py
  
  def update(request):
      if request.method == 'POST':
          form = CustomUserChangeForm(request.POST, instance=request.user)
          if form.is_valid():
              form.save()
              return redirect('articles:index')
      else:
          ...
  ```

  -  admin 페이지에서 실제 회원정보가 수정되었는지 확인해보자. 



- 로그인하지 않은 상태에서 직접 회원수정 페이지로 접속할 경우 다음과 같은 에러가 발생한다. 

  <img width="789" alt="Screen_Shot_2019-10-09_at_7 58 43_PM" src="https://user-images.githubusercontent.com/52446416/67414374-ec35f180-f5fd-11e9-8615-0d9714be5b00.png">

-  로그인 한 유저만 해당 view 를 호출할 수 있도록 수정한다. 

  ```python
  # accounts/views.py
  
  from django.contrib.auth.decorators import login_required
  
  @login_required
  def update(request):
      ...
  ```



---



## 08. 비밀번호 변경

>  https://docs.djangoproject.com/en/2.2/topics/auth/default/#django.contrib.auth.forms.PasswordChangeForm 

- 회원정보 수정을 위한 `UserChangeForm` 에도 password 필드는 있지만 막상 필드를 보면 수정할 수 없다.

- 대신, 가장 하단에 '**다만 이 양식으로 비밀번호를 변경할 수 없습니다.**' 라는 문구가 있는데, 이 링크를 클릭하면 `accounts/password/` 라는 주소로 이동한다. django가 기본적으로 설정하고 있는 링크이다. (이것도 app의 이름을 accounts로 했던 이유 중의 하나)

-  비밀번호 변경은 `PasswordChangeForm` 을 사용한다. 

  ```python
  # accounts/views.py
  
  from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm
  
  def change_password(request):
      if request.method == 'POST':
          pass
      else:
          form = PasswordChangeForm(request.user)
      context = {'form': form,}
      return render(request, 'accounts/change_password.html', context)
  ```

  - 비밀번호 변경은 반드시 user 가 있어야 하기 때문에 `request.user` 를 인자로 받는다.
  - 그리고 user object 를 키워드 없이(`instance=`) 받는다.

  ```python
  # accounts/urls.py
  
  urlpatterns = [
      ...,
      path('password/', views.change_password, name='change_password'),
  ]
  ```

  ```django
  <!-- accounts/change_password.html -->
  
  {% extends 'articles/base.html' %}
  {% load bootstrap4 %}
  
  {% block content %}
  <h1>비밀번호 변경</h1>
  <form action="" method="POST">
    {% csrf_token %}
    {% bootstrap_form form %}
    {% buttons submit="변경" reset="Cancel" %}{% endbuttons %}
  </form>
  {% endblock %}
  ```

  ```django
  <!-- accounts/base.html-->
  
  <body>
    <div class="container">
    {% if user.is_authenticated %}
      <h3>
        Hello, {{ user.username }}
        <a href="{% url 'accounts:update' %}">정보수정</a>
        <a href="{% url 'accounts:change_password' %}">비번변경</a>
        ...
  ```

  -  비밀번호 변경 페이지를 확인해보자. 



-  실제로 비밀번호를 변경하도록 POST 로직을 작성해보자. 

  ```python
  # accounts/views.py
  
  def change_password(request):
      if request.method == 'POST':
          form = PasswordChangeForm(request.user, request.POST)
          if form.is_valid():
              form.save()
              return redirect('articles:index')
      else:
          form = PasswordChangeForm(request.user)
      context = {'form': form}
      return render(request, 'accounts/change_password.html', context)
  ```

  -  `PasswordChangeForm(request.user, request.POST)` 에서 반드시 user 정보를 먼저 작성하여야 한다. 



 **`update_session_auth_hash `**

>  https://docs.djangoproject.com/en/2.2/topics/auth/default/#django.contrib.auth.update_session_auth_hash 

- `update_session_auth_hash(request, user)`
- 비밀번호를 변경하고 나니 로그인이 풀려 버렸다.
- 변경된 비밀번호로 로그인 해보니 변경은 잘 되었다는 것을 확인할 수 있다.
- 그런데 로그아웃이 되어버린 이유는 비밀번호가 변경 되면서 기존 세션과의 회원 인증 정보가 일치하지 않게 되어 버렸기 때문이다.

- 이 문제를 막기 위해서 `update_session_auth_hash` 라는 새로운 함수를 사용한다. 

  - 현재 사용자의 인증 세션이 무효화 되는 것을 막고, 세션을 유지한 상태로 업데이트 한다. 

  ```python
  # accounts/views.py
  
  from django.contrib.auth import update_session_auth_hash
  
  def change_password(request):
      if request.method == 'POST':
          form = PasswordChangeForm(request.user, request.POST)
          if form.is_valid():
              form.save() # user 변수에 할당 후 아래 인자로 넣어도 된다.
              update_session_auth_hash(request, form.user)
              return redirect('articles:index')
      else:
          form = PasswordChangeForm(request.user)
      context = {'form': form}
      return render(request, 'accounts/change_password.html', context)
  ```



- 로그인 하지 않은 상태에서는 직접 비밀번호 변경 페이지로 접속하지 못하도록 처리한다. 

  ```python
  # accounts/views.py
  
  @login_required
  def change_password(request):
      ...
  ```



---



## 09. auth_form template 합치기 

- 현재 accounts app 의 templates 에 `change_password.html`, `update.html`, `signup.html` 그리고 `login.html`의 form 코드들이 모두 동일하다.

-  `auth_form.html` 이라는 이름의 html 파일을 만들어 코드의 재사용성 특징을 생각해서 중복을 최대한 줄여보자.  

  ```django
  <!-- accounts/auth_form.html -->
  
  {% extends 'articles/base.html' %}
  {% load bootstrap4 %}
  
  {% block content %}
  
  {% if request.resolver_match.url_name == 'signup' %}
    <h1>회원가입</h1>
  {% elif request.resolver_match.url_name == 'login' %}
    <h1>로그인</h1>
  {% elif request.resolver_match.url_name == 'update' %}
    <h1>회원수정</h1>
  {% else %}
    <h1>비밀번호변경</h1>
  {% endif %}
  
  <form action="" method="POST">
    {% csrf_token %}
    {% bootstrap_form form %}
    {% buttons submit="submit" reset="Cancel" %}{% endbuttons %}
  </form>
  {% endblock  %}
  ```

  - 이제 `accounts/views.py` 에서 `signup` , `update` , `change_password`, `login` view 함수의 render template 인자 주소를 모두 `accounts/auth_form.html` 로 변경한다.
























