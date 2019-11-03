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

`get_object_or_404(klass, *args, **kwargs)`

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

