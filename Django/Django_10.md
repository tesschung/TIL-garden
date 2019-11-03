[TOC]

---

## 00. User - Article

> https://docs.djangoproject.com/en/2.2/ref/settings/#auth-user-model

- user 와 article 과의 관계를 1:N으로 만들어서 게시글을 작성할 때, 로그인 된 사람의 정보를 넣어 누가 작성했는지 함께 저장해야한다.
- 작성한 게시물(article)에 user 정보를 추가한다. (`user : article = 1 : N`)



- Article 모델에 외래키 설정 후 마이그레이션 작업 진행

  ```python
  # articles/models.py
  
  from django.conf import settings
  
  class Article(models.Model):
  	  ...
      user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
  ```



**`AUTH_USER_MODEL`**

- Default: **'auth.User'**
- User 를 나타내는데 사용할 모델
- 프로젝트를 진행하는 동안 (즉, 프로젝트에 의존하는 모델을 만들고 마이그레이션 한 후) AUTH_USER_MODEL 설정은 변경할 수 없다. (변경하려면 큰 노력이 필요)
- User model 대체 시 변경할 예정이다.



```bash
$ python manage.py makemigrations

# 첫번째 상황(null 값이 허용되지 않는 user_id 가 아무 값도 없이 article 에 추가되려 하기 때문)
$ python manage.py makemigrations
You are trying to add a non-nullable field 'user' to article without a default; we can't do that (the database needs something to populate existing rows).
Please select a fix:
 1) Provide a one-off default now (will be set on all existing rows with a null value for this column)
 2) Quit, and let me add a default in models.py
Select an option: # 1 입력하고 enter

# 두번째 상황(그럼 기존 article 의 user_id 로 어떤 데이터를 넣을건지 물어봄, 현재 admin 의 pk 값인 1을 넣자)
Please enter the default value now, as valid Python
The datetime and django.utils.timezone modules are available, so you can do e.g. timezone.now
Type 'exit' to exit this prompt
>>> # 1 입력하고 enter (그럼 현재 작성된 모든 글은 admin 이 작성한 것으로 됨)


Migrations for 'articles':
  articles/migrations/0004_article_user.py
    - Add field user to article
```

```bash
$ python manage.py migrate

Operations to perform:
  Apply all migrations: admin, articles, auth, contenttypes, sessions
Running migrations:
  Applying articles.0004_article_user... OK
```

- table 을 확인해보면 다음과 같다.

  <img width="858" alt="Screen_Shot_2019-10-10_at_11 00 44_PM" src="https://user-images.githubusercontent.com/18046097/67463405-568d7700-f67c-11e9-956d-19ffee67a0bf.png">



- 게시글을 작성하려 하면 user 를 선택 해야하는 불필요한 field 가 노출된다. 제목과 내용만 입력하도록 필드를 설정해야한다.

  ```python
  # articles/forms.py
  
  class ArticleForm(forms.ModelForm):
      ...
      class Meta:
          model = Article
          fields = ('title', 'content',)
  ```

  - 글을 작성해보면 create 시에 유저 정보가 저장되지 않기 때문에 다음과 같은 에러가 발생한다.
  - `NOT NULL constraint failed: articles_article.user_id`



### 0.1 CREATE 로직 수정 (+글 작성자 보여주기)

- 이전의 댓글 작성에서 사용했던 `.save(commit=False)` 로 아직 DB 에 저장되지 않은 article 객체를 반환한다.

- 그리고 `request.user` 라는 현재 요청의 유저 객체를 `article.user` 에 할당한다.

  ```python
  # articles/views.py
  
  @login_required
  def create(request):
      if request.method == 'POST':
          form = ArticleForm(request.POST)
          if form.is_valid():
              article = form.save(commit=False)
              article.user = request.user
              article.save()
              return redirect(article)
      ...
  ```

- 게시글을 작성한 user가 누구인지 보기 위해 `index.html` 수정

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
    {% for article in articles %}
      <p><b>작성자 : {{ article.user }}</b></p>
      ...
    {% endfor %}
  {% endblock %}
  ```



### 0.2 UPDATE, DELETE 로직 수정

- 해당 게시글의 게시자가 아니라면, 삭제/수정 버튼을 가리자! 

  - 현재 요청의 user 와 글 작성 user 를 비교해야한다.

  - 직접 로그인 한 상태로 **다른 유저가 쓴 글에 들어가면 수정/삭제가 보이지 않는다**. (확인)

    ```django
    <!-- articles/detail.html -->
    
    {% extends 'articles/base.html' %}
    {% block content %}
      ...
      {% if request.user == article.user %}
        <a href="{% url 'articles:update' article.pk %}">[UPDATE]</a>
        <form action="{% url 'articles:delete' article.pk %}" method="POST">
          {% csrf_token %}
          <input type="submit" value="DELETE">
        </form>
      {% endif %}
    ...
    ```

  - `request.user` 가 아닌 `user` 라고 작성 할 수도 있다.

  - 하지만 이건 단순히 버튼만 가린 것 뿐이지 직접 `articles/7/update/` 혹은 `articles/7/delete/` 로 POST 요청을 강제로 요청할 경우 수정/삭제가 동작한다.

  - 그래서 실제 view 로직에서도 처리해줘야한다.



- 사용자가 자신의 글만 **수정/삭제** 할 수 있도록 내부(update/delete) 로직 수정

  ```python
  # articles/views.py
  
  @login_required
  def update(request, article_pk):
      article = get_object_or_404(Article, pk=article_pk)
      if request.user == article.user:
          if request.method == 'POST':
              form = ArticleForm(request.POST, instance=article)
              if form.is_valid():
                  article = form.save()
                  return redirect(article)
          else:
              form = ArticleForm(instance=article)
      else:
          return redirect('articles:index')
      context = {'form': form, 'article': article,}
      return render(request, 'articles/form.html', context)
  ```

  ```python
  # articles/views.py
  
  @require_POST
  def delete(request, article_pk):
      if request.user.is_authenticated:
          article = get_object_or_404(Article, pk=article_pk)
          if request.user == article.user:
              article.delete()
              return redirect('articles:index')
          else:
              return redirect(article)
      return redirect('articles:detail', article_pk)
  ```

  - 이제는 자신의 게시글이 아니면 강제로 수정/삭제 할 수 없다.



---



## 01. User - Comment

- 우리는 1:N 시간에 Article과 Comment의 관계에 대해서 학습했다.

- article은 user 가 article을 여러개 가지고 있는 1:N 이었다면, comment 는 user & article 이 여러 comment 를 가지고 있는 이중 1:N 이다.

- 이번에는 user와 Comment의 관계를 1:N으로 만들어서 게시글을 작성할 때, 로그인 된 사람의 정보를 넣어 누가 작성했는지 함께 저장한다.

- User 모델과 각각 1:N 관계 설정

  ```python
  # articles/models.py
  
  class Comment(models.Model):
  		article = models.ForeignKey(Article, on_delete=models.CASCADE)
      user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
  		...
  ```

  ```bash
  $ python manage.py makemigrations
  
  # 첫번째 상황(null 값이 허용되지 않는 user_id 가 아무 값도 없이 comment 에 추가되려 하기 때문)
  You are trying to add a non-nullable field 'user' to comment without a default; we can't do that (the database needs something to populate existing rows).
  Please select a fix:
   1) Provide a one-off default now (will be set on all existing rows with a null value for this column)
   2) Quit, and let me add a default in models.py
  Select an option: # 1 입력하고 enter
  
  # 두번째 상황(그럼 기존 comment 의 user_id 로 뭘 넣을건지 물어봄, 현재 admin 인 1을 넣자)
  Please enter the default value now, as valid Python
  The datetime and django.utils.timezone modules are available, so you can do e.g. timezone.now
  Type 'exit' to exit this prompt
  >>> # 1 입력하고 enter (모든 댓글의 작성자를 admin 으로 하게 됨)
  
  Migrations for 'articles':
    articles/migrations/0005_comment_user.py
      - Add field user to comment
  ```

  ```bash
  $ python manage.py migrate
  
  Operations to perform:
    Apply all migrations: admin, articles, auth, contenttypes, sessions
  Running migrations:
    Applying articles.0005_comment_user... OK
  ```

  <img width="751" alt="Screen_Shot_2019-10-11_at_12 22 11_AM" src="https://user-images.githubusercontent.com/18046097/67463406-568d7700-f67c-11e9-9f2d-85e125e3c46a.png">



### 1.2 CREATE & READ

- 해당 view 함수를 요청한 유저의 정보를 넣고나서 저장한다.

  ```python
  # articles/views.py
  
  @require_POST
  def comments_create(request, article_pk):
      if request.user.is_authenticated:
          comment_form = CommentForm(request.POST)
          if comment_form.is_valid():
              comment = comment_form.save(commit=False)
              comment.user = request.user
              comment.article_id = article_pk
              comment.save()
      return redirect('articles:detail', article_pk)
  ```

- 비로그인 유저는 댓글 작성 form 을 볼 수 없도록 한다.

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
    <hr>
    {% if user.is_authenticated %}
      <form action="{% url 'articles:comments_create' article.pk %}" method="POST">
        {% csrf_token %}
        {{ comment_form }}
        <input type="submit" value="submit">
      </form>
    {% else %}
      <a href="{% url 'accounts:login' %}">[댓글을 작성하려면 로그인하세요.]</a>
    {% endif %}
    <hr>
    <a href="{% url 'articles:index' %}">[back]</a>
  {% endblock %}
  ```

  - 로그인을 했을 때만 댓글을 작성할 수 있는지 확인해보자.



