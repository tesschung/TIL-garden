[TOC]

## Django_04

### 00. 폴더 구조

- 가상환경 설정

- 앱 생성 후 앱 등록 및 `settings.py` 기본 설정 진행

    ```
    TIL
    	...
    	03_django
    		00_django_intro
    		01_django_crud_query
		02_django_crud
    ```
    
    ```bash
    $ django-admin startproject crud .
    $ python manage.py startapp articles 
    ```
    
    

---



### 01. CREATE

#### 1.1 사전 작업

**템플릿 폴더 구조 및 url 분리**

- 템플릿 폴더 구조
  
    - `templates/articles/*.html`
- 프로젝트 폴더 url 설정
    - `articles/urls.py` 파일 생성

        ```python
        # crud/urls.py
        
        from django.contrib import admin
        from django.urls import path, include
        
        urlpatterns = [
            path('articles/', include('articles.urls')),
            path('admin/', admin.site.urls),
        ]
        ```
        
        

**`base.html` 설정**

- 프로젝트 폴더인 `crud` 에 `templates/base.html` 생성

- `settings.py` 에 위치 지정

    ```python
    # crud/settings.py
    
    'DIRS': [os.path.join(BASE_DIR, 'crud', 'templates')],
    ```
    
    ```django
    <!-- crud/templates/base.html -->
    
    <!DOCTYPE html>
    <html lang="en">
    
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="ie=edge">
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                  integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
            <title>Document</title>
        </head>
    
        <body>
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
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
                    integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
            </script>
        </body>
    
    </html>
    ```



**기본 페이지 설정**

```python
# 02_django_crud/articles/views.py

def index(request):
	return render(request, 'articles/index.html')
```

```python
# 02_django_crud/articles/urls.py

from django.urls import path
from . import views

urlpatterns = [
    path('', views.index),
]
```

```django
<!-- templates/articles/index.html -->

{% extends 'base.html' %}

{% block content %}
  <h1 class="text-center">Articles</h1>
{% endblock %}
```



#### 1.2 Model 설정

