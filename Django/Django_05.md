[TOC]

---

## 01. URL Namespace

> 02_django_crud 수업 자료 이어서 진행

### 1.1 하드코딩 URL 제거

```django
<!-- articles/detail.html -->

<a href="/articles/{{ article.pk }}/edit/">[EDIT]</a>
<a href="/articles/{{ article.pk }}/delete/">[DELETE]</a>
```

- 우리는 지금까지 위와 같이 url 를 직접 만들어 작성하는 방식으로 사용하고 있었다.

- 이러한 방식의 문제는 추후에 많은 템플릿을 가진 프로젝트들의 URL을 변경하는 작업이 굉장히 복잡하고 어려운 일이 된다는 점이다.

- 그래서 django 는 `path()`함수에서 `name`인수(optional) 를 정의해, `**{% url %}`template tag** 를 사용하여 URL 설정에 정의된 특정한 URL 경로들의 의존성을 제거할 수 있다.

  ```python
  # articles/urls.py
  
  from django.urls import path
  from . import views
  
  urlpatterns = [
      path('', views.index, name='index'),
      path('new/', views.new, name='new'),
      path('create/', views.create, name='create'),
      path('<int:pk>/', views.detail, name='detail'),
      path('<int:pk>/delete/', views.delete, name='delete'),
      path('<int:pk>/edit/', views.edit, name='edit'),
      path('<int:pk>/update/', views.update, name='update'),
  ]
  ```

  >  the namevalue as called by the **{% url %}template tag**

- url.py 에 위와 같이 name 인수를 정의하면 이제는 아래와 같이 해당 URL 접근할 수 있다.

  ```django
  <!-- articles/detail.html -->
  
  <a href="{% url 'edit' article.pk %}">[EDIT]</a>
  <a href="{% url 'delete' article.pk %}">[DELETE]</a><br>
  <a href="{% url 'index' %}">[back]</a>
  ```

- 만약 edit view 의 URL 을 `/article/ssafy/{{ article.pk }}/edit/`으로 바꾸게 된다면, template 에서 모두 찾아가면서 바꾸는 것이 아니라 `article/urls.py`에서만 바꾸면 된다.

### 1.2 URL namespace 정하기

- 현재 프로젝트는 article 라는 app 하나만 가지고 진행하고 있다. 하지만 실제 Django 프로젝트는 여러 app 들이 만들어 질 것이다.

- 예를 들어, articles app은 detail 이라는 view를 가지고 있고, 동일한 프로젝트에 다른 app 에서도 detail 이라는 view를 가지고 동일한 url name 을 사용할 수도 있다. 과연 Django가 {% url %} 템플릿 태그를 사용할 때, 어떤 app 의 view 에서 URL을 생성할지 알 수 있을까?

- 우리가 templates 와 static 에 namespace 를 만든 것 처럼 url name 에도 namespace 만들어서 해결할 수 있다.

  ```python
  # articles/urls.py
  
  app_name = 'articles'
  urlpatterns = [
      ...
  ]
  ```

- 이름공간은 urls.py 에 `app_name`을 통해 app 의 이름공간을 설정한다.