### 1.3 DELETE

- 본인이 작성한 댓글만 삭제할 수 있어야 한다.

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
    <p>댓글 목록</p>
    {% for comment in comments %}
      <div>
        댓글 {{ forloop.revcounter }} : {{ comment.content }}
        {% if user == comment.user %}
          <form action="{% url 'articles:comments_delete' article.pk comment.pk %}" method="POST" style="display: inline;">
            {% csrf_token %}
            <input type="submit" value="DELETE">
          </form>
        {% endif %}
      </div>
    {% empty %}
    ...
  {% endblock %}
  ```

  ```python
  # articles/views.py
  
  @require_POST
  def comments_delete(request, article_pk, comment_pk):
      if request.user.is_authenticated:
          comment = get_object_or_404(Comment, pk=comment_pk)
          if request.user == comment.user:
              comment.delete()
      return redirect('articles:detail', article_pk)
  ```

  - 본인이 쓴 댓글에만 댓글 삭제 버튼이 활성화 되는 것을 확인해보자.



---



## 02. Gravatar with Custom template tags and filters

### 2.1 Gravatar

- 이메일을 활용하여 프로필 사진을 만들어주는 서비스.

- 한번 등록하면 이를 지원하는 사이트에서는 모두 해당 프로필 이미지로 사용할 수 있음.

- 이메일 체크를 해보고, 가입 한번을 진행하자.

  - [https://ko.gravatar.com/site/check/](https://ko.gravatar.com/site/check/edujunho.hphk@gmail.com)본인이메일주소

  <img width="818" alt="Screen_Shot_2019-10-11_at_3 39 36_PM" src="https://user-images.githubusercontent.com/18046097/67463408-57260d80-f67c-11e9-98b5-c01bf61cec1c.png">

- 이메일 주소를 해시로 바꾸고 (MD5) 해당 URL로 들어가보면 사진이 뜬다. (?s=80 을 바꾸면서 사이즈 조절할 수 있음.)



### 2.2 Django Signup Email 필드 추가

> https://docs.djangoproject.com/en/2.2/topics/auth/default/#django.contrib.auth.forms.UserCreationForm

- gravatar 는 이메일 정보가 필요하기 때문에 회원가입시 이메일 정보를 받아보자.



1. UserCreationForm Custom (email field 추가 + Meta 정보 상속 )

   ```python
   # accounts/forms.py
   
   from django.contrib.auth.forms import UserChangeForm, UserCreationForm
   
   class CustomUserCreationForm(UserCreationForm):
       class Meta(UserCreationForm.Meta):
           fields = UserCreationForm.Meta.fields + ('email',)
   ```

   - 다음과 같이 작성할 수도 있습니다. (참고)

     ```python
     # accounts/forms.py
     
     from django.contrib.auth.forms import UserChangeForm, UserCreationForm
     from django.contrib.auth import get_user_model
     
     class CustomUserCreationForm(UserCreationForm):
         class Meta:
             model = get_user_model()
             fields = ('username', 'password1', 'password2', 'email',)
     ```

2. 회원가입 view 수정

   ```python
   # accounts/views.py
   
   from .forms import CustomUserChangeForm, CustomUserCreationForm
   
   def signup(request):
       if request.user.is_authenticated:
           return redirect('articles:index')
   
       if request.method == 'POST':
           form = CustomUserCreationForm(request.POST)
           if form.is_valid():
               user = form.save()
               auth_login(request, user)
               return redirect('articles:index')
       else:
           form = CustomUserCreationForm()
       context = {'form': form,}
       return render(request, 'accounts/auth_form.html', context)
   ```

   - 회원가입시 이메일 정보를 받는지 확인해보자.



### 2.3 Custom template tags and filters

> https://docs.djangoproject.com/ko/2.2/howto/custom-template-tags/

1. Gravatar 에서 제공한 해시값이 포함된 이메일 주소를 사용해보자.

   ```django
   <!-- articles/base.html -->
   
   ...
   <body>
     <div class="container">
     {% if user.is_authenticated %}
       <h3>
         <img src="https://s.gravatar.com/avatar/2af6a65a0a53be46dc4a0bdedcbfdf?s=80" alt="gravatar">
         Hello, {{ user.username }}
   ...
   ```

2. 현재 이미지는 로그인한 유저의 이메일 주소과 관계없는 프로필 이미지이다. 각 로그인 한 사람마다의 email 정보를 통한 gravatar 이미지가 출력되어야 한다.

   ```python
   # articles/views.py
   
   import hashlib
   
   def index(request):
       if request.user.is_authenticated:
           gravatar_url = hashlib.md5(request.user.email.strip().lower().encode('utf-8')).hexdigest()
       else:
           gravatar_url = None # 변수 선언은 해야 하니까 None으로 처리.
       ...
       context = {'articles': articles, 'visits_num': visits_num, 'gravatar_url': gravatar_url,}
       return render(request, 'articles/index.html', context)
   ```

   ```django
   <!-- articles/base.html-->
   
   ...
   <body>
     <div class="container">
     {% if user.is_authenticated %}
       <h3>
         <img src="https://s.gravatar.com/avatar/{{ gravatar_url }}?s=80" alt="gravatar">
         Hello, {{ user.username }} |
   ...
   ```

   <img width="1393" alt="Screen_Shot_2019-10-11_at_4 14 26_PM" src="https://user-images.githubusercontent.com/18046097/67463409-57260d80-f67c-11e9-992f-90d81728c16e.png">

   - 그런데 `base.html`에서 출력되는 것인데 모든 views 함수에 context로 계산해서 넘겨줘야할까? 아니다!
   - 독특하게도 user 는 모든 request 에 인스턴스가 있고 이를 view 그리고 template 에서 쓸 수 있다. 이것만 암호화하면 된다.
   - 예전에 DTL에서 다양한 태그랑 필터들을 사용했던 기억이 있다. hash 로 암호화해주는 우리만의 태그 및 필터를 만들어보자.

3. Custom Template Tag 만들기

   - 코드 레이아웃 (app 폴더에 `templatetags` 폴더 생성, 약속된 폴더명이다.)

     ```
     accounts/
         __init__.py
         models.py
         templatetags/
             __init__.py
             gravatar.py
         views.py
     ```

   - gravatar.py 생성 및 작성 (이 파일명은 나중에{% load gravatar %}로 사용된다.)

     ```python
     # accounts/templatetags/gravatar.py
     
     import hashlib
     from django import template
     
     register = template.Library()  # 기존 템플릿 라이브러리에
     
     @register.filter # 아래의 함수를 필터로 추가한다.
     def makemd5(email):
     		return hashlib.md5(email.strip().lower().encode('utf-8')).hexdigest()
     ```

4. Template 활용

   - load 는 폴더에 생성한 python 파일명이며, filter에 쓰이는 것은 함수명이다.

     ```
     <!-- articles/base.html -->
     
     {% load bootstrap4 %}
     {% load gravatar %}
     ...
     <body>
       <div class="container">
       {% if user.is_authenticated %}
         <h3>
           <img src="https://s.gravatar.com/avatar/{{ user.email|makemd5 }}?s=80" alt="gravatar">
     ```

   - 이제 기존 코드는 삭제한다.

     ```python
     # articles/views.py
     
     # import hashlib 도 삭제
     
     def index(request):
         articles = Article.objects.all()
         visits_num = request.session.get('visits_num', 0)
         request.session['visits_num'] = visits_num + 1
         context = {'articles': articles, 'visits_num': visits_num,}
         return render(request, 'articles/index.html', context)
     ```



---



## 03. Model relationships

> https://docs.djangoproject.com/en/2.2/topics/db/examples/many_to_many/#many-to-many-relationships

- 현재 User와 Article의 관계는 `User : Article = 1 : N`이다. 
  - `article.user` , `user.article_set` 은 서로를 참조 하거나 역참조 (user가 게시글을 참조) 할 수 있다.
  - 관점을 조금 달리해서 `User : Article = M : N` 으로 설정하고 다시 생각해보자. 기존의 유저와 게시글의 관계에서 서로 좋아요를 표현할 수 있다고 생각하자. 
    - user는 여러 개의 게시글에 like 할 수 있고
    - 게시글는 여러 user로부터 like를 받을 수 있다.



- 폴더 구조 및 사전 준비

  ```
  TIL
  	...
  	03_Django
      ...
  		04_model_relation
  ```

  ```bash
  $ python -m venv venv
  
  # vscode python interpreter 로 가상환경 선택후 vscode 터미널 열기
  
  $ pip list
  $ pip install django ipython django_extensions
  
  $ django-admin startproject modelrelation .
  ```

  ```python
  # settings.py
  
  INSTALLED_APPS = [
  	  'django_extensions',
      ...,
  ]
  ```

  ```bash
  $ python manage.py startapp manytomany
  ```

  ```python
  # settings.py
  
  INSTALLED_APPS = [
      'manytomany.apps.ManytomanyConfig',
  		... 
  ]
  ```



**병원 진료 기록 시스템 구상**

- 우리 일상에 가까운 예시를 통해 DB를 모델링하고 그 내부에서 일어나는 데이터의 흐름을 어떻게 제어할 수 있을지 고민해보자
- 우리는 병원에 내원하는 환자와 의사의 예약 시스템을 구축하라는 업무를 부여 받았다.
- 병원 시스템에서 가장 핵심이 되는 것은 무엇일까? 바로 `환자` 와 `의사` 다.
- 이 둘의 관계를 어떻게 표현할 수 있을까?



1. 1:N의 한계

   ```python
   # manytomany/models.py
   
   from django.db import models
   
   class Doctor(models.Model):
       name = models.TextField()
   
       def __str__(self):
           return f'{self.pk}번 의사 {self.name}'
   
   
   class Patient(models.Model):
       name = models.TextField()
       doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
   
       def __str__(self):
           return f'{self.pk}번 환자 {self.name}'
   ```

   ```bash
   $ python manage.py makemigrations
   $ python manage.py migrate
   
   $ python manage.py shell_plus
   ```

   ```python
   doctor1 = Doctor.objects.create(name='justin')
   doctor2 = Doctor.objects.create(name='zzulu')
   patient1 = Patient.objects.create(name='tak', doctor=doctor1)
   patient2 = Patient.objects.create(name='harry', doctor=doctor2)
   
   In [8]: doctor1
   Out[8]: <Doctor: 1번 의사 justin>
   
   In [9]: doctor2
   Out[9]: <Doctor: 2번 의사 zzulu>
   
   In [10]: patient1
   Out[10]: <Patient: 1번 환자 tak>
   
   In [11]: patient2
   Out[11]: <Patient: 2번 환자 harry
   ```

   ```python
   # 1. 
   # 1번 환자(tak)가 justin 의사가 마음에 안들어 다른 의사 zzulu(doctor2)에게 방문하려고 한다.
   # 기존 객체 patient 를 삭제하지 않고 어떻게 추가할 수 있을까?
   In [5]: patient3 = Patient.objects.create(name='tak', doctor=doctor2)
   
   In [6]: patient3
   Out[6]: <Patient: 3번 환자 tak>
   
   In [8]: patient3.doctor.name
   Out[8]: 'zzulu'
   
   
   
   # 2. 
   # 2번 환자 (harry)가 다른 의사 justin(doctor)에게도 방문하려고 한다. (에러)
   In [13]: patient4 = Patient.objects.create(name='harry', doctor=doctor1, doctor2)
   File "<ipython-input-9-6edaf3ffb4e6>", line 1
       patient4 = Patient.objects.create(name='harry', doctor=doctor1, doctor2)
                                                                      ^
   SyntaxError: positional argument follows keyword argument
   
   
   # 이건..?
   In [10]: patient4 = Patient.objects.create(name='harry', doctor=doctor1, doctor=doctor2)                      
     File "<ipython-input-10-2775590f4f3f>", line 1
       patient4 = Patient.objects.create(name='harry', doctor=doctor1, doctor=doctor2)
                                                                      ^
   SyntaxError: keyword argument repeated
   ```

   - 방문 예약을 바꾸는 것이 불가능하다. 
     - 즉, tak이 1번 의사한테 예약을 했다가 1번이 아닌 2번 의사로 방문 예약을 바꾸려면 어떻게 해야 할까...? 새로운 객체를 생성해서 예약해야 한다.
   - 다른 의사를 방문한 기록을 남길 수 없다. 
     - 동일한 환자(harry)지만 다른 의사에게 예약하기 위해서는 객체를 하나 더 만들어서 예약을 진행해야 한다. `1, 2` 형태로 쓰려면 튜플, 리스트 같은 자료형이 되기 때문에 Integer가 아니라 안된다. (`doctor_id` 는 1, 2 처럼 정수 형태여야 하며 (1, 2) 이런 식으로 값을 받을 수 없다.



2. 추가 테이블 생성(중개 모델)

   ```python
   # manytomany/models.py
   
   class Doctor(models.Model):
       name = models.TextField()
   
       def __str__(self):
           return f'{self.pk}번 의사 {self.name}'
   
   
   class Patient(models.Model):
       name = models.TextField()
       # 외래키 삭제
   
       def __str__(self):
           return f'{self.pk}번 환자 {self.name}'
   
   # 중개모델 작성
   class Reservation(models.Model):
       doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
       patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
   
       def __str__(self):
           return f'{self.doctor_id}번 의사의 {self.patient_id}번 환자'
   ```

- db.sqlite3 와 migrations 파일(000$.py파일만)을 지우고 다시 migrations

  ```bash
  $ python manage.py makemigrations
  $ python manage.py migrate
  ```

  ```bash
  $ python manage.py shell_plus
  ```

  ```python
  doctor1 = Doctor.objects.create(name='justin')
  patient1 = Patient.objects.create(name='tak')
  
  In [3]: Reservation.objects.create(doctor=doctor1, patient=patient1)
  Out[3]: <Reservation: 1번 의사의 1번 환자>
  ```

  ```python
  # 의사 -> 예약 정보 찾기
  In [4]: doctor1.reservation_set.all()
  Out[4]: <QuerySet [<Reservation: 1번 의사의 1번 환자>]>
  
  # 환자 -> 예약 정보 찾기
  In [5]: patient1.reservation_set.all()
  Out[5]: <QuerySet [<Reservation: 1번 의사의 1번 환자>]>
  ```

  ```python
  In [6]: patient2 = Patient.objects.create(name='harry')
  
  In [7]: Reservation.objects.create(doctor=doctor1, patient=patient2)
  Out[7]: <Reservation: 1번 의사의 2번 환자>
  
  
  # 의사 -> 환자 목록
  In [8]: doctor1.reservation_set.all()
  Out[8]: <QuerySet [<Reservation: 1번 의사의 1번 환자>, <Reservation: 1번 의사의 2번
  환자>]>
  
  
  # 환자1(tak) -> 자신의 예약 목록
  In [9]: patient1.reservation_set.all()
  Out[9]: <QuerySet [<Reservation: 1번 의사의 1번 환자>]>
  
  
  # 환자2(harry) -> 자신의 예약 목록
  In [10]: patient2.reservation_set.all()
  Out[10]: <QuerySet [<Reservation: 1번 의사의 2번 환자>]>
  
  # 현재 의사 1명에 환자 2명 !
  ```

  - doctor1 의 환자 목록을 보고 싶다면 
    - N 에서 1 을 참조하는 건 바로 접근
    - 1 에서 N 을 참조하기 위해서는 ORM이 확신을 할 수 없어 `_set` 으로 접근



3. `Through` option

   - 중개 모델을 직접 거치지 않고 바로 의사의 환자들을 가져올 수 없을까?

     ```python
     # manytomany/models.py
     
     class Patient(models.Model):
         name = models.TextField()
     		# 중개 모델인 Reservation 클래스를 등록
         doctors = models.ManyToManyField(Doctor, through='Reservation')
     
     		def __str__(self):
             return f'{self.id}번 환자 {self.name}'
     ```

     ```bash
     $ python manage.py makemigrations
     $ python manage.py migrate
     ```

     - `Reservation` 을 통해서(`through`) 가지고 오겠다!
     - **`doctors` 로 복수형을 쓰는 이유는 일반적으로 `ManyToManyField` 는 여러 개의 관계니까 복수형을 쓰는 것이 convention. 강제는 아니다.**

   - 실제 물리적인 필드가 DB에 생겨 `doctor_id` 를 저장해서 쓰는 것이 아니다.

     - 중개모델을 통한 결과와 M2M 필드를 통한 결과의 return을 살펴보자
       - 중개 모델의 경우 Reservation  클래스의 인스턴스가 나왔고
       - M2M의 경우 Doctor 클래스의 인스턴스가 나왔다.

     ```bash
     $ python manage.py shell_plus
     ```

     ```python
     In [1]: patient1 = Patient.objects.get(pk=1)
     
     In [2]: patient1
     Out[2]: <Patient: 1번 환자 tak>
     
     
     # 기존 - 중개모델
     # tak 환자의 모든 예약 목록 
     In [3]: patient1.reservation_set.all()
     Out[3]: <QuerySet [<Reservation: 1번 의사의 1번 환자>]>
     
     
     # 변경 - M2M 필드 설정
     In [4]: patient1.doctors.all()
     Out[4]: <QuerySet [<Doctor: 1번 의사 justin>]>
     ```

   - 다른 의사 선생님을 추가하려고 하고 결과를 보자.

     ```python
     # 1. 두번째 의사 생성
     In [6]: doctor2 = Doctor.objects.create(name='zzulu')
     
     
     # 2. 중개 모델을 통해서 1번 환자와 2번 의사 연결
     In [7]: Reservation.objects.create(doctor=doctor2, patient=patient1)
     Out[7]: <Reservation: 2번 의사의 1번 환자>
     
     
     # 3. 1번 환자가 예약한 의사 목록
     In [8]: patient1.doctors.all()
     Out[8]: <QuerySet [<Doctor: 1번 의사 justin>, <Doctor: 2번 의사 zzulu>]>
     ```

   - 그럼 의사 입장에서 환자 목록을 보기 위해서는 어떻게 해야할까?

     - 여전히 `patient_set.all()` 이라고 한 이유는 애초에 M:N 관계 설정을  환자가 의사를 참조하도록 설정했기 때문이다. (MTM 필드를 Patient 에 작성했기 때문)
     - 1:N 관계와는 다르게 무조건 이렇게 참조해야 하는 것이 아니라 반대로 환자들을 의사가 참조하게 모델을 설계할 수도 있다. (MTM 필드를 Doctor 에 작성해도 됨)
     - patient를 기준으로 doctor를 참조하도록 설정했기 때문에 doctor가 patient를 참조할 때 그 수를 보장할 수 없기 때문에 `patient_set`으로 찾게 된다.

     ```python
     In [9]: doctor2
     Out[9]: <Doctor: 2번 의사 zzulu>
     
     In [10]: doctor2.patient_set.all()
     Out[10]: <QuerySet [<Patient: 1번 환자 tak>]>
     ```



4. `related_name` option

   - doctor 도 patients 로 참조 할 수 없을까?

     ```python
     # manytomany/models.py
     
     class Patient(models.Model):
         name = models.CharField(max_length=20)
         doctors = models.ManyToManyField(Doctor, through='Reservation', related_name='patients')
         ...
         
     ```

     ```bash
     $ python manage.py makemigrations
     $ python manage.py migrate
     ```

   - `related_name` 은 참조되는 대상이 참조하는 대상을 찾을 때(역참조), 어떻게 불러올 지에 대해 정의한다.

   - (주의)필수적으로 사용하는 것은 아니지만, 필수적인 상황이 발생할 수 있다.

     ```bash
     $ python manage.py shell_plus
     ```

     ```python
     # 1. 1번 의사 불러오기
     In [1]: doctor1 = Doctor.objects.get(pk=1)
     
     In [2]: doctor1
     Out[2]: <Doctor: 1번 의사 justin>
     
     
     # 2. 1번 의사에게 예약한 모든 환자 목록!
     # 기존 - 에러 발생 (related_name 을 설정하면 기존 _set 은 사용할 수 없다.)
     In [3]: doctor1.patient_set.all()
     AttributeError: 'Doctor' object has no attribute 'patient_set'
     
     
     # 변경 - 이제는 1:N 에서 역참조 이름 설정과 동일!
     In [4]: doctor1.patients.all()
     Out[4]: <QuerySet [<Patient: 1번 환자 tak>, <Patient: 2번 환자 harry>]>
     ```



5. ManyToMany

   - DB와 마이그레이션 파일을 지우고 아래와 같이 변경하고 다시 반영 해보자. 

     ```python
     from django.db import models
     
     class Doctor(models.Model):
         name = models.TextField()
     
         def __str__(self):
             return f'{self.pk}번 의사 {self.name}'
     
     
     class Patient(models.Model):
         name = models.TextField()
         doctors = models.ManyToManyField(Doctor, related_name='patients')
     
         def __str__(self):
             return f'{self.pk}번 환자 {self.name}'
     
     
     # Reservation class 삭제
     ```

     ```bash
     $ python manage.py makemigrations
     $ python manage.py migrate
     ```

     - 테이블의 이름을 확인해보면 `manytomany_patient_doctors` 라는 테이블이 보인다.

     ```sqlite
     $ sqlite3 db.sqlite3
     
     sqlite> .tables
     auth_group                  django_migrations
     auth_group_permissions      django_session
     auth_permission             manytomany_doctor
     auth_user                   manytomany_patient
     auth_user_groups            manytomany_patient_doctors
     auth_user_user_permissions  onetomany_article
     django_admin_log            onetomany_comment
     django_content_type         onetomany_user
     
     
     sqlite> .schema manytomany_patient_doctors
     CREATE TABLE IF NOT EXISTS "manytomany_patient_doctors" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "patient_id" integer NOT NULL REFERENCES "manytomany_patient" ("id") DEFERRABLE INITIALLY DEFERRED, "doctor_id" integer NOT NULL REFERENCES "manytomany_doctor" ("id") DEFERRABLE INITIALLY DEFERRED);
     CREATE UNIQUE INDEX "manytomany_patient_doctors_patient_id_doctor_id_23ab539b_uniq" ON "manytomany_patient_doctors" ("patient_id", "doctor_id");
     CREATE INDEX "manytomany_patient_doctors_patient_id_cb4ef2b1" ON "manytomany_patient_doctors" ("patient_id");
     CREATE INDEX "manytomany_patient_doctors_doctor_id_7b77037d" ON "manytomany_patient_doctors" ("doctor_id");
     
     # 스키마를 살펴보면 patient_id와 doctor_id가 자동으로 만들어 진 것을 볼 수 있다.
     # 우리 테이블 상의 변화는 없다. 
     ```

     <img width="272" alt="Screen_Shot_2019-10-11_at_8 22 47_PM" src="https://user-images.githubusercontent.com/18046097/67468318-4037e900-f685-11e9-9336-599be75c2c5b.png">

     ```bash
     $ python manage.py shell_plus
     ```

     ```python
     In [2]: doctor1 = Doctor.objects.create(name='justin')
     In [3]: patient1 = Patient.objects.create(name='tak')
     
     In [4]: doctor1
     Out[4]: <Doctor: 1번 의사 justin>
     
     In [5]: patient1
     Out[5]: <Patient: 1번 환자 tak>
     ```

     - 이제 예약을 등록하려면 어떻게 해야할까?

     ```python
     # 1. doctor1(justin)에게 예약을 한다. 누가? patient1(tak)이!
     In [6]: doctor1.patients.add(patient1)
     # patient1.doctors.add(doctor1)도 상관없음
     
     # 2. doctor1 -> 자신의 예약 목록 확인
     In [7]: doctor1.patients.all() 
     Out[7]: <QuerySet [<Patient: 1번 환자 tak>]>
     
     # 3. patient1 -> 자신이 예약한 의사
     In [8]: patient1.doctors.all()
     Out[8]: <QuerySet [<Doctor: 1번 의사 justin>]>
     ```

     - 삭제는 어떻게 할까? 기존에는 해당하는 Reservation을 찾아서 지워야 했다면, 이젠 아래와 같이 지울 수가 있다.

     ```python
     # 1. doctor1(justin)의 환자 목록에서 patient1(tak) 예약 취소
     In [9]: doctor1.patients.remove(patient1)
     # patient1.doctors.remove(doctor1) 도 가능
     
     In [10]: doctor1.patients.all()
     Out[10]: <QuerySet []>
     
     In [11]: patient1.doctors.all()
     Out[11]: <QuerySet []>
     ```

     - 이전 실제 DB에는 `appname_reservation`테이블이였다면, 지금은 자동으로 `appname_patient_doctors`로 생성되어 관리된다.
     - 그러면, 아까 배웠던 중개모델은 필요 없는 것인가? 
       - 아니다! 만약 **예약한 시간 정보를 담는다거나 하는 경우(==추가적인 필드가 필요한 경우)**에는 반드시 **중개모델을 만들어서 컬럼을 추가** 해야 한다. 다만, 그럴 필요가 없는 경우 위와 같이 해결을 할 수 있다.
       - 지금처럼 단순히 환자들이 어떤 의사들을 참조할 지 여부만 설정하는 경우는 중개 모델이 없어도 설정이 가능하다.

**정리**

- 실제 테이블이 변하는 것은 없다. (DB의 구조가 변화한 것은 없다.)
- 어떻게 관계를 설정해야 하는지의 문제이다. 1:N 관계보다 어려운 이유는 ORM의 Relation은 변하는 게 없는데 Object를 어떻게 다룰 수 있는지에 대한 부분을 고민해야 하기 때문이다.
- 1:N은 완전한 종속의 관계이지만 M:N은 의사에게 진찰받는 환자, 환자를 진찰하는 의사의 두가지 형태로 모두 표현이 가능한거고 이 부분에 대한 설정을 모델을 설계하는 사람이 판단해서 해야 하기 때문에 어렵게 느껴질 수 있다.
- 1:N을 완전한 종속의 관계로 보자면 M:N의 경우는 종속의 관계를 어떻게 설정하던 문제가 없기 때문에 온전히 모델을 디자인하는 것은 복잡하다.



---



## 04. LIKE

> user 는 여러 article 에 좋아요를 누를 수 있고  article 은 여러 user 로부터 좋아요를 받을 수 있다.

- `blank=True` : 최초 작성되는 글에는 좋아요가 없고 작성된 글도 좋아요를 받지 않을 수 있다. 
  - 유효성 검사를 통과시키기 위해서 작성한다.
  - 단, 이는 DB에 저장하는 단계에서 빈값이 아니라 `''(empty string)` 의 형태로 저장된다.

```python
# articles/models.py

