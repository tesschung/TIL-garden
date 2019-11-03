[TOC]

# Django_11

## 00. FOLLOW

- Follow는 User와 User의 M:N 관계이다. 그래서 이 관계를 정의하기 위해서는 User 모델을 수정해야 하는데, 우리는 이때까지 장고에서 기본으로 제공하는 User 모델을 사용해왔고 그렇기에 직접 수정할 수는 없다.
- 그래서 우리는 기본 User 모델을 대체 할건데(Substituting a custom User model), 처음부터 만드는게 아니라 장고가 자신만의 User 모델을 커스텀 할 틀을 개발자들을 위해서 제공해준다 → `AbstractUser`

### 0.1 User 모델 대체

>  [문서](https://docs.djangoproject.com/ko/2.2/topics/auth/customizing/#customizing-authentication-in-django)

>  AbstractUser vs AbstractBaseUser
>
> ![3iEnbH5-673309f5-5520-4075-96df-88c017364387](https://user-images.githubusercontent.com/18046097/67995420-b93ece00-fc8d-11e9-855c-14a604cb0b76.png)

- `AbstractBaseUser` 모습

    [https://github.com/django/django/blob/415e899dc46c2f8d667ff11d3e54eff759eaded4/django/contrib/auth/base_user.py#L47](https://github.com/django/django/blob/415e899dc46c2f8d667ff11d3e54eff759eaded4/django/contrib/auth/base_user.py#L47)

    ```python
    class AbstractBaseUser(models.Model):
        password = models.CharField(_('password'), max_length=128)
    last_login = models.DateTimeField(_('last login'), blank=True, null=True)
    ```
    
    - AbstractBaseUser 를 상속받으면 password 와 last_login 만 기본적으로 제공한다. 그렇다면 custom 할 자유도는 높은거지만, 그만큼 손 봐야할 것들이 많다.
- `AbstractUser` 모습

    [https://github.com/django/django/blob/415e899dc46c2f8d667ff11d3e54eff759eaded4/django/contrib/auth/models.py#L290](https://github.com/django/django/blob/415e899dc46c2f8d667ff11d3e54eff759eaded4/django/contrib/auth/models.py#L290)

    ```python
    class AbstractUser(AbstractBaseUser, PermissionsMixin):
        username = models.CharField(...)
        first_name = models.CharField(_('first name'), max_length=30, blank=True)
        last_name = models.CharField(_('last name'), max_length=150, blank=True)
        email = models.EmailField(_('email address'), blank=True)
        is_staff = models.BooleanField(...)
        ...
    ```



**models**

```python
# accounts/models.py

from django.conf import settings
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    followers = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='followings')
```



**settings**

> [문서](https://docs.djangoproject.com/ko/2.2/topics/auth/customizing/#substituting-a-custom-user-model)

```python
# settings.py

AUTH_USER_MODEL = 'accounts.User'    # 기본 값 : 'auth.User'
```

- Django는 맞춤 모델을 참조하는 AUTH_USER_MODEL 설정 값을 제공함으로써 기본 사용자 모델을 오버라이드하도록 할 수 있다.
- `settings.py`에 `AUTH_USER_MODEL='앱이름.모델이름'` 을 기입해야 한다.



**migration**

> [문서](https://docs.djangoproject.com/ko/2.2/topics/auth/customizing/#changing-to-a-custom-user-model-mid-project)

- 프로젝트 중간에 맞춤 사용자 모델 변경하는 것은 모델 관계에서의 외래 키, 다대다 관계에 영향을 주기 때문에 상당히 어려운 작업이다. (이 변경은 자동으로는 불가능하고 직접 스키마를 수정하고 데이터를 이전하는 등 수동으로 적용시켜야 한다.)

- 우리는 기존 Database를 완전 초기화하고 진행할 것이다.

- 아래의 3개를 반드시 수행한 후 migration 작업을 진행한다.
    - `accounts/migrations` 폴더 안에, `__init__.py` 를 제외한 파일이 있다면 모두 삭제한다.
    - `db.sqlite3` 파일을 삭제한다.
    - `settings.py`에 `AUTH_USER_MODEL` 을 정확하게 설정 하였는지 한번 더 확인한다.

    ```bash
    $ python manage.py makemigrations
$ python manage.py migrate
    ```
    
- `accounts_user_followers` 라는 테이블이 생성된다.

    <img width="286" alt="Screen_Shot_2019-06-16_at_4-ea3ebc6e-5f66-4e3a-840a-4771c028ef24 09 07_PM" src="https://user-images.githubusercontent.com/18046097/67995422-b9d76480-fc8d-11e9-84d3-73763e2b24c1.png">

- 추가로 database가 완전 초기화 되었으니 superuser도 새롭게 만들어 준다.

    ```bash
    $ python manage.py createsuperuser
    ```

- admin.py

    ```python
    # accounts/admin.py
    
    from django.contrib import admin
    from django.contrib.auth.admin import UserAdmin
    from .models import User
    
    admin.site.register(User, UserAdmin)
    ```

- 서버를 켜서 회원가입을 해보면 다음과 같은 에러가 발생한다.

    ```bash
    AttributeError at /accounts/signup/
    Manager isn't available; 'auth.User' has been swapped for 'accounts.User'
    ```



### 0.2 Custom user and built-in auth forms

> [문서](https://docs.djangoproject.com/ko/2.2/topics/auth/customizing/#custom-users-and-the-built-in-auth-forms)

- 이는 `UserCreationForm()`에 설정된 모델이 장고 기본 내장 `User` 에 연결 되어있어 발생하는 에러이다. (AuthenticationForm, PasswordChangeForm 과 같은 다른 form 들은 AbstractBaseUser 의 하위클래스로 호환되지만, `UserCreationForm()` 과 `UserChangeForm()` 은 별도로 재작성하거나 확장해야 한다.)
- `UserCreateForm()` 을 재정의 해보자.

    ```python
    # accounts/forms.py
    
    class CustomUserCreationForm(UserCreationForm):
        class Meta(UserCreationForm.Meta):
            model = get_user_model()
        fields = UserCreationForm.Meta.fields + ('email',)
    ```
    
    - 다시 회원가입을 진행 해보자.
    - 이로써 User 모델 대체가 완료되었고, User와 User의 M:N 관계도 정의되었다.



### 0.3 Follow 구현

- views.py

    ```python
    # articles/views.py
    
    from django.contrib.auth import get_user_model
    
    @login_required
    def follow(reqeust, article_pk, user_pk):
        # 게시글 유저
        person = get_object_or_404(get_user_model(), pk=user_pk)
        # 접속 유저
        user = reqeust.user
        if person.followers.filter(pk=user.pk).exists():
            person.followers.remove(user)
        else:
            person.followers.add(user)
        return redirect('articles:detail', article_pk)
    ```

    > - `if ... in ...` 방법
    >
    > ```python
    > # articles/views.py
    > 
    > @login_required
    > def follow(reqeust, article_pk, user_pk):
    >     person = get_object_or_404(get_user_model(), pk=user_pk)
    >     user = reqeust.user
    >     if user in person.followers.all():
    >         person.followers.remove(user)
    >     else:
    >         person.followers.add(user)
    >     return redirect('articles:detail', article_pk)
    > ```

- urls.py

    ```python
    # articles/urls.py
    
    urlpatterns = [
        ...,
        path('<int:article_pk>/follow/<int:user_pk>/', views.follow, name='follow'),
    ]
    ```

- templates
    - follow 템플릿에 다음과 같은 정보를 포함하는 follow 템플릿을 만들어보자. (bootstrap jumbotron)
        1. 작성자의 팔로잉, 팔로워 숫자
        2. 팔로우, 언팔로우 버튼
        3. `_follow.html` 로 분할
    - 주의할 점은 자기자신은 follow 하면 안된다.
    - detail 페이지에 게시글 작성 유저 정보를 넘겨주자 (person 을 만들지 않으면 template 에서 `article.user` 로 사용하면 된다.)

    ```python
    # articles/views.py
    
    def detail(request, article_pk):
        ...
        person = get_object_or_404(get_user_model(), pk=article.user_id)
        context = {'article': article, 'comment_form': comment_form, 'comments': comments, 'person': person,}
    return render(request, 'articles/detail.html', context)
    ```
    
    ```django
    <!-- articles/_follow.html -->
    
    <div class="jumbotron text-center text-white bg-dark">
      <p class="lead mb-1">작성자 정보</p>
      <h1 class="display-4">{{ person.username }}</h1>
      <hr>
      <p class="lead">
        팔로잉 : {{ person.followings.all|length }} / 팔로워 : {{ person.followers.all|length }}
      </p>
      {% if user != article.user %}
        {% if user in person.followers.all %}
          <a class="btn btn-primary btn-lg" href="{% url 'articles:follow' article.pk person.pk %}" role="button">Unfollow</a>
        {% else %}
          <a class="btn btn-primary btn-lg" href="{% url 'articles:follow' article.pk person.pk %}" role="button">Follow</a>
    {% endif %}
      {% endif %}
    </div>
    ```
    
    - 서로 다른 계정으로 각각 글을 작성하고 팔로우 기능을 테스트 해보자.
    
        <img width="393" alt="Screen_Shot_2019-10-13_at_7-e7b08f57-a73f-49a2-81b3-9e799d8e9f37 03 56_PM" src="https://user-images.githubusercontent.com/18046097/67995426-b9d76480-fc8d-11e9-8617-24d487c312ba.png">
    
- 실제 view 에서도 자신에게 팔로우 할 수 없도록 처리 해주자

    ```python
    @login_required
    def follow(reqeust, article_pk, user_pk):
        person = get_object_or_404(get_user_model(), pk=user_pk)
        user = reqeust.user
        if person != user:
            if person.followers.filter(pk=user.pk).exists():
                person.followers.remove(user)
            else:
                person.followers.add(user)
        return redirect('articles:detail', article_pk)
    ```



**`with` template tag**

- 이전에 배운 DB 접근 최적화를 적용해보자.

    ```django
    <div class="jumbotron text-center text-white bg-dark">
      <p class="lead mb-1">작성자 정보</p>
      <h1 class="display-4">{{ person.name }}</h1>
      <hr>
      {% with followings=person.followings.all followers=person.followers.all %}
        <p class="lead">
          팔로잉 : {{ followings|length }} / 팔로워 : {{ followers|length }}
        </p>
        {% if user != person %}
          {% if user in followers %}
            <a class="btn btn-primary btn-lg" href="{% url 'articles:follow' article.pk person.pk %}" role="button">Unfollow</a>
          {% else %}
            <a class="btn btn-primary btn-lg" href="{% url 'articles:follow' article.pk person.pk %}" role="button">Follow</a>
          {% endif %}
        {% endif %}
      {% endwith %}
    </div>
    ```

    - follow 기능에 문제가 없는지 다시 확인 해보자.

    

---



## 01. hashtag

### 1.1 Create

- Hashtag 모델 생성

- Article 모델보다 상위에 있어야 Article 에서 참조가 가능하다.

    ```python
    # articles/models.py
    
    class Hashtag(models.Model):
        content = models.TextField(unique=True)
    
        def __str__(self):
            return self.content
          
          
    class Article(models.Model):
    		...
    hashtags = models.ManyToManyField(Hashtag, blank=True)
    ```
    
    ```bash
    $ python manage.py makemigrations
    
    Migrations for 'articles':
      articles/migrations/0007_auto_20191014_1646.py
        - Create model Hashtag
        - Add field hashtags to article
    
    $ python manage.py migrate
    
    Operations to perform:
  Apply all migrations: accounts, admin, articles, auth, contenttypes, sessions
    Running migrations:
      Applying articles.0007_auto_20191014_1646... OK
  ```
  
    ```python
    # articles/admin.py
    
    from .models import Article, Comment, Hashtag
    
    ...

    class HashtagAdmin(admin.ModelAdmin):
        list_display = ('content',)
        
    admin.site.register(Hashtag, HashtagAdmin)
    ```
  
    ```python
    # articles/views.py
    
    from .models import Article, Comment, Hashtag
    
    @login_required
    def create(request):
        if request.method == 'POST':
            form = ArticleForm(request.POST)
            if form.is_valid():
                article = form.save(commit=False)
                article.user = request.user
                article.save()
            # hashtag
                for word in article.content.split(): # content 를 공백기준으로 리스트로 변경
                    if word.startswith('#'): # '#'로 시작하는 요소 선택
                        hashtag, created = Hashtag.objects.get_or_create(content=word) # word 랑 같은 해시태그를 찾고있으면 기존 객체, 없으면 새로운 객체
                        article.hashtags.add(hashtag) # created 를 사용하지 않고 hashtag[0] 으로도 작성 가능
                return redirect(article)
    	...
    ```
  
    - 추가하는 코드는 `article.save()` 보다 하단에 작성해야 한다.
    - `get_or_create`의 return object 는 `(Hashtag instance, boolean)` 형태의 튜플이며, boolean 에는 새로 만들어진 instance일 경우 `True`, 기존에 존재하던 instance일 경우 `False` 값이 온다.
    - 게시글을 작성해보고 admin 페이지에서 Hashtag 가 잘 만들어졌는지 확인해보자. (중복 방지 되는지 확인)



`unique`

> [https://docs.djangoproject.com/ko/2.2/ref/models/fields/#unique](https://docs.djangoproject.com/ko/2.2/ref/models/fields/#unique)

- `True` 인 경우 이 필드는 테이블 전체에서 고유한 값이어야 한다.
- 유효성 검사 단계에서 실행되며 중복 값이 있는 모델을 저장하려고 하면 `.save()` 메서드로 인해 `IntegrityError` 가 발생한다.
- 이 옵션은 ManyToManyField 및 OneToOneField 를 제외한 모든 필드 유형에서 유효하다.



`get_or_create(defaults=None, **kwargs)`

>  [https://docs.djangoproject.com/ko/2.2/ref/models/querysets/#get-or-create](https://docs.djangoproject.com/ko/2.2/ref/models/querysets/#get-or-create)

- QuerySets 을 return 하지 않는 메서드 중 하나.

- 주어진 kwargs 로 객체를 찾으며 필요한 경우 하나를 만든다.

- `(object, created)` 형태의 튜플을 return 한다.

- 여기서 object 는 검색 또는 생성 된 객체이고 created 는 새 객체 생성 여부를 지정하는 boolean 값이다. ( 새로 만들어진 object 이면 True, 기존에 존재하던 object 일 경우 False )

- 선택 사항인 `defaults`를 제외하고 전달 된 키워드 인수는 `get()` 호출에 사용된다.

- 단, **이 메서드는 DB 가 키워드 인자의 `unique` 옵션을 강제한다고 가정한다.**

- 이는 요청이 병렬로 작성 될 때 및 중복 코드에 대한 바로 가기로 중복 오브젝트가 작성되는 것을 방지하기 위한 것
  


### 1.2 Update

- 수정 될 때는 기존 게시글의 **hashtag 전체를 삭제한 후 다시 등록하는 과정**이다.
    - 기존 해시태그가 수정되었는지도 판단해야 하기 때문.

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
                        # hashtag
                        article.hashtags.clear() # 해당 article 의 hashtag 전체 삭제
                        for word in article.content.split():
                            if word.startswith('#'):
                                hashtag, created = Hashtag.objects.get_or_create(content=word)
                                article.hashtags.add(hashtag)
                        return redirect(article)
    ...
        ```
    
        - 게시글에 본문에 해시태그를 수정 후 잘 동작 했는지 admin 페이지에서 확인 해보자.
        - hashtag 테이블의 기존 hashtag 는 유지되어 있어야 하고 수정이나 새로운 입력으로 생긴 새 hashtag 들이 저장 되어 있어야 한다.
    
        

### 1.3 Hashtag 모아보기

- 해시태그를 클릭하면 해당 태그를 가진 게시물들만 모아서 보여 주도록 해보자.

- 아직 해시태그에 링크를 만들지 않아서 `articles/1/hashtag/` 이란 방식으로 확인 해보자.

- 템플릿은 `profile.html` 을 참고해서 `hashtag.html` 을 만들어보자.

    ```python
    # articles/views.py
    
    @login_required
    def hashtag(request, hash_pk):
        hashtag = get_object_or_404(Hashtag, pk=hash_pk)
        articles = hashtag.article_set.order_by('-pk')
        context = {'hashtag': hashtag, 'articles': articles,}
    return render(request, 'articles/hashtag.html', context)
    ```
    
    ```python
    # articles/urls.py
    
    urlpatterns = [
    ...,
        path('<int:hash_pk>/hashtag/', views.hashtag, name='hashtag'),
    ]
    ```
    
    ```django
    <!-- articles/hashtag.html -->
    
    {% extends 'articles/base.html' %}
    
    {% block content %}
    <div class="jumbotron jumbotron-fluid text-center my-2 text-white bg-dark">
      <div class="container">
        <h1 class="display-4 text-center">{{ hashtag.content }}</h1>
        <p class="lead">{{ articles|length }} 개의 게시글</p>
      </div>
    </div>
    <hr>
    <h3 class="text-center">{{ hashtag.content }} 를 태그한 글</h3>
    <div class="row">
      {% for article in articles %}
        {% with likes=article.like_users.all comments=article.comment_set.all %}
        <div class="col-4 my-2">
          <div class="card">
            <div class="card-body">
                <h5 class="card-title">{{ article.title }}</h5>
                <p class="card-text">{{ likes|length }} 명이 좋아요.</p>
                <p class="card-text">{{ comments|length }} 개의 댓글.</p>
                <a href="{% url 'articles:detail' article.pk %}" class="btn btn-success">보러가기</a>
            </div>
          </div>
        </div>
        {% endwith %}
      {% endfor %}
    </div>
    {% endblock %}
    ```
    
    

### 1.4 Hashtag 링크 연결

사용자 정의 템플릿 태그와 필터Django 사용자 정의 필터 (Custom Template Filter)를 활용하여 인스타그램 해시태그 링크 구현하기

- 현재 article 의 content 는 전체 내용이 출력된다.
- 이중에서 해시태그에 해당되는 부분만 링크를 걸어주기 위해 이전에 gravatar 에서 했던 것처럼 사용자 정의 필터(Custom Template Filter)를 만들어서 사용해야 한다.

1. articles 앱 안에 `templatetags` 폴더 생성 (폴더명은 반드시 `templatetags`)

2. templatetags 폴더안에 다음과 같은 파일트리 만들기

       articles/   
       	templatetags/
       	  __init__.py
           make_link.py

3. 사용자 정의 필터 작성

   ```python
   # articles/templatetags/make_link.py
   
   from django import template
   import re
   
   register = template.Library()
   
   @register.filter
   def hashtag_link(word):
       content = word.content + ' '
       hashtags = word.hashtags.all()
       
       for hashtag in hashtags:
           content = content.replace(hashtag.content+' ', f'<a href="/articles/{hashtag.pk}/hashtag/">{hashtag.content}</a> ')	# 마지막 공백 주의
   
       return content
   ```
   
    - `hashtag_link` 라는 이름의 함수를 정의한다. (템플릿에서 사용할 커스텀 필터의 이름이다.)
    - 해당 article 이 가지고 있는 모든 hashtags 를 순회하며, content 내에서 해당 문자열(해시태그)을 링크를 포함한 문자열로 replace 한다.
        - ex) `#스타벅스` => `<a href="/articles/hashtag/1/">#스타벅스</a>`
    - 원하는 문자열로 replace 가 완료된 result 를 return 한다.
   
4. templatetags 폴더를 추가하고 나서 반드시 **서버를 재시작** 해야 한다.



- 이제 직접 만든 필터를 적용해보자.

    ```django
    <!-- articles/detail.html -->
    
    {% extends 'articles/base.html' %}
    {% load make_link %}
    
    {% block content %}
      <h1>DETAIL</h1>
      <hr>
      <p>글 번호: {{ article.pk }}</p>
      <p>글 제목: {{ article.title }}</p>
  <p>글 내용: {{ article|hashtag_link|safe }}</p>
  ```
  
    - 템플릿 최상단에 우리가 만든 커스텀 템플릿 파일명을 `load` 해준다.
    - DTL 에서 filter 의 인자는 `| (파이프)` 앞에(왼쪽) 변수가 인자로 들어간다.
      
        - 현재 우리 코드에서는 `hashtag_link(article)` 로 동작하게 된다.
    - `safe` 필터
        - [https://docs.djangoproject.com/en/2.2/ref/templates/builtins/#safe](https://docs.djangoproject.com/en/2.2/ref/templates/builtins/#safe)
        - 출력 전에 추가 HTML escape 가 필요하지 않은 모습으로 문자열을 표시한다.
        
        

---



## 02. Social Login

> [Installation - django-allauth 0.32.0 documentation](https://django-allauth.readthedocs.io/en/latest/installation.html)

### 2.1 사전 세팅

- 인증, 등록, 계정 관리, 3rd party 계정인증 등을 다루는 많은 방법이 존재하지만 `django-allauth` 라는 통합 라이브러리를 사용하면 편하게 진행할 수 있다.

- `django-allauth` 의 장점은 대부분의 소셜 로그인을 지원하고 회원가입을 시킬 수 있다.

    ```bash
$ pip install django-allauth
    ```
    
    ```python
    # settings.py
    
    AUTHENTICATION_BACKENDS = (
        # Needed to login by username in Django admin, regardless of `allauth`
        'django.contrib.auth.backends.ModelBackend',
    )
    
    INSTALLED_APPS = [
      	...,
        'django.contrib.sites',
        'allauth',
        'allauth.account',
        'allauth.socialaccount',
        'allauth.socialaccount.providers.kakao',
    		...,
]
    
    SITE_ID = 1 # 사이트 아이디 기본값
    ```
    
    - `SITE_ID` 값을 넣어야 하는 이유
        - `django.contrib.sites` 앱을 설치하고 처음으로 레코드를 추가하면 PK가 1이기 때문이다! 해당 PK 값을 변경하면 그에 맞춰 수정을 해야 한다.
    
- **url 은 반드시 기존 accounts 주소보다 하단에 있도록 한다.**

    ```python
    # myform/urls.py
    
    from django.contrib import admin
    from django.urls import path, include
    
    urlpatterns = [
        path('accounts/', include('accounts.urls')),
        path('accounts/', include('allauth.urls')),
        path('articles/', include('articles.urls')),
        path('admin/', admin.site.urls),
    ]
    ```

    ```bash
    $ python manage.py migrate
    
    Operations to perform:
      Apply all migrations: account, accounts, admin, articles, auth, contenttypes, sessions, sites, socialaccount
    Running migrations:
      Applying account.0001_initial... OK
      Applying account.0002_email_max_length... OK
      Applying sites.0001_initial... OK
      Applying sites.0002_alter_domain_unique... OK
      Applying socialaccount.0001_initial... OK
      Applying socialaccount.0002_token_max_lengths... OK
      Applying socialaccount.0003_extra_data_default_dict... OK
    ```

    

- `/accounts/` 로 접속해서 새로운 accounts 관련 url 을 확인해보자.

    ```python
    accounts/ signup/ [name='signup']
    accounts/ login/ [name='login']
    accounts/ logout/ [name='logout']
    accounts/ delete/ [name='delete']
    accounts/ update/ [name='update']
    accounts/ password/ [name='change_password']
    accounts/ <username>/ [name='profile']
    accounts/ ^ ^signup/$ [name='account_signup']
    accounts/ ^ ^login/$ [name='account_login']
    accounts/ ^ ^logout/$ [name='account_logout']
    accounts/ ^ ^password/change/$ [name='account_change_password']
    accounts/ ^ ^password/set/$ [name='account_set_password']
    accounts/ ^ ^inactive/$ [name='account_inactive']
    accounts/ ^ ^email/$ [name='account_email']
    accounts/ ^ ^confirm-email/$ [name='account_email_verification_sent']
    accounts/ ^ ^confirm-email/(?P<key>[-:\w]+)/$ [name='account_confirm_email']
    accounts/ ^ ^password/reset/$ [name='account_reset_password']
    accounts/ ^ ^password/reset/done/$ [name='account_reset_password_done']
    accounts/ ^ ^password/reset/key/(?P<uidb36>[0-9A-Za-z]+)-(?P<key>.+)/$ [name='account_reset_password_from_key']
    accounts/ ^ ^password/reset/key/done/$ [name='account_reset_password_from_key_done']
    accounts/ ^social/
    accounts/ ^kakao/
    articles/
    admin/
    ```

    - 1번 ~ 7번까지는 우리가 구현한 url 이고 나머지는 `allauth.urls` 에서 만들어준 url 이다.
        - 표현이 이상한 이유는 Django 1.x 기준의 정규 표현식 url 경로이기 때문이다.
    - 우리가 구현한 `accounts/login` , `accounts/logout` 이 `allauth.urls` 에서 구현해준 `accounts/login` 과 `accounts/logout` 과 중복되는데 위에서부터 아래로 내려오면서 처리되기 때문에 신경쓰지 않아도 된다. (우리가 url.py 에서 기존 account 하단에 추가한 이유다.)

    

- admin  페이지에서 새로운 소셜 계정 등록 확인

    <img width="510" alt="Screen_Shot_2019-06-16_at_5-f989703f-8123-44fe-9a72-74e2d0dd98ce 33 16_PM" src="https://user-images.githubusercontent.com/18046097/67995424-b9d76480-fc8d-11e9-938a-f56103e12f0e.png">



### 2.2 KAKAO OAuth 등록

1. 카카오 개발자 센터 로그인 후에 앱 만들기 (아이콘은 없어도 된다) https://developers.kakao.com/

    - 앱 이름: edujunho
- 회사명: hphk
2. 좌측 `설정 > 일반 > + 플랫폼 추가` 클릭
3. `웹` 선택 후 사이트 도메인은 share의 application 주소를 복사 후에 추가 후 저장. (이때 주의해야 할 것은 같은 도메인 주소를 `http` 와 `https` 버전 두가지를 모두 도메인 등록을 해야 한다.)

    <img width="742" alt="Screen_Shot_2019-10-15_at_5-8b7a2113-6f19-4166-8b65-0465920360fc 32 23_PM" src="https://user-images.githubusercontent.com/18046097/67995428-ba6ffb00-fc8d-11e9-8553-9a5693e598be.png">

4. `설정 > 사용자 관리` 에서 **프로필 정보와** **카카오 계정** ON으로 변경 후, 수집 목적은 '소셜 로그인 테스트'로  입력하고 저장(아무거나 써도 관계 없음). (하나라도 빼먹으면 Keyerror 오류 발생하니 유의!)
5. 하단 `로그인 Redirect URI` 에 `http://127.0.0.1:8000/accounts/kakao/login/callback/`추가 후 저장 (localhost 로 작성시 인식하지 못함)

    <img width="773" alt="Screen_Shot_2019-10-15_at_5-e1076cec-5d7f-446a-ba53-12a52099b3d0 37 54_PM" src="https://user-images.githubusercontent.com/18046097/67995432-bb089180-fc8d-11e9-89f9-bf14b96cc32d.png">

    - [https://django-allauth.readthedocs.io/en/latest/providers.html#kakao](https://django-allauth.readthedocs.io/en/latest/providers.html#kakao)
6. **Client ID**  : `설정 > 일반` 에 있는 REST API 키
7. **Secret Key :**  `설정 > 고급 > Client Secret` 코드 생성 누른 후 상태 ON 이후에 적용 클릭
8. admin 페이지에 id와 key를 등록하기 위해 admin 페이지에서  `소셜 어플리케이션` 클릭 후 소셜 어플리케이션 추가 버튼 클릭 (`설정` → `일반`)
    - 제공자: Kakao
    - 이름: 아무거나
    - Client Id / Secret Key: Kakao 에서 REST API 키 및 Client secret 코드 가져오기
    - 키: 생략
    - 이용 가능한 sites에 로컬 서버 주소 입력 혹은 [example.com](http://example.com) 입력 후 선택된 sites 에 추가
    - 저장



### 2.3 카카오 계정으로 로그인 하기

- 기존에 `auth_form.html` 에서 로그인만 따로 떼서 `login.html` 를 만들고

- `accounts/views.py` 에서 login 함수 render `auth_form.html` → `login.html` 으로 변경

    ```python
    # accounts/views.py
    
    def login(request):
        ...
        return render(request, 'accounts/**login**.html', context)
    ```

- `login.html` 작성

    > [Templates - django-allauth 0.32.0 documentation](https://django-allauth.readthedocs.io/en/latest/templates.html#templates)

    ```django
    <!-- accounts/login.html -->
    
    {% extends 'articles/base.html' %}
    {% load bootstrap4 %}
    {% load socialaccount %}
    
    {% block content %}
      <h1>로그인</h1>
      <form action="" method="POST">
        {% csrf_token %}
        {% bootstrap_form form %}
        {% buttons submit="로그인" reset="Cancel" %}{% endbuttons %}
      </form>
      <a href="{% provider_login_url 'kakao' %}" class='btn btn-warning'>카카오 로그인</a>
{% endblock %}
    ```

    

    

    
    
    <img width="613" alt="Screen_Shot_2019-10-15_at_5-554a6aef-a848-4ba6-b7ce-0a1db408a468 06 04_PM" src="https://user-images.githubusercontent.com/18046097/67995430-ba6ffb00-fc8d-11e9-8328-76e4114b0f9a.png">
    
    - 전체 동의 후 로그인을 시도해보면 Page not found 가 나온다.
    
        <img width="820" alt="Screen_Shot_2019-10-15_at_5-d7071af6-0ff2-4ba1-8731-642f6d815039 07 37_PM" src="https://user-images.githubusercontent.com/18046097/67995431-ba6ffb00-fc8d-11e9-81cd-71a836326aad.png">
    
    - django 는 기본적으로 로그인 이후 settings.py 에  `LOGIN_REDIRECT_URL` 에 설정된 값으로 redirect 하기 때문이다. (기본값인 `/accounts/profile/` 로 redirect)



**`LOGIN_REDIRECT_URL`**

>  [Settings | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/settings/#login-redirect-url)

- Default: `'/accounts/profile/'`

- LoginView 에 `next` GET parameter 가 없는 경우 로그인 후 요청이 재 지정되는 URL 또는 이름이 지정된 URL 패턴이다.

- 우리는 경로를 메인페이지로 변경한다.

    ```python
    # settings.py
    
    LOGIN_REDIRECT_URL = 'articles:index'
    ```

- 로그아웃 후 다시 카카오 로그인을 진행하면 바로 index 페이지로 redirect 된다.
  
- 로그인이 안되는 경우 서버를 다시 껐다가 다시 로그인 해보자.
  
- admin page 에서 소셜 계정 확인해보기
    - `ACCOUNTS > 사용자(들)`

    - `계정 > 이메일 주소`

    - `소셜 계정 > 소셜 계정`

    - `소셜 계정 > 소셜 어플리케이션 토큰`

    

> 소셜 로그인에서 카카오 로그인 후 signup으로 리다이렉트 되는 경우 => 카카오 이메일과 같은 이메일이 기존 django user 정보에 등록되어 있는지 확인 후 변경



---