- 이제 기존 모든 url 은 다음과 같이 변경할 수 있다.

  > [Built-in template tags and filters - url](https://docs.djangoproject.com/en/2.2/ref/templates/builtins/#url)

  ```django
  <!-- articles/detail.html -->
  
  <a href="{% url 'articles:edit' article.pk %}">[EDIT]</a>
  <a href="{% url 'articles:delete' article.pk %}">[DELETE]</a><br>
  <a href="{% url 'articles:index' %}">[back]</a>
  ```

- views.py 의 redirect 주소, templates 의 기존 url 을 깔끔하게 변경해보자.

  ```python
  # articles/views.py
  
  def create(request):
      ...
      return redirect('articles:detail', article.pk)
  
  
  def delete(request, pk):
      ...
      return redirect('articles:index')
  
  
  def update(request, pk):
      ...
      return redirect('articles:detail', article.pk)
  ```

  ```django
  <!-- articles/index.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    <h1 class="text-center">Articles</h1>
    <a href="{% url 'articles:new' %}">[NEW]</a>
    ...
      <a href="{% url 'articles:detail' article.pk %}">[DETAIL]</a>
      <hr>
    {% endfor %}
  {% endblock %}
  ```

  ```django
  <!-- articles/new.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    <h1 class="text-center">NEW</h1>
    <form action="{% url 'articles:create' %}" method="POST">
      ...
    <a href="{% url 'articles:index' %}">[back]</a>
  {% endblock %}
  ```

  ```django
  <!-- articles/edit.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    <h1 class="text-center">EDIT</h1>
    <form action="{% url 'articles:update' article.pk %}" method="POST">
      ...
    <a href="{% url 'articles:detail' article.pk %}">[back]</a><br>
    <a href="{% url 'articles:index' %}">[메인페이지]</a>
  {% endblock %}
  ```

  - 모두 변경 후 정상 동작하는지 확인한다.

  

`onclick`속성을 통해 삭제하기 전에 확인 팝업 띄워보기

```django
<!-- articles/detail.html -->

<a href="{% url 'articles:delete' article.pk %}" onclick="return confirm('R U SURE..??')">[DELETE]</a><br>
```



------



## 02. RESTful

> [REST API 제대로 알고 사용하기](https://meetup.toast.com/posts/92)

**배경**

- REST는 `Representational State Transfer`라는 용어의 약자로서 2000년도에 로이 필딩 (Roy Fielding)의 박사학위 논문에서 최초로 소개. 로이 필딩은 HTTP의 주요 저자 중 한 사람으로 그 당시 웹(HTTP) 설계의 우수성에 비해 제대로 사용 되어지지 못하는 모습에 안타까워하며 웹의 장점을 최대한 활용할 수 있는 아키텍처로써 REST를 발표했다.
- REST 원리를 따르는 시스템은 종종 RESTful 이란 용어로 지칭한다.



**REST 구성**

- 자원(Resource) - URI
- 행위(Verb) - HTTP Method
- 표현(Representations)



**Rest API 디자인 가이드**

1. URI 는 **정보의 자원**을 표현 해야한다.

   ```python
   GET /articles/show/1 (X)
   POST /articles/1 (O)
   
   # URI는 자원을 표현하는데 중점을 두기 때문에 show 와 같은 행위에 대한 표현이 들어가서는 안된다.
   ```

2. 자원에 대한 행위는 **HTTP Method**(GET, POST, PUT, DELETE)로 표현한다.

   ```python
   GET /articles/1/update (X)
   PUT /articles/1 (O)
   
   GET /articles/1/delete (X)
   DELETE /articles/1 (O)
   
   # GET Method 는 리소스 생성/삭제에 부적합하다.
   ```

- 다만 django 에서는 PUT, DELETE 같은 비공식적 요청을 default 로 지원하고 있지 않아 다음과 같이 절충한다.

  ```python
  GET /articles/2/edit/ 	# 수정 페이지 보여줌
  POST /articles/2/edit/	# 수정 작업 수행
  ```

- REST 는 URI 마지막에 `/`(슬래시) 를 쓰지 않는 걸 권장하는데, django 는 권장하고 있다. (권장을 넘어 쓰지 않으면 에러가 발생하기도 한다.)

- **RESTful 의 핵심**- HTTP URI(Uniform Resource Identifier)를 통해 자원(Resource)을 명시하고, HTTP Method(POST, GET, PUT, DELETE)를 통해 해당 자원에 대한 CRUD Operation을 적용하는 것을 의미한다.



### 2.1 RESTful 적용하기

- 기존 url

  ```python
  # articles/urls.py
  
  urlpatterns = [
      path('', views.index, name='index'),
      path('new/', views.new, name='new'),
      path('create/', views.create, name='create'),
      path('<int:pk>/', views.detail, name='detail'),
      path('<int:pk>/delete/', views.delete, name='delete'),
      path('<int:pk>/edit/', views.edit, name='edit'),
      path('<int:pk>/update/', views.update, name='update'),
  ]
  ```

- 변경 후 url

  ```python
  urlpatterns = [
      path('', views.index, name='index'),
      path('create/', views.create, name='create'),   # GET(new), POST(create)
      path('<int:pk>/', views.detail, name='detail'),
      path('<int:pk>/delete/', views.delete, name='delete'),  # POST(delete)
      path('<int:pk>/update/', views.update, name='update'),  # GET(edit), POST(update)
  ]
  ```



### 2.2 url & views 정리하기

> `print(request)` 먼저 까보기
>
> - `request`에는 요청에 대한 여러가지 정보가 담겨 있다. `embed()`를 통해 확인 해보자.
>
>   ```bash
>   $ pip install ipython
>   ```
>
>   ```python
>   # articles/views.py
>   
>   from IPython import embed
>   
>   def new(request):
>   		embed()
>   
>   def update(request):
>   		embed()
>   ```
>
> - GET 요청은 HTTP body가 아닌 쿼리 스트링으로 데이터를 보낸다. 우리는 해당 데이터를 주소창에서 볼 수 있다.
>
> - POST 요청은 HTTP body에 정보를 담아서 보낸다. 아래의 요청에서는 csrf_token과 관련된 정보가 Body에 담겨져 요청을 보낼 때 같이 전달된 것을 알 수 있다.
>
>   ```python
>   # /articles/new/ 로 요청을 보냄(GET)
>   
>   In [1]: request                 
>   Out[1]: <WSGIRequest: GET '/articles/new/'>
>   
>   In [7]: request.method                 
>   Out[7]: 'GET'
>   
>   In [5]: request.path                 
>   Out[5]: '/articles/new/'
>   
>   In [3]: request.body                 
>   Out[3]: b''
>   
>   In [6]: request.content_type                 
>   Out[6]: 'text/plain'
>   
>   
>   
>   # /articles/3/update/ 으로 요청을 보냄(POST)
>   
>   In [3]: request                 
>   Out[3]: <WSGIRequest: POST '/articles/3/update/'>
>   
>   In [5]: request.path                 
>   Out[5]: '/articles/3/update/'
>   
>   In [6]: request.body                 
>   Out[6]: b'csrfmiddlewaretoken=vW14YNHlUlSPBeLVRGy8XUcOGLMTx2KBuCNxVOIAKP1ZlQl9IHb64rkKdbFjJFgE&title=%EC%A0%9C%EB%AA%A9344dfdf&content=dfdf%EB%82%B4%EC%9A%A9344'
>   
>   In [7]: request.content_type                 
>   Out[7]: 'application/x-www-form-urlencoded'
>   ```



**new + create**

- `request.method`의 GET, POST 값으로 분기한다.

- full_clean() 유효성 검증 구문을 위한 try except 구문은 삭제한다. 추후에 form 개념을 통해 다시 유효성 검증에 대해 다루게 된다.

  ```python
  # articles/views.py
  
  def create(request):
      # create
      if request.method == 'POST':
          title = request.POST.get('title') 
          content = request.POST.get('content')
          article = Article(title=title, content=content)
          article.save()
          return redirect('articles:detail', article.pk)
      # new
      else:
          return render(request, 'articles/new.html')
  ```

  - 이제 필요 없어진 new 뷰 함수는 삭제한다.

  - 변경 후 메인 페이지로 접속하면 `NoReverseMatch`에러 페이지가 뜬다. 현재 접속한 페이지에 **잘못되거나 존재하지 않는 url 이 설정되어 있기 때문**이다.

    ```django
    <!-- articles/index.html -->
    
    <a href="{% url 'articles:new' %}">[NEW]</a>
    ```
    - 이 주소는 이제 url 에서 없어졌기 때문에 create 로 변경한다.

      ```django
      <a href="{% url 'articles:create' %}">[NEW]</a>
      ```

  - new.html → `create.html`로 파일명 변경 && form tag action 설정 지우기

    ```django
    <!-- articles/create.html -->
    
    {% extends 'base.html' %}
    
    {% block content %}
      <h1 class="text-center">CREATE</h1>
      <form action="" method="POST">
        ...
    {% endblock %}
    ```
    - 이렇게하면 **form 데이터가 현재 머물고 있는 URL 주소로 POST 요청을 보낸다. (action 을 작성하지 않아도 동작한다.)**
    - 예전처럼 `action="{% url 'boards:create' %}"` 를 사용해도 무방하다.

  - create 뷰 함수의 render 경로 변경

    ```python
    # articles/views.py
    
    def create(request):
        ...
        # new
        else:
            return render(request, 'articles/create.html')
    ```

    

**edit + update**

- edit.html → `update.html` 파일명 변경

- update 뷰함수로 합친 후 edit 뷰함수 삭제

  ```python
  # articles/views.py
  def update(request, pk):
      article = Article.objects.get(pk=pk)
      # update
      if request.method == 'POST': 
          article.title = request.POST.get('title')
          article.content = request.POST.get('content')
          article.save()
          return redirect('articles:detail', article.pk)
      # edit
      else:
          context = {'article': article,}
          return render(request, 'articles/update.html', context)
  ```
  
  ```django
  <!-- articles/update.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
  <h1 class="text-center">UPDATE</h1>
  <form action="" method="POST">
      ...
  {% endblock %}
  ```
  
  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
  ...
  <a href="{% url 'articles:update' article.pk %}">[EDIT]</a>
  ...
  {% endblock %}
  ```

  

**delete → POST**

- 현재 delete 는 GET method 요청으로 동작하고 있기 때문에 url 에 직접 삭제 주소를 입력하면 삭제가 된다.

- 그래서 POST 로 요청을 받기 위해 다음과 같이 조건을 만든다.

  ```python
  # articles/views.py
  
  def delete(request, pk):
      article = Article.objects.get(pk=pk)
      if request.method == 'POST':
          article.delete()
          return redirect('articles:index')
      else:
          return redirect('articles:detail', article.pk)
  ```

- POST method 로 요청을 보내기 위해 기존 a 태그를 form 태그로 변경한다.

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    ...
    <form action="{% url 'articles:delete' article.pk %}" method="POST" onclick="return confirm('R U SURE..??')">
      {% csrf_token %}
      <input type="submit" value="DELETE">
    </form><br>
    <a href="{% url 'articles:index' %}">[back]</a>
  {% endblock %}
  ```
  
  

------



## 03. Model Instance Method

### 3.1 get_absolute_url()

> https://docs.djangoproject.com/ko/2.2/ref/models/instances/#get-absolute-url
>
> https://developer.mozilla.org/ko/docs/Learn/Server-side/Django/Models

- 웹사이트의 개별적인 모델 레코드들을 보여주기 위한 URL을 반환하는 메서드

- HTTP를 통해 객체를 참조하는 데 사용할 수 있는 문자열을 반환한다.

- 특정 모델에 대해서 detail view 를 만들게 되면 되도록 바로 사용하는 것이 좋다.

  ```python
  # articles/models.py
  
  class Article(models.Model):
      ...
  
      def get_absolute_url(self):
          return f'/articles/{self.pk}/'
  ```

- 하지만 위처럼 작성하는 것 보다 **`reverse()`** 함수(string 을 반환)를 사용하는 것이 일반적으로 가장 좋은 방법이다.

  >  https://docs.djangoproject.com/ko/2.2/ref/urlresolvers/#reverse

- 우리가 사용하고 있는 url template tag 인 **`{% url '' %}`** 도 내부적으로 `reverse()`를 사용하고 있다.

  ```python
  class Article(models.Model):
      ...
  
      def get_absolute_url(self):
          return reverse('articles:detail', args=[str(self.pk)]) # '/articles/10/'
          # 또는
          return reverse('articles:detail', kwargs={'pk': self.pk}) # '/articles/10/'
  ```

  - URL에 전달하는 인자가 있다면 **args**나 **kwargs**로 전달할 수 있다.
  - 단, args와 kwarg는 동시에 reverse() 로 전달 될 수 없다.



### 3.2 get_absolute_url 활용

**url template tag**

```django
<a href="{% url 'articles:detail' article.pk %}">[DETAIL]</a>

<!-- 아래와 같이 변경 -->

<a href="{{ article.get_absolute_url }}">[DETAIL]</a>
```

```django
<!-- articles/index.html -->

{% extends 'base.html' %}

{% block content %}
  ...
    <a href="{{ article.get_absolute_url }}">[DETAIL]</a>
    <hr>
  {% endfor %}
{% endblock %}
```

```django
<!-- articles/update.html -->

{% extends 'base.html' %}

{% block content %}
  ...
  <a href="{{ article.get_absolute_url }}">[back]</a><br>
  <a href="{% url 'articles:index' %}">[메인페이지]</a>
{% endblock %}
```

- article 모델 클래스의 get_absolute_url() 메서드를 호출하여 `/articles/{self.pk}/`URL 을 문자열로 반환 받는다.



**redirect**

```python
# articles/views.py

return redirect('articles:detail', article.pk)

# 아래처럼 변경 가능

return redirect(article) # 해당되는 코드를 모두 변경해보자.
```

- `redirect()`는 `HttpResponseRedirect`를 반환한다.

  ```python
  print(redirect(article))
  # <HttpResponseRedirect status_code=302, "text/html; charset=utf-8", url="/articles/35/">
  ```
  
  

**admin**

- 만약 모델에 get_absolute_url() 를 정의했다면, admin page 의 모델 레코드 수정 화면에 `사이트에서 보기(View on Site)`버튼이 자동으로 추가된다. (해당 객체의 public view 화면으로 바로 이동)

  <img width="819" alt="Screen_Shot_2019-09-08_at_5 54 04_PM" src="https://user-images.githubusercontent.com/18046097/65311658-c4510980-dbcb-11e9-9cbf-55e6ef448f99.png">

- 이렇게 `get_absolute_url()`를 사용하면 코드가 보다 간결하고 깔끔해진다.

------



## 04. CRUD 종합 실습 - 전생 직업 APP

### 4.1 Faker package

> https://github.com/joke2k/faker/tree/60691b6ae9583b20a029f6fd3cc183c679a51a26
>
> https://faker.readthedocs.io/en/stable/

**설치**

```bash
$ pip install faker
```



**기본 사용법**

```bash
$ python manage.py shell
```

```python
from faker import Faker
fake = Faker()

fake.name()
# 'Lucy Cechtelar'

fake.address()
# '426 Jordy Lodge
#  Cartwrightshire, SC 88120-6700'

fake.text()
```

```python
fake = Faker('ko_KR')

fake.name()
# '안채원'

fake.address()
# '부산광역시 강동구 양재천4거리 (영환김이리)'

fake.job()
# '변호사'
```



### 4.2 jobs APP

> 위 수업자료에 이어서 같은 프로젝트(crud) 에 2번째 app `jobs`를 만든다.

```bash
$ python manage.py startapp jobs
```

```python
# settings.py

INSTALLED_APPS = [
    'articles.apps.ArticlesConfig',
    'jobs.apps.JobsConfig',
    ...
]
```



**모델**

```python
# jobs/models.py

class Job(models.Model):
    name = models.CharField(max_length=20)
    past_job = models.TextField()
    
    def __str__(self):
        return self.name
```

```bash
$ python manage.py makemigrations jobs
$ python manage.py migrate jobs
```

- `jobs_job`이름의 테이블 생성



**관리자**

```python
# jobs/admin.py

from django.contrib import admin
from .models import Job

class JobAdmin(admin.ModelAdmin):
    list_display = ('pk', 'name', 'past_job',)

admin.site.register(Job, JobAdmin)
```

- 관리자 페이지에서 데이터 작성 테스트



**index view**

```python
# jobs/views.py

def index(request):
    return render(request, 'jobs/index.html')
```

```python
# crud/urls.py

from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('jobs/', include('jobs.urls')),
    path('articles/', include('articles.urls')),
    path('admin/', admin.site.urls),
]
```

```python
# jobs/urls.py

from django.urls import path
from . import views

app_name = 'jobs'
urlpatterns = [
    path('', views.index, name='index'),
]
```

```django
<!-- jobs/index.html -->

{% extends 'base.html' %}

{% block content %}
<h1>전생의 직업</h1>
<p>당신의 전생의 직업을 알려드립니다..</p>

<form action="#" method="POST">
  {% csrf_token %}
  <label for="name">NAME</label>
  <input type="text" name="name" id="name">
  <input type="submit" value="submit">
</form>
{% endblock %}
```



**past_life view**

```python
# jobs/urls.py

from django.urls import path
from . import views

app_name = 'jobs'
urlpatterns = [
    path('', views.index, name='index'),
    path('past_life/', views.past_life, name='past_life'),
]
```

```python
# jobs/views.py

def past_life(request):
    name = request.POST.get('name')
    
    # db 에 이름 있는지 확인
    person = Job.objects.filter(name=name).first()
    # person = Job.objects.get(name=name) 
    # 위에 것보다 이게 더 간단하지만 .get() 은 에러메시지를 띄운다.
    
    # DB 에 이미 같은 name 이 있으면 기존 name 의 past_job 가져오기, (레코드가 있으면 None이 아니니까 True일 것이다.)
    if person:
        past_job = person.past_job
    # 없으면 DB 에 새로 저장한 후 가져오기
    else:
        faker = Faker('ko-KR')
        past_job = faker.job()
        person = Job(name=name, past_job=past_job) # 새로운 레코드를 추가한다.
        person.save()
    context = {'person': person,}

    return render(request, 'jobs/past_life.html', context)
```

```django
<!-- jobs/index.html -->

{% extends 'base.html' %}

{% block content %}
<h1>전생의 직업</h1>
<p>당신의 전생의 직업을 알려드립니다..</p>

<form action="{% url 'jobs:past_life' %}" method="POST">
  {% csrf_token %}
  <label for="name">NAME</label>
  <input type="text" name="name" id="name">
  <input type="submit" value="submit">
</form>
{% endblock %}
```

```django
<!-- jobs/past_life.html -->

{% extends 'base.html' %}

{% block content %}
<h1>{{ person.name }} 님의 전생은 {{ person.past_job }}입니다.</h1>

<a href="{% url 'jobs:index' %}">다시하기</a>
{% endblock %}
```

- 테스트 후 DB 에 잘 저장되는지 확인



### 4.3 GIPHY

> https://giphy.com/
>
> https://developers.giphy.com/docs/api
>
> https://developers.giphy.com/docs/api/endpoint#search

> **python decouple**
>
> 1. 설치
>
>    - decouple은 설치 이후에 쉘을 재실행 할 필요가 없음
>
>      ```bash
>      $ pip install python-decouple
>      ```
>
> 2. `.env`
>
>    - 실제 문서에는 git repository의 root에 두라고 되어있음.
>
>    - 실제 환경변수의 이름은 **대문자, `_`사용**
>
>      ```python
>      # 02_django_crud/.env
>      
>      GIPHY_API_KEY='QOC6Crb4JRfLrJM3RT6wfGr9HJBDrdIS' # 띄어쓰기 없이!
>      ```
>
> 3. `views.py`
>
>    ```python
>    from decouple import config
>    
>    GIPHY_API = config('GIPHY_API')
>    ```



```bash
$ pip install requests
```

```python
# jobs/views.py

import requests
from faker import Faker
from decouple import config
from django.shortcuts import render
from .models import Job

def past_life(request):
    ...

    # GIPHY
    GIPHY_API_KEY = config('GIPHY_API_KEY')
    url = f'http://api.giphy.com/v1/gifs/search?api_key={GIPHY_API_KEY}&q={past_job}&limit=1&lang=ko'
    data = requests.get(url).json()
    image = data.get('data')[0].get('images').get('original').get('url')
    
    context = {'person': person, 'image': image,}

    return render(request, 'jobs/past_life.html', context)
```

```django
<!-- jobs/past_life.html -->

{% extends 'base.html' %}

{% block content %}
<h1>{{ person.name }} 님의 전생은 {{ person.past_job }}입니다.</h1>
<img src="{{ image }}" alt="giphy_image"><br>

<a href="{% url 'jobs:index' %}" class="btn btn-primary">다시하기</a>
{% endblock %}
```

- `IndexError at /jobs/past_life/`에러가 나오는 경우 GIPHY 에 해당 직업에 대한 검색 결과 gif 가 없기 때문에 발생 한다. (faker 가 너무 특이한 직업을 만들어 줘서 그렇다.)

- `Faker('ko-KR')`를 `Faker()`로 변경하거나 아래와 같이 예외처리를 해준다.

  ```python
  # jobs/views.py
  
  try:
      image = data.get('data')[0].get('images').get('original').get('url')
  except IndexError:
      image = None
  ```

- 완성된 view code

  ```python
  # jobs/views.py
  
  import requests
  from faker import Faker
  from decouple import config
  from django.shortcuts import render
  from .models import Job
  
  # Create your views here.
  def index(request):
      return render(request, 'jobs/index.html')
  
  
  def past_life(request):
      name = request.POST.get('name')
      person = Job.objects.filter(name=name).first()
  
      if person:
          past_job = person.past_job
      else:
          faker = Faker()
          past_job = faker.job()
          person = Job(name=name, past_job=past_job)
          person.save()
  
      GIPHY_API_KEY = config('GIPHY_API_KEY')
      url = f'http://api.giphy.com/v1/gifs/search?api_key={GIPHY_API_KEY}&q={past_job}&limit=1&lang=ko'
      data = requests.get(url).json()
      try:
          image = data.get('data')[0].get('images').get('original').get('url')
      except IndexError:
          image = None
  
      context = {'person': person, 'image': image}
  
      return render(request, 'jobs/past_life.html', context)
  ```