class Article(models.Model):
    ...
    like_users = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='like_articles', blank=True)
```

```bash
$ python manage.py makemigrations
$ python manage.py migrate
```

- **현 상황에서는 `related_name`설정이 필수다.** 

  - 이 경우에 기존처럼 역참조를 통해 `user.article_set.all()` 을 하면 문제가 생긴다.
  - M:N 관계 설정 시에 `related_name` 이 없다면 자동으로 `.article_set` 매니저를 사용할 수 있도록 하는 데 이 매니저는 이미 이전 1:N(User:Article) 관계에서 사용 중인 매니저이다.
  - user가 작성한 글들(`user.article_set`)과 user가 좋아요를 누른 글(`user.article_set`)을 django는 구분할 수 없게 된다. 
    - 이는 M:N 관계 설정 시에 `related_name`을 지정하지 않을 경우 반대로 참조하는 객체는  `해당객체.가져오려는객체_set` 매니저를 통해 접근할 수 있게 만들어 준다.
  - 이를 해결하기 위해 user 쪽에서 좋아요를 누른 article들을 불러오기 위해 `related_name`설정이 필요하다. 
    - `user.article_set.all()` : 유저가 작성한 게시글 전부
    - `user.like_articles.all()` : 유저가 좋아요를 누른 게시글 전부

- 기존 `articles_article` 테이블에 새로운 컬럼이 생기는 것이 아니라, `articles_article_like_users` 라는 새로운 테이블이 만들어 진다.

- 여기서 `articles_article_like_users` 는 두 테이블 간의 M:N 관계를 나타내주는 중개 모델(Intermediary model)이 된다.

  ```bash
  $ sqlite3 db.sqlite3
  
  sqlite> .tables
  articles_article             auth_user_groups
  articles_article_like_users  auth_user_user_permissions
  articles_comment             django_admin_log
  auth_group                   django_content_type
  auth_group_permissions       django_migrations
  auth_permission              django_session
  auth_user
  ```

  

- 이제 사용 가능한 ORM 명령어는 다음과 같다.
  - `article.user` : 게시글을 작성한 유저 - 1:N
  - `article.like_users` : 게시글을 좋아요한 유저 - M:N
  - `user.article_set`: 유저가 작성한 게시글들 → 역참조 - 1:N
  - `user.like_articles`: 유저가 좋아요한 게시글들(`related_name`) → 역참조 - M:N



### 4.2 view & urls

```python
# articles/views.py