> **기존  필드에 데이터가 들어있는 상태에서 새로운 필드를 추가하고 migration 할 때 발새하는 이슈**
>
> ![Untitled-b2659d91-1e76-4169-89bb-3683d607dec7](https://user-images.githubusercontent.com/52446416/63489827-1a0f9480-c4ee-11e9-877a-7c6f7ca4dd2e.png)
>
> ![Untitled-c5b211d7-cd69-4852-b122-4af0b18aa8aa](https://user-images.githubusercontent.com/52446416/63489828-1a0f9480-c4ee-11e9-9dfb-515b10f94a9b.png)
>
> - 기존에 있었던 field 들에 이미 레코드가 있는 상황에서 새로운 field 를 추가하려는 상황
> - Django는 **'저기요 그럼 기존에 작성한 레코드에도 새로운 컬럼이 생기는데 이 컬럼은 우리는 비워둘 수 없걸랑요. 선택하세요 어떻게 할건지'**
> - 1번을 선택해 한번만 사용할 값을 넣는다고 하고 그 값을 1이라고 입력했다.

- **Migrations**

    ```python
    # articles/models.py
    
    from django.db import models
    
    # Create your models here.
    class Article(models.Model):
        title = models.CharField(max_length=20)
        content = models.TextField()
        created_at = models.DateTimeField(auto_now_add=True)
        updated_at = models.DateTimeField(auto_now=True)
    
        def __str__(self):
        return self.title
    ```
    
    ```bash
    $ python manage.py makemigrations
    $ python manage.py sqlmigrate articles 0001
    $ python manage.py showmigrations
    
    $ python manage.py migrate
    $ python manage.py showmigrations
    ```
    
    

#### 1.3 NEW

**new 페이지**

-  '사용자한테 입력을 받기 위한 태그가 input type text'만 존재하는 것이 아니다.

    ```python
    # articles/views.py
    
    def new(request):
	return render(request, 'articles/new.html')
    ```
    
    ```python
    # articles/urls.py
    
    from django.urls import path
    from . import views
    
    urlpatterns = [
		...
        path('new/', views.new),
    ]
    ```
    
    ```django
    <!-- templates/articles/new.html -->
    
    {% extends 'base.html' %}
    
    {% block content %}
      <h1 class="text-center">NEW</h1>
      <form action="/articles/create/" method="GET">
        <label for="title">TITLE</label>
        <input type="text" name="title" id="title"><br>
        <label for="content">CONTENT</label>
        <textarea name="content" id="content" cols="30" rows="5"></textarea><br>
        <input type="submit" value="submit">
      </form>
      <hr>
      <a href="/articles/">[back]</a>
    {% endblock %}
    
    
    <!-- 여기서 어 글을 써야 하는데 /articles/new/ 계속 입력해서 들어가야 하니까 불편하죠? 링크 만들기 -->
    
    
    <!-- templates/articles/index.html -->
    
    {% extends 'base.html' %}
    
    {% block content %}
      <h1 class="text-center">Articles</h1>
      <a href="/articles/new/">[NEW]</a>
      <hr>
    {% endblock %}
    ```
    
    

#### 1.4 CREATE

- **`request.GET` 의 내부 확인하기**

  ```bash
  $ pip install ipython
  ```

  ```python
  # articles/views.py
  
  from IPython import embed
  
  def create(request):
      embed() # 서버 일시정지 후 python shell 작동
      return render(request, 'articles/create.html')
  ```

  ```python
  # articles/urls.py
  
  urlpatterns = [
      path('', views.index),
      path('new/', views.new),
      path('create/', views.create),
  ]
  ```

  ```bash
  In [1]: request.GET                                                                   
  Out[1]: <QueryDict: {'title': ['제목1'], 'content': ['내용1']}>
  
  In [2]: request.GET.get('title')                                                      
  Out[2]: '제목1'
  
  In [3]: request.GET.get('content')                                                    
  Out[3]: '내용1'
  ```

  

- **create 로직 구현**

  ```python
  # articles/views.py
  
  from .models import Article
  
  
  def create(request):
      title = request.GET.get('title') 
      content = request.GET.get('content')
      
  		# 1.
  		# article = Article()
  		# article.title = title
  		# article.content = content
  		# article.save()
  		
  		# 2. 
      # Article.objects.create(title=title, content=content)
  		
      article= Article(title=title, content=content)
      article.save()
      return render(request, 'articles/create.html')
  ```

  ```django
  <!-- templates/articles/create.html-->
  
  {% extends 'base.html' %}
  
  {% block content %}
    <h1 class='text-center'>성공적으로 글이 작성되었습니다.</h1>
  {% endblock %}
  ```

  

#### 1.5 admin page

- `createsuperuser` 를 통해 관리자 유저 생성

    ```bash
    $ python manage.py createsuperuser
    ```

- 서버를 실행하고 우리가 작성한 글을 관리자 페이지에서 확인 해보자

    ```python
    # articles/admin.py
    
    from django.contrib import admin
    from .models import Article
    
    class ArticleAdmin(admin.ModelAdmin):
        list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
    
    admin.site.register(Article, ArticleAdmin)
    ```


>  **만약 한번에 모든 필드를 보고 싶다면 따로 함수를 작성하거나 다른 방식으로 커스텀해야 한다.(참고)**
>
> [Model _meta API | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/meta/#module-django.db.models.options)
>
> ```python
> # 1
> def get_all_fields(self):
>         return tuple(field.name for field in self._meta.get_fields())
> 
> class AricleAdmin(admin.ModelAdmin):
>     list_display = get_all_fields(Article)
>     
> admin.site.register(Article, AricleAdmin)
> ```
>
> ```python
> # 2
> class AricleAdmin(admin.ModelAdmin):
>     list_display = tuple(field.name for field in Article._meta.get_fields())
>     
> admin.site.register(Article, AricleAdmin)
> ```



#### 1.6 Read

**`index.html` 수정**

```python
# articles/views.py

from .models import Article

def index(request):
    articles = Article.objects.all() 
		context = {'articles': articles,}
    return render(request, 'articles/index.html', context)
```

```django
<!--templates/articles/index.html-->

{% extends 'base.html' %}

{% block content %}
  <h1 class="text-center">Articles</h1>
  <a href="/articles/new/">[NEW]</a>
  <hr>
  {% for article in articles %}
    <p>글 번호: {{ article.pk }}</p>
    <p>글 제목: {{ article.title }}</p>
    <p>글 내용: {{ article.content }}</p>
    <hr>
  {% endfor %}
{% endblock %}
```



**게시글 순서 변경**

- `#1 ` 의 경우 기존에 DB에 있는 순서를 파이썬이 변경한다.

- `#2` 의 경우 DB가 변경한다.

- 참고로, `order_by` 는 단일 쿼리에서는 사용할 수 없고 QuerySet 에서만 사용 가능하다! 각각의 쿼리들을 정렬해 주는 메서드이기 때문!

    ```python
    # articles/views.py
    
    def index(request):
        #1. articles = Article.objects.all()[::-1]	 # 파이썬이 변경
        #2. articles = Artile.objects.order_by('-pk')  # DB에서 변경
        context = {'articles': articles}
        return render(request, 'articles/index.html', context)
    ```

    

- 이제 글이 작성되면 create.html 이 아닌 index.html 로 돌아가게 해보자

    ```python
    # boards/views.py
    def create(request):
        ...
        
        return render(request, 'articles/index.html')
    ```



---



### 02. GET → POST

- 그런데 글을 작성하면 빈 index 페이지가 뜨고 **작성된 글을 확인하기 위해서는 주소를 직접 수정해서 index로 가야만 한다**.
- 글이 보이지 않았던 이유는 보여지는 페이지 자체는 index 이지만 url은 index 로 돌아가 못했기 때문이다.(url은 여전히 create 에 머물고 있다.) 즉, 단순히 html 문서만 보여준 것이다.



**3가지 이유에서 우리는 글을 작성할 때 GET 요청이 아닌 POST 요청을 해야 한다.**

1. 사용자는 Django에게 '**HTML 파일 줘(GET)**' 가 아니라 '**~한 레코드(글)을 생성해(POST)**' 이기 때문에 GET보다는 POST 요청이 맞다. 

2. 데이터는 URL에 직접 노출되면 안된다. (우리가 주소창으로 접근하는 방식은 모두 GET 요청) query의 형태를 통해 DB schema를 유추할 수 있고 이는 보안의 측면에서 매우 취약하다.

3. 모델(DB)을 건드리는 친구는 GET이 아닌 POST 요청! 왜? 중요하니까 **최소한의 신원 확인**이 필요하다! 

   ```python
   # 주소창에 이렇게 글 작성 시연
   
   articles/create/?title=제목3&content=내용3
   
   # articles/new 페이지에서 글을 작성하고 submit 버튼을 누르면 주소창에 어떻게 query가 전달되는지 관찰해보자
   ```
   
   

#### 2.1 GET → POST

**`new.html` 수정**

```django
<!-- templates/articles/new.html -->

{% extends 'base.html' %}

{% block content %}
  <h1 class="text-center">NEW</h1>
  <form action="/articles/create/" method="POST">
    {% csrf_token %}
    <label for="title">TITLE</label>
    <input type="text" name="title" id="title"><br>
    <label for="content">CONTENT</label>
    <textarea name="content" id="content" cols="30" rows="5"></textarea><br>
    <input type="submit" value="submit">
  </form>
  <hr>
  <a href="/articles/">[back]</a>
{% endblock %}
```

```python
# articles/views.py

def create(request):
    title = request.POST.get('title') # POST 변경
    content = request.POST.get('content') # POST 변경

    article = Article(title=title, content=content)
    article.save()
    return render(request, 'articles/index.html')
```

- 글은 잘 작성되지만 여전히 index 페이지는 제대로 출력되지 않는다.



#### 2.2 Redirect

- POST 요청은 HTML 문서를 렌더링 하는 것이 아니라 **'~~ 좀 처리해줘(요청)'의 의미이기 때문에 요청을 처리하고 나서의 요청의 결과를 보기 위한 페이지로 바로 넘겨주는 것이 일반적**이다.

    ```python
    # articles/views.py
    
    from django.shortcuts import render, redirect # import redirect
    
    ...
    def create(request):
        title = request.POST.get('title') 
        content = request.POST.get('content')
        
        article = Article(title=title, content=content)
        article.save()
    return redirect('/articles/') # 메인페이지에서 작성한 글을 바로 확인
    ```
    
    - 이제 글을 작성함과 동시에 index 로 url 이 redirect 된다.
    - 필요없어진 `create.html` 은 삭제한다.



**POST 요청으로 변경 후 변화하는 것**

- POST 요청을 하게 되면 form을 통해 전송한 데이터를 받을 때도 `request.POST.get()` 로 받아야 함
- 글이 작성되면 실제로 주소 창에 내가 넘긴 데이터가 나타나지 않는다.(POST 요청은 HTTP body에 데이터를 전송함)
- POST는 html을 요청하는 것이 아니기 때문에 html 파일을 받아볼 수 있는 곳으로 다시 redirect 한다.



---



### 03. DETAIL

- 기본적으로 **게시판에서는 글 번호/제목**만 보여주고 **해당 글을 클릭 했을 때 상세한 글**을 보여줘야 한다.
- 우리가 해당 글의 제목을 클릭 했을 때 이동하는 페이지는 글의 번호(pk)를 활용해서 각각의 페이지를 따로 구현해야 한다.
- 무엇을 활용할 수 있을까?! Variable Routing (URL의 특정 부분을 변수화 시켜서 활용→PK)



**views 설정** 

```python
# articles/views.py

def detail(request, pk):
    article = Article.objects.get(pk=pk) 
		context = {'article': article}
    return render(request, 'articles/detail.html', context)
```

- 오른쪽 pk는 variable routing을 통해 받은 pk
- 왼쪽 pk는 DB에 저장된 레코드의 id



**urls 설정**

- variable routing → 주소를 통해 요청이 들어올 때 특정 값을 변수화 시킬 수 있다.

- 우리는 pk 값을 변수화 시켜 사용할 것 pk는 detail 함수의 pk라는 이름의 인자로 넘어가게 된다!

- `index.html` 의 `<a href="/articles/{{ article.pk }}/">[글 보러가기]</a>`  부분에서 `{{ article.pk }}` 가 실제 특정 숫자(pk값)일 것이고 요청이 보내질 때 숫자로 넘어 간다.

- 그럼 path에서 해당하는 숫자는 pk라는 변수에 저장될 것이다.

    ```python
    # articles/urls.py
    
    urlpatterns = [
    		...
        path('<int:pk>/', views.detail), # articles/1, articles/2 이런식의 접근
    ]
    ```
    
    

**templates 설정**

```django
<!-- templates/articles/detail.html -->

{% extends 'base.html' %}

{% block content %}
  <h1 class='text-center'>DETAIL</h1>
  <h2>{{ article.pk }} 번째 글</h2>
  <hr>
  <p>제목: {{ article.title }}</p>
  <p>내용: {{ article.content }}</p>
  <p>작성 시각: {{ article.created_at }}</p>
  <p>수정 시각: {{ article.updated_at }}</p>
  <hr>
  <a href="/articles/">[back]</a>
{% endblock  %}
```

- 하지만 지금은 1번 글, 2번 글 등을 보기 위해 주소창에 `articles/1` `articles/2` 이런식으로 요청을 보내야 한다. 이를 해결 하기 위해 index 페이지에 링크를 달아보자.

    ```django
    <!-- templates/articles/index.html -->
    
    {% extends 'base.html' %}
    
    {% block content %}
      <h1 class="text-center">Articles</h1>
      <a href="/articles/new/">[NEW]</a>
      <hr>
      {% for article in articles %}
        <p>글 번호: {{ article.pk }}</p>
        <p>글 제목: {{ article.title }}</p>
        <a href="/articles/{{ article.pk }}/">[DETAIL]</a>
        <hr>
      {% endfor %}
    {% endblock %}
    ```
    
    

**create 로직 변경**

- 글을 작성하면 바로 detail page 로 redirect 하도록 수정 해보자!

    ```python
    # articles/views.py
    
    def create(request):
        title = request.POST.get('title') 
        content = request.POST.get('content')
    
        article = Article(title=title, content=content)
        article.save()
        return redirect(f'/articles/{article.pk}/')
    ```



> **빈 값으로도 글이 작성되는 이유(참고)**
>
> [Model instance reference | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/instances/#validating-objects)
>
> [Form and field validation | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/forms/validation/#form-and-field-validation)
>
> - 기본적으로 `blank=False` 을 가지고 있는 필드는 빈 데이터를 허용하지 않는다.
>
> - 하지만 현재 코드에서 글이 작성되는 이유는 **blank 는 유효성과 관련되어 있기 때문**이다. (validation-related)
>
> - `.full_clean()` 메서드를 통해 유효성 검사를 할 때 빈 값에 대한 검증이나 추가 다른 옵션들에 대한 검증을 진행한다.
>
> - 추후에 제대로 작성하는 유효성 검증을 할 것이기 때문에 아래 코드는 참고만 해보자.
>
>   ```python
>   # articles/views.py
>   
>   from django.core.exceptions import ValidationError
>   
>   def create(request):
>       try:
>           title = request.POST.get('title') 
>           content = request.POST.get('content')
>           article = Article(title=title, content=content)
>           article.full_clean()
>       except ValidationError:
>           raise ValidationError('Your Error message')
>       else:
>           article.save()
>           return redirect(f'/articles/{article.pk}/')
>   ```
>
>   - **`full_clean(exclude=None, validate_unique=True)`**
>     - 이 메소드는 `.clean_fields()`, `.clean()` 및 `.validate_unique()` (validate_unique가 True 인 경우)를 이 순서대로 호출한다.
>     - 세 단계의 오류를 모두 포함하고 `message_dict` 속성이 있는 `ValidationError` 를 발생시킨다.



---



### 04. DELETE

**views 설정**

- delete 로직의 경우도 **detail 페이지와 마찬가지로 Variable Routing을 사용**해야 한다. 왜? 모든 글을 다 삭제 하는게 아니라 내가 원하는 특정 detail 페이지의 글을 삭제한다.

- **글을 삭제하고 나서 최종적으로 다시 글이 모여있는 index 페이지로 돌려주면 된다**!

- 어디서 글을 삭제하면 좋을까? detail 페이지에 작성하자 (특정 글을 삭제할 것이니!)

    ```python
    # articles/views.py
    
    def delete(request, pk):
        article = Article.objects.get(pk=pk)
        article.delete()
        return redirect('/articles/')
    ```
    
    

**urls 설정**

```python
# articles/urls.py

urlpatterns = [
		...
    path('<int:pk>/delete/', views.delete),
]
```



**templates 설정**

```django
{% extends 'base.html' %}

{% block content %}
  <h1 class='text-center'>DETAIL</h1>
  <h2>{{ article.pk }} 번째 글</h2>
  <hr>
  <p>제목: {{ article.title }}</p>
  <p>내용: {{ article.content }}</p>
  <p>작성 시각: {{ article.created_at }}</p>
  <p>수정 시각: {{ article.updated_at }}</p>
  <hr>
  <a href="/articles/{{ article.pk }}/delete/">[DELETE]</a><br>
  <a href="/articles/">[back]</a>
{% endblock  %}
```



---



### 05. UPDATE

- UPDATE 로직은 2개의 view 함수가 필요하다.
- 첫번째는 수정사항을 입력할 페이지 edit view , 두번째는 실제 db에 수정이 이루어지는 update view 로 작업한다.

#### 5.1 EDIT

**views 설정**

- update도 마찬가지로 delete와 detail 페이지처럼 특정한 글만을 수정해야 하기 때문에 variable routing이 필요

- 글은 detail 페이지에서 수정하는 것이 일반적이다.

    ```python
    # articles/views.py
    
    def edit(request, pk):
        article = Article.objects.get(pk=pk)
    		context = {'article': article}
        return render(request, 'articles/edit.html', context)
    ```
    
    

**urls 설정**

```python
# articles/urls.py

from django.urls import path
from . import views

urlpatterns = [
		...
    path('<int:pk>/edit/', views.edit),
]
```



**templates 설정**

- `new.html` 구조와 다르지 않기 때문에 그대로 가져온다.

- 수정은 기존에 입력 되어 있던 데이터를 보여주는 것이 좋기 때문에 html 태그에 `value=` 값을 `{{ board.title }}` 와 같이 입력한다.
    - `textarea` 태그는 value 속성이 없으므로 태그 값으로 작성한다.
    - **없다고해서 update 동작에 문제가 생기는 것은 아니다.**
    
- action 은 앞으로 작성할 update url 로 설정한다.

- back 주소 또한 index 가 아닌 해당 글의 detail 페이지로 이동한다.

- `new.html` 의 내용을 그대로 가져온 후 일부 내용 수정

    ```django
    <!-- articles/edit.html -->
    
    {% extends 'base.html' %}
    
    {% block content %}
      <h1 class="text-center">EDIT</h1>
      <form action="/articles/{{ article.pk }}/update/" method="POST">
        {% csrf_token %}
        <label for="title">TITLE</label>
        <input type="text" name="title" id="title" value="{{ article.title }}"><br>
        <label for="content">CONTENT</label>
        <textarea name="content" id="content" cols="30" rows="5">{{ article.content }}</textarea><br>
        <input type="submit" value="submit">
      </form>
      <hr>
      <a href="/articles/{{ article.pk }}">[back]</a>
    {% endblock %}
    ```

- `detail.html` 에 edit 으로 가는 링크 작성

    ```django
    <!-- articles/detail.html -->
    
    {% extends 'base.html' %}
    
    {% block content %}
      <h1 class='text-center'>DETAIL</h1>
      <h2>{{ article.pk }} 번째 글</h2>
      <hr>
      <p>제목: {{ article.title }}</p>
      <p>내용: {{ article.content }}</p>
      <p>작성 시각: {{ article.created_at }}</p>
      <p>수정 시각: {{ article.updated_at }}</p>
      <hr>
      <a href="/articles/{{ article.pk }}/edit/">[EDIT]</a>
      <a href="/articles/{{ article.pk }}/delete/">[DELETE]</a><br>
      <a href="/articles/">[back]</a>
    {% endblock %}
    ```
    
    

#### 5.2 UPDATE

**views 설정**

- create 로직과 마찬가지로 '글이 수정되었습니다' 라는 메시지를 띄울 문서가 필요 없다.

- 수정이 잘 되었는지 바로 확인할 수 있도록 detail 페이지로 redirect 시켜야 한다.

    ```python
    # articles/views.py
    
    def update(request, pk):
        article = Article.objects.get(pk=pk)
        article.title = request.POST.get('title')
        article.content = request.POST.get('content')
        article.save()
        return redirect(f'/articles/{article.pk}/')
    ```
    
    

**urls 설정**

```python
# articles/urls.py

urlpatterns = [
		...
    path('<int:pk>/update/', views.update),
]
```



**edit 페이지 → detail 페이지 링크 추가**

```django
<!-- articles/edit.html -->

{% extends 'base.html' %}

{% block content %}
  <h1 class='text-center'>EDIT</h1>
    ...
  <a href="/articles/{{ article.pk }}/">[back]</a>
{% endblock %}
```



- CREATE → READ → DELETE → UPDATE 작성 순서. (개념의 계층화)
    - 글을 생성
    - 생성된 특정 글을 읽고
    - 생성된 특정 글을 삭제하고
    - 생성된 특정 글을 수정한다.
