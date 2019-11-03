[TOC]

---

## 00. 1:N Relation

### 0.1 Model Relation

> [Model field reference - Relationship fields](https://docs.djangoproject.com/ko/2.2/ref/models/fields/#module-django.db.models.fields.related)

> **ForeignKey (참조키, 외래키)**
>
> **개념**
>
> - 외래 키는 참조하는 테이블에서 1개의 키(속성 또는 속성의 집합)에 해당하고, 참조하는 측의 관계 변수는 참조되는 측의 테이블의 키를 가리킨다.
> - 하나(또는 복수) 다른 테이블의 기본 키 필드를 가리키는 데이터의 참조 무결성(Referential Integrity)를 확인하기 위하여 사용된다. 즉, 허용된 데이터 값만 데이터베이스에 저장되는 것이다.
>
> **특징**
>
> - 참조 키의 값으로는 부모 테이블에 존재하는 키의 값 만을 넣을 수 있다 => 참조 무결성 참조 키를 사용하여 **부모 테이블의 유일한 값을 참조**한다. ( 예를 들어, 부모 테이블의 기본 키를 참조 )
> - 참조 키의 값이 부모 테이블의 기본 키 일 필요는 없지만 **유일**해야 한다.
>
> `on_delete`
>
> - ForeignKey의 필수 인자이며, ForeignKey가 참조하고 있는 부모(Article) 객체가 사라졌을 때 달려 있는 댓글들을 어떻게 처리할 지 정의
> - Database Integrity(데이터 무결성)을 위해서 매우 중요한 설정이다.
>   - **개체 무결성**: 식별자는 Null 혹은 중복일 수 없다.(PK / NOT NULL)
>   - 참조 무결성: 릴레이션과 관련된 설정(모든 외래 키 값은 두 가지 상태 가운데 하나에만 속함)
>   - 범위 / 도메인 무결성 : 컬럼은 지정된 형식을 만족해야한다. (Integer Datetime 등 / Not Null / Default / Check)
>
> **possible values for `on_delete`**
>
> - `CASCADE`: **부모 객체가 삭제 됐을 때 이를 참조하는 객체도 삭제**한다.
> - `PROTECT`: 참조가 되어 있는 경우 오류 발생.
> - `SET_NULL`: 부모객체가 삭제 됐을 때 모든 값을 NULL로 치환. (NOT NULL 조건시 불가능)
> - `SET_DEFAULT`: 모든 값이 DEFAULT 값으로 치환 (DEFAULT 설정 있어야함. DB에서는 보통 default 없으면 null로 잡기도 함. 장고는 아님.)
> - `SET()`: 특정 함수 호출.
> - `DO_NOTHING`: 아무것도 하지 않음. 다만, 데이터베이스 필드에 대한 SQL `ON DELETE`제한 조건을 설정해야 한다.

### 0.2 Comment Model 정의

**`models.py`정의**

- 각각의 Comment가 하나의 게시글에 관계(relation)된다.

- 한 테이블에 있는 두 개 이상의 레코드가 다른 테이블에 있는 하나의 레코드를 참조할 때, 두 모델 간의 관계를 일대다 관계라고 한다. 이때 참조하는 대상이 되는 테이블의 필드는 유일한 값 이어야 한다. (ex. PK)

- Article : Comment = 1 : N → 하나의 게시글에는 여러 개의 댓글이 달릴 수 있다.

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

  

**Metadata**

> [Model Meta options | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/options/#model-meta-options)

- `class Meta`와 같이 선언하여 모델에 대한 모델-레벨의 메타데이타를 선언할 수 있다.

- 유용한 기능들 중 하나는 모델 타입을 쿼리(query)할 때 반환되는 기본 레코드 순서를 제어하는 것이다. (`ordering`속성)

  ```python
  # 예시
  # 알파벳 순 (A-Z) 순으로 내용(content)을 정렬한 후
  # 작성일(created_at) 별로 가장 최근 것부터 가장 오래된 것 순으로 정렬
  ordering = ['content', '-created_at']
  ```

  

**migration**

```bash
$ python manage.py makemigrations
```

- `article`라는 이름으로 외래 키 설정을 하고 설계도(`0002_comment.py`)를 확인해보면, `to='articles.Article'`라고 되어있다. 즉, **articles 라는 앱의 Article 이라는 클래스(테이블)에 연결**되었음을 알 수 있다.

```bash
$ python manage.py sqlmigrate articles 0002
```

```sql
BEGIN;
--
-- Create model Comment
--
CREATE TABLE "articles_comment" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content" varchar(200) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "article_id" integer NOT NULL REFERENCES "articles_article" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "articles_comment_article_id_59ff1409" ON "articles_comment" ("article_id");
COMMIT;
```

- `article_id`라는 이름의 컬럼이 생긴다는 것을 유의 깊게 보자.

- 우리가 설정한 외래 키 이름 `article`과 `_id`가 조합 되어 외래 키 관련 컬럼이 만들어진다.

  ```bash
  $ python manage.py migrate
  $ python manage.py showmigrations # migration 상태 확인
  ```

  

**Table 직접 확인하기**

```sql
$ sqlite3 db.sqlite3

sqlite> .tables
articles_article            auth_user_user_permissions
articles_comment            django_admin_log          
auth_group                  django_content_type       
auth_group_permissions      django_migrations         
auth_permission             django_session            
auth_user                   jobs_job                  
auth_user_groups


sqlite> .schema articles_comment
CREATE TABLE IF NOT EXISTS "articles_comment" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content" varchar(200) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "article_id" integer NOT NULL REFERENCES "articles_article" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "articles_comment_article_id_59ff1409" ON "articles_comment" ("article_id");

# 우리는 분명히 컬럼을 설정할 때  article 이라고 이름 붙였지만, 실제 ORM이 SQL문을 만들 때 해당 이름을 article_id 로 만들었다. article 라고 이름 붙인 컬럼에  [컬럼이름_id] 형태로 만들어준다.

# 또한 참조하는 것은 articles_article 테이블 (REFERENCES "articles_article" ("id"))
```

- `article_id`라는 컬럼이 생성되었다. 우리가 댓글을 작성하면 댓글이 해당하는 글이 **몇 번째 게시 글의 댓글인지 알아야 하기 때문**

- 만약 ForeignKey 를 article 이라고 하지 않고 `abcd = models.ForeignKey(..)`형태로 생성 했다면 `abcd_id`로 만들어진다. 이렇게되면 모델 관계를 파악하는 것이 어렵기 때문에 **부모 클래스명의 소문자로 작성하는 것이 바람직하다.**

  

**`shell_plus`로 댓글 생성 연습하기**

- Comment 모델의 객체 표현을 바꾸고 진행

  ```python
  # articles/models.py
  
  def __str__(self):
      # return self.content
      return f'<Article({self.article_id}): Comment({self.pk})-{self.content}>'
  ```

- django-extensions

  ```bash
  $ pip install ipython
  $ pip install django-extensions
  ```

  ```python
  # crud/settings.py
  
  INSTALLED_APPS = [
      'articles.apps.ArticlesConfig',
      'jobs.apps.JobsConfig',
      'django_extensions',
      ...
  ]
  ```

  ```bash
  $ python manage.py shell _plus
  ```

  

- shell_plus

  ```python
  # 1. 특정 게시글 불러오기
  article = Article.objects.get(pk=1)
  ```

  ```python
  # 2. 댓글 생성
  comment = Comment() # class Comment의 인스턴스 comment 생성
  comment.content = 'first comment' 
  comment.article = article # article 객체 자체를 넣는다.
  # 이 작업을 해줘야 해당 생성된 comment 객체 안에 article 이라는 글을 넣을 수 있다.
  # 또는 comment.article_id = article.pk 처럼 pk 값을 직접 외래키 컬럼에 넣어 줄 수도 있다.
  # 여기서는 article 에 1번 게시글이 저장되어 있으니 1번 게시물을 comment 객체가 참조할 수 있도록 넣어준다.
  comment.save()
  ```

  ```python
  # 3-1. 댓글 번호 확인
  comment.pk 
  1
  
  # 3-2. 댓글 1의 내용 확인
  comment.content
  'first comment'
  
  # 3-3. 해당 댓글이 몇 번째 게시글에 연결되어 있는지 확인
  comment.article_id 
  1
  
  # 여기서 article_id 는 해당 댓글이 몇번째 게시글에 연결되어 있는지를 알기 위해 댓글에 부여한 id 이다.(몇번째 게시글인지) 
  # 애초에 다른 컬럼처럼 comment.content / comment.created_at 과 같이 접근하는 방식과 동일하다. 
  # 다만, article 이라고 컬럼명을 설정해도 실제로 부여되는 컬럼명은 article_id 이기 때문에 comment.article_id로 접근했을 뿐이다. (article_pk 사용 불가)                                                    
  
  # 3-4. 댓글 객체 확인
  comment
  <Comment: <Article(1): Comment(1)-first comment>>
  
  # 3-5. 해당 댓글의 게시물 내용을 보여줌
  comment.article
  <Article: 제목1>
  ```

  ```python
  # 4-1. 댓글의 게시물의 pk
  comment.article.pk            
  1
  
  # 4-2. 댓글의 게시물의 content
  comment.article.content          
  '내용1'
  ```

  ```python
  # 5. 두번째 댓글 작성
  # 위에서는 먼저 댓글 객체를 만들고 content를 넣고 article 이라는 게시글 객체를 따로 넣었다. 이번에는 한번에 넣어주자
  # 여기서도 article 은 위에서 .get(pk=1)이라는 1번 게시물을 댓글이 참조하기 때문에 1번 글에 대한 2번째 댓글이 생성될 것이다.
  comment = Comment(article=article, content='second comment') 
  comment.save()
  ```

  ```python
  # 6-1. 댓글2 pk 확인
  comment.pk
  2
  
  # 6-2. 댓글2 객체 정보 확인
  comment
  <Comment: <Article(1): Comment(2)-second comment>>
  
  # 6-3. 댓글2 내용 확인
  comment.content 
  'second comment'
  
  # 여전히 이 댓글은 1번째 게시물의 댓글 임을 알 수 있다.
  comment.article_id
  1
  ```

  

**admin에 Comment model 등록**

```python
# articles/admin.py

from .models import Board, Comment

class CommentAdmin(admin.ModelAdmin):
    list_display = ('pk', 'content', 'created_at', 'updated_at', 'article_id',)

admin.site.register(Comment, CommentAdmin)
```

- admin page 에서 실습으로 작성한 댓글 확인하기



**1 : N 관계 활용하기**

- **Article(1)**: **Comment(N)**: `comment_set`

  - `article.comment`형태로는 가져올 수 없다. 게시글에 몇 개의 댓글이 있는지 Django ORM이 보장할 수 없기 때문에! (개념적으로는 그런데 본질적으로는 애초에 Article 클래스에 Comment 와의 어떠한 관계도 연결하지 않음)
  - article 는 comment 가 있을 수도 있고, 없을 수도 있기 때문이다.

- **Comment(N)**: **Article(1)**: `article`

  - 그에 반해 댓글의 경우 `comment.article`식의 접근이 가능한 이유는 어떠한 댓글이든 반드시 자신이 참조하고 있는 게시글이 있으므로 이와 같이 접근할 수 있다.

- `dir(article)`/ `dir(comment)`를 통해서 사용할 수 있는 메서드를 직접 확인해보자.

  ```bash
  $ python manage.py shell_plus
  ```

  ```python
  article = Article.objects.get(pk=1)
  ```

  ```python
  dir(Article)
  
  [
   ...중략...,
   'comment_set',
   'content',
   'created_at',
   'date_error_message',
   'delete',
   'from_db',
   'full_clean',
   ...중략...
  ]
  ```

  ```python
  # 1. article 의 입장에서 댓글 가져오기(1 -> N)
  article = Article.objects.get(pk=1)
  article.comment_set.all() # 1번 게시글의 딸려있는 댓글 set 전부다 가지고와!
  # <QuerySet [<Comment: <Article(1): Comment(2)-second comment>>, <Comment: <Article(1): Comment(1)-first comment>>]>
  
  
  # 2. 댓글 QuerySet 조작
  comments = article.comment_set.all()
  comments.first().content
  'second comment'
  comments[0].content
  'second comment'
  
  
  # 3. comment 의 입장에서 참조하고 있는 게시글 가져오기 (N -> 1)
  comment = Comment.objects.get(pk=1) # pk 는 댓글의 pk 를 의미!
  comment.article # pk 가 1인 댓글은 어떤 게시글에 댓글인지 확인
  # <Article: 제목1>
  comment.article_id # 해당 댓글이 몇 번 게시글에 엮여 있는지 찾아줘!
  ```



**related_name**

> https://docs.djangoproject.com/en/2.2/ref/models/fields/#django.db.models.ForeignKey.related_name

- 위에서 확인한 것처럼 부모 테이블에서 역으로 참조할 때 `모델이름_set` 이라는 형식으로 참조한다. (**역참조**)

- related_name 값은 django 가 기본적으로 만들어 주는 `_set` 명령어를 임의로 변경할 수 있다.

  ```python
  # articles/models.py
  
  class Comment(models.Model):
      article = models.ForeignKey(Article, on_delete=models.CASCADE, related_name='comments')
    ...
  ```
  
- 위와 같이 변경하면 `article.comment_set` 은 더이상 사용할 수 없고 `article.comments` 로 대체된다.

> 1:N 관계에서는 거의 사용하지 않지만 M:N 관계에서는 반드시 사용해야 할 경우가 발생한다.



------

## 01. Comment

### 1.1 Create

> 코드는 반드시 위에서 아래로, 좌에서 우로 작성하는 것이 아니다.
>
> ```python
> # articles/views.py
> 
> def comments_create(request, article_pk):
>     # 댓글을 달 게시물
>     article = Article.objects.get(pk=article_pk)
>     if request.method == 'POST':
>         pass
>     else:
>         return redirect(article)
> ```
>
> - GET 을 먼저 작성하고 detail template 작성하고 다시 여기 view 에 와서 POST 를 마저 작성하는 흐름이 바람직하다.



**create**

```python
# articles/views.py

from .models import Article, Comment

def comments_create(request, pk):
    # 댓글을 달 게시물
    article = Article.objects.get(pk=pk)
    if request.method == 'POST':
        pass
    else:
        return redirect(article)
```

- 앞으로 `pk`가 article 과 comment 모델에서 각각 (**article 의 pk, comment 의 pk**) 사용 되기 때문에 명시적인 분류가 필요하다. `article_pk`, `comment_pk`등으로 구분하자! → `urls.py`와 `views.py`인자 수정!

  ```python
  # articles/views.py
  
  def detail(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      ...
  
  
  def delete(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      ...
  
  
  def update(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      ...
  
  def comments_create(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      ...
  ```

  ```python
  # articles/urls.py
  
  from django.urls import path
  from . import views
  
  app_name = 'articles'
  urlpatterns = [
      path('', views.index, name='index'),
      path('create/', views.create, name='create'),
      path('<int:article_pk>/', views.detail, name='detail'),
      path('<int:article_pk>/delete/', views.delete, name='delete'),
      path('<int:article_pk>/update/', views.update, name='update'),
  ]
  ```

  ```python
  # articles/urls.py
  
  from django.urls import path
  from . import views
  
  app_name = 'articles'
  urlpatterns = [
      ...
      path('<int:article_pk>/comments/', views.comments_create, name='comments_create'),
  ]
  ```

  

- **detail page 에 댓글 작성 form 추가**

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    ...
    <p>수정 시각: {{ article.updated_at }}</p>
    <hr>
    <!-- 댓글 form -->
    <form action="{% url 'articles:comments_create' article.pk %}" method="POST">
      {% csrf_token %}
      <label for="content">COMMENT</label>
      <input type="text" name="content" id="content">
      <input type="submit" value="submit">
    </form>
    <hr>
    ...
  {% endblock %}
  ```

  

- 우리가 `models.py`에서 `Comment`클래스를 정의 했을 때 필드(컬럼)을 `article`과`content`2 개를 설정했다. 데이터 무결성의 원칙에 따라 해당 필드는 레코드가 없는 NULL 일 상태 일 수 없기 때문에 값을 넣어 주어야 한다.

  ```python
  # articles/views.py
  
  def comments_create(request, article_pk):
      # 댓글을 달 게시물
      article = Article.objects.get(pk=article_pk)
      if request.method == 'POST':
          # form 에서 넘어온 댓글 정보
          content = request.POST.get('content')
          # 댓글 생성 및 저장
          comment = Comment(article=article, content=content) # comment = Comment(article_id=article_pk, content=content)
          comment.save()
          return redirect(article) # return redirect('articles:detail', comment.article_id)
      else:
          return redirect(article)
  ```

  - 댓글을 작성한 후 admin 페이지에서 확인해보자.



### 1.2 Read

- 특정 article 에 있는 모든 댓글을 가져온 후 template 으로 전달한다.

  ```python
  # articles/views.py
  
  def detail(request, article_pk):
      article = Article.objects.get(pk=article_pk)
      # article 의 모든 댓글 가져오기
      comments = article.comment_set.all()
      context = {'article': article, 'comments': comments,}
      return render(request, 'articles/detail.html', context)
  ```

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    ...
    <p>수정 시각: {{ article.updated_at }}</p>
    <hr>
    <!-- 댓글 목록 -->
    {% for comment in comments %}
      <li>{{ comment.content }}</li>
    {% endfor %}
    <hr>
    ...
  {% endblock %}
  ```

  

### 1.3 Delete

```python
# articles/views.py

def comments_delete(request, article_pk, comment_pk):
    if request.method == 'POST':
        comment = Comment.objects.get(pk=comment_pk)
        comment.delete()
        return redirect('articles:detail', article_pk)
    else:
        return redirect('articles:detail', article_pk)

# or

def comments_delete(request, article_pk, comment_pk):
    if request.method == 'POST':
        comment = Comment.objects.get(pk=comment_pk)
        comment.delete()
    return redirect('articles:detail', article_pk)
```

- 왜 redirect() 에 인자에 `[article.pk](<http://board.pk>)`가 아닌 `article_pk`로 썼을까? comments_create() 에서는 `article`이라는 인스턴스 객체가 있지만, comments_delete() 의 경우는 함수 안에 article 객체가 없다. 즉, 인자로 넘겨 받은 `article_pk`사용해야 한다 !

  ```python
  # articles/urls.py
  
  urlpatterns = [
      ...
      path('<int:article_pk>/comments/<int:comment_pk>/delete/', views.comments_delete, name='comments_delete'),
  ]
  ```

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    ...
    <!-- 댓글 목록 -->
    {% for comment in comments %}
      <li>
        {{ comment.content }}
        <form action="{% url 'articles:comments_delete' article.pk comment.pk %}" method="POST" style="display: inline;">
          {% csrf_token %}
          <input type="submit" value="DELETE">
        </form>
      </li>
    {% endfor %}
    ...
  {% endblock %}
  ```

  - comment update 페이지의 경우 흐름이 매우 복잡하다. JS를 학습하고 만들어보자.

  

------



## 02. Comment 관련 추가 사항

### 2.1 댓글 개수 출력

```
# 1. {{ comments|length }}

# 2. {{ article.comment_set.all|length }}

# 3. {{ comments.count }} 는 count 메서드가 호출되면서 comment 모델 쿼리를 한번 더 보내기 때문에 매우 작은 속도차이지만 더 느려진다.
```

```django
<!-- articles/detail.html -->

{% extends 'base.html' %}

{% block content %}
  ...
  <hr>
  <!-- 댓글 개수 -->
  <p><b>{{ comments|length }}개의 댓글</b></p>
  <!-- 댓글 목록 -->
  ...
{% endblock %}
```



### 2.2 댓글이 없는 경우 다른 문장 출력

- `{% for in %}`/ `{% empty %}`/ `{% endfor %}`활용

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    ...
    <!-- 댓글 목록 -->
    {% for comment in comments %}
      <li>
        {{ comment.content }}
        <form action="{% url 'articles:comments_delete' article.pk comment.pk %}" method="POST" style="display: inline;">
          {% csrf_token %}
          <input type="submit" value="DELETE">
        </form>
      </li>
    {% empty %}
      <p><b>댓글이 없어요..</b></p>
    {% endfor %}
    ...
  {% endblock %}
  ```

  

```bash
$ pip freeze > requirements.txt
```



------