@login_required
def like(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    user = request.user # 요청을 보낸 유저

    # 해당 게시글에 좋아요를 누른 사람들 중에서 user.pk(현재 접속유저의 번호)를 가진 user가 존재하면
    if article.like_users.filter(pk=user.pk).exists():
        # user 를 삭제하고 (좋아요를 취소)
        article.like_users.remove(user)
    else:
        # 존재하지 않는다면 user 를 추가한다. (좋아요를 누름)
        article.like_users.add(user)
    return redirect('articles:index')
```

> `if ... in ...` 방법
>
> ```python
> @login_required
> def like(request, article_pk):
>     article = get_object_or_404(Article, pk=article_pk)
> 		# QuerySet -> 객체 존재 여부 in 연산자 통해 판단 가능
>     if request.user in article.like_users.all():
>         article.like_users.remove(request.user)
>     else:
> 	      article.like_users.add(request.user)
>     return redirect('articles:index')
> ```

> - `.get`이 아닌 `.filter`를 사용하는 이유 → 데이터가 없는 경우에 오류 여부 
>   - `.get()` 은 유일한 값을 꺼낼 때 사용한다.(ex. pk) 유일한 값을 꺼낸다는 것은 해당 데이터가 존재하지 않는 경우가 없다는 뜻이다. 값이 없으면 에러(DoesNoetExist error) 가 발생하기 때문에 무조건 존재하는 값에 접근할 때 사용한다.
>   - `.filter()` 의 경우 조건에 맞는 여러 개의 데이터를 가져온다. 이때 데이터가 1개도 없어도 빈 쿼리셋을 반환한다. (몇 개인지 보장할 수 없을 때)
>   - 아래의 로직에서 `.get()` 을 사용하면 당연히 좋아요를 아무도 누르지 않은 상태에서는 `article.like_users`  에는 유저 정보가 없기 때문에 무조건 오류가 발생한다. 이때 `.filter()` 를 사용하면 해당 조건에 맞는 객체만 가져오기 때문에 조건에 맞지 않으면 값을 가져오지 않을 수도 있다.

```python
# articles/urls.py

urlpatterns = [
		...
		path('<int:article_pk>/like/', views.like, name='like'),
]
```



**font awesome 을 활용한 like 버튼 만들기**

```django
<!-- articles/base.html -->

{% load bootstrap4 %}
{% load gravatar %}
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <script src="https://kit.fontawesome.com/dacf7dcd9c.js" crossorigin="anonymous"></script>
...
```

```django
<!-- articles/index.html -->

{% for article in articles %}
    ...
    <p>{{ article.title }}</p>
    <a href="{% url 'articles:like' article.pk %}">
      {% if user in article.like_users.all %}
        <i class="fas fa-heart fa-lg" style="color:crimson;"></i>
      {% else %}
        <i class="fas fa-heart fa-lg" style="color:black;"></i>
      {% endif %}
    </a>
    {{ article.like_users.all|length }} 명이 이 글을 좋아합니다.<br>
    <a href="{{ article.get_absolute_url }}">[DETAIL]</a>
    <hr>
  {% endfor %}
{% endblock %}
```

- 여러 개의 아이디로 로그인을 해서 게시글에 좋아요를 눌러보자.

  <img width="432" alt="Screen_Shot_2019-10-12_at_12 09 52_AM" src="https://user-images.githubusercontent.com/18046097/67463410-57260d80-f67c-11e9-9b2c-6d681ad1ff22.png">



### 4.3 템플릿 분할

- nav bar, footer 같은 여러 템플릿에서 공통으로 사용되는 구역은 모두 한 곳에 작성 하는 것보다 구역 별로 템플릿을 만들어서 필요한 위치에 가져오는 것이 일반적이다.

- 뿐만 아니라 이는 템플릿을 모듈화하는 차원에서 코드의 유지보수에 매우 유용하다.

- 분할된 템플릿의 파일명은 `_article.html` 처럼 **언더바(_)로 시작하는 것**이 컨벤션이다.

- `{% include %}` 로 분할된 템플릿을 가져올 수 있다.

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
    {% for article in articles %}
      ... <!-- 게시글이 출력되는 이 구역을 분할해보자. -->
    {% endfor %}
  {% endblock %}
  ```

  ```django
  <!-- articles/_article.html -->
  <!-- bootstrap card 컴포넌트 사용 -->
  
  <div class="card mb-3">
    <h5 class="card-header">글 작성자: {{ article.user }}</h5>
    <div class="card-body">
      <h5 class="card-title">글 제목: {{ article.title }}</h5>
      <p>글 번호: {{ article.pk }}</p>
      <hr>
      <p class="card-text">
        <!-- 안에 들어가는 내용은 index.html의 for문 안에 있는 내용 전부 잘라내기-->
        <a href="{% url 'articles:like' article.pk %}">
          {% if user in article.like_users.all %}
            <i class="fas fa-heart fa-lg" style="color:crimson"></i>
          {% else %}
            <i class="fas fa-heart fa-lg" style="color:black"></i>
          {% endif %}
        </a>
        {{ article.like_users.all|length }} 명이 이 글을 좋아합니다. <br>
        <a href="{{ article.get_absolute_url }}">[DETAIL]</a>
      </p>
    </div>
  </div>
  ```

  ```django
  <!-- articles/index.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
    ...
    <hr>
    {% for article in articles %}
      {% include 'articles/_article.html' %}
    {% endfor %}
  {% endblock %}
  ```

  - 이전과 동일하게 동작 하는지 확인해보자



---



## 05. Profile 페이지 구현

- 각 유저마다 자신만의 프로필 페이지를 가질 수 있도록 해보자



### 5.1. view & url

- 지금 만드는 페이지는 User 의 CRUD 중 R, 구체적으로는 Detail 페이지에 해당한다. 

  - User 의 상세 정보를 보여주는 페이지 구성

  - 어디에 만들어야 할까? User 모델은 기본적으로 User 정보를 들고 있어야 하고 우리는 유저 가입, 로그인, 로그아웃 등의 절차를 `accounts` 라는 앱 안에 구현했기 때문에 `accounts` 에서 진행한다.

    ```python
    # accounts/views.py
    
    from django.contrib.auth import get_user_model
    from django.shortcuts import render, redirect, get_object_or_404
    
    ...
    
    def profile(request, username):
        person = get_object_or_404(get_user_model(), username=username)
        context = {'person': person,}
        return render(request, 'accounts/profile.html', context)
    ```



**url 경로 설정**

```python
# accounts/urls.py

urlpatterns = [
    ...
    path('<username>/', views.profile, name='profile'),
]
```

- 이 주소는 단순히 username 이라는 str 타입의 변수를 받는 주소이기 때문에 반드시 **가장 최하단에 작성**해야 한다.
- django 는 url 또한 위에서부터 읽어내려오므로 위 주소가 상단에 있다면 모든 요청이 profile view 로 이어진다.

> 만약 article 앱(다른 앱)이나 프로젝트의 url 에서 등록하고 싶다면 다음과 같이 사용할 수도 있다.
>
> ```python
> from accounts import views as accounts_views
> 
> urlpatterns = [
> 		...
>     path('<str:username>/', accounts_views.profile, name='profile'),
> ]
> ```
>
> - 어떤 앱의 view 인지 구분하기 위해 as 로 별명을 설정한다.



**template 작성**

- 내가 작성한 글 목록(bootstrap Card) / 내가 작성한 댓글 목록(bootstrap Card Quote)

- 모두 최근에 작성한 것이 가장 먼저 오도록 정렬 

  - 이전에 각 모델에 작성했던 Meta 클래스의 ordering 이 ('-pk') 로 되어있어서 자동으로 나중에 작성된 것들이 먼저 오도록 정렬된다.

- 더해서 각 게시글의 부가 정보까지 출력해보자.

  ```django
  <!-- accounts/profile.html -->
  
  {% extends 'articles/base.html' %}
  {% block content %}
  <h1 class="text-center">{{ person.username }}'s Profile</h1>
  <hr>
  <h3 class="text-center">{{ person.username }}이 작성한 글</h3>
  
  <div class="row">
    {% for article in person.article_set.all %}
    <div class="col-4 my-2">
      <div class="card">
        <div class="card-body">
          <h4 class="card-title">{{ article.content }}</h4>
          <p class="card-text">{{ article.like_users.count }}명이 좋아하는 글</p>
          <p class="card-text">{{ article.comment_set.count }}개의 댓글</p>
          <a href="{% url 'articles:detail' article.pk %}" class="btn btn-primary">게시글 보기</a>
        </div>
      </div>
    </div>
    {% endfor %}
  </div>
  
  <hr>
  
  <h3 class="text-center">{{ person.username }}이 작성한 댓글</h3>
  <div class="row">
    {% for comment in person.comment_set.all %}
    <div class="col-12 my-2">
      <div class="card">
        <div class="card-body">
          <blockquote class="blockquote">
            <p class="mb-0">{{ comment.content }}</p>
            <footer class="blockquote-footer">{{ comment.created_at|date:"SHORT_DATE_FORMAT" }}</footer>
          </blockquote>
        </div>
      </div>
    </div>
    {% endfor %}
  </div>
  {% endblock %}
  ```

  - `/accounts/유저네임/` 으로 접속해서 프로필 페이지를 확인해보자.



### 5.2 DB 접근 최적화

> https://docs.djangoproject.com/ko/2.2/topics/db/optimization/#database-access-optimization
>
> https://blog.leop0ld.org/posts/database-access-optimization/



**`with` template tag**

> https://docs.djangoproject.com/ko/2.2/ref/templates/builtins/#std:templatetag-with

- 동일한 쿼리를 중복으로 작성하는 경우 with 구문을 통해 해결할 수 있다.

- `.all` 자체가 여러번 반복 되는 경우

- 복잡한 변수를 더 간단한 이름으로 저장(캐시)하며, 여러번 DB 를 조회할 때(비용이 많이 드는) 유용하게 사용가능하다.

  ```django
  <!-- accounts/profile.html -->
  
  ...
  <div class="row">
  {% with articles=person.article_set.all %}
    {% for article in articles %}
    <div class="col-4 my-2">
      <div class="card">
        <div class="card-body">
          <h4 class="card-title">{{ article.content }}</h4>
          <p class="card-text">{{ article.like_users.count }}명이 좋아하는 글</p>
          <p class="card-text">{{ article.comment_set.count }}개의 댓글</p>
          <a href="{% url 'articles:detail' article.pk %}" class="btn btn-primary">DETAIL</a>
        </div>
      </div>
    </div>
    {% endfor %}
  {% endwith %}
  </div>
  
  ...
  
  <h3 class="text-center">{{ person.username }}이 작성한 댓글</h3>
  <div class="row">
  {% with comments=person.comment_set.all %}
    {% for comment in comments %}
    <div class="co-12 my-2">
      <div class="card">
        <div class="card-body">
          <blockquote class="blockquote">
            <p class="mb-0">{{ comment.content }}</p>
            <footer class="blockquote-footer">{{ comment.created_at|date:"SHORT_DATE_FORMAT" }}</footer>
          </blockquote>
        </div>
      </div>
    </div>
    {% endfor %}
  {% endwith %}
  </div>
  {% endblock %}
  ```

  - `{% with person.article_set.all as articles %}` 처럼도 작성가능하다.

  

  > 최적화가 필요하지않은 코드를 갈아엎지는 마세요. 
  >
  > 여러분이 작성하는 코드는 코드 자체적으로도 빨라야하지만, 
  >
  > 더더욱 중요한 점은 다른 개발자들이 읽기 쉬워야한다는 점입니다. 
  >
  > 
  >
  > “가장 큰 문제는 개발자들이 잘못된 시점에, 너무 효율적인 코드를 고민하며 시간을 낭비하고 있다는 겁니다.” 
  >
  > “조기 최적화는 프로그래밍에서 악의 근원입니다.” 
  >
  > *- Donald Knuth, ‘Computer Programming as an Art’*

  

### 5.3 템플릿 분할

- `base.html` 에 있는 상단에 네비게이션 바 구역을 분할해보자.

**navbar**

- bootstrap navbar 를 사용

- `_nav.html` 생성 

  - `base.html` 에 있는 `{% block content %}` 윗 부분 잘라서 그대로 가져가서 작업.

  ```django
  <!-- articles/_nav.html -->
  
  {% load gravatar %}
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    {% if user.is_authenticated %}
    <a class="navbar-brand" href="{% url 'articles:index' %}">
      <img src="https://s.gravatar.com/avatar/{{ user.email|makemd5 }}?s=30" class="d-inline-block align-top" alt="gravatar">
      Hello, {{ user.username }}
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="{% url 'accounts:update' %}">정보수정</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="{% url 'accounts:change_password' %}">비번변경</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="{% url 'accounts:logout' %}">로그아웃</a>
        </li>
        <li class="nav-item">
          <form action="{% url 'accounts:delete' %}" method="POST" style="display: inline;">
            {% csrf_token %}
            <input type="submit" value="회원탈퇴" class="btn btn-danger">
          </form>
        </li>
      </ul>
    </div>
  
    {% else %}
  
    <a class="navbar-brand" href="{% url 'articles:index' %}">
      <img src="https://s.gravatar.com/avatar/{{ user.email|makemd5 }}?s=80" width="30" height="30" class="d-inline-block align-top" alt="gravatar">
      Hello, Stranger
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="{% url 'accounts:login' %}">로그인</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="{% url 'accounts:signup' %}">회원가입</a>
        </li>
      </ul>
    </div>
    {% endif %}
  </nav>
  ```



- base.html 변경

  ```django
  <!-- articles/base.html -->
  
  <!-- {% load gravatar %} 삭제 --> 
  ...
  <body>
    {% include 'articles/_nav.html' %}
    <div class="container">
      {% block content %}
      {% endblock %}
    </div>
    {% bootstrap_javascript jquery='full' %}
  </body>
  </html>
  ```



- 마지막으로 네비게이션 바에 프로필 페이지로 갈 수 있는 링크를 만들어보자.

  ```django
  <!-- articles/_nav.html -->
  
  {% load gravatar %}
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    {% if user.is_authenticated %}
    ...
  
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="{% url 'accounts:profile' user.username %}">내프로필</a>
        </li>
  ```

  ```django
  <!-- articles/_article.html -->
  
  <div class="card mb-3">
    <div class="card-header">
      글 작성자: <a href="{% url 'accounts:profile' article.user %}" class="card-link">{{ article.user }}</a>
    </div>
    <div class="card-body">
  ```

  - 게시글의 작성자를 누르면 해당 작성자의 프로필로 이동하도록 한다.



<img width="1680" alt="Screen_Shot_2019-10-13_at_8 37 27_PM" src="https://user-images.githubusercontent.com/18046097/67463411-57bea400-f67c-11e9-8010-1369ef762f11.png">



---









