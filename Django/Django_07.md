[TOC]

---

## 00. STATIC

### 0.1 static & media file

- Static file
  - JS, CSS, Image 파일처럼 웹 서비스에서 사용하려고 미리 준비 해놓는 파일.
  - 파일 자체가 고정되어 있고, 서비스 중에도 추가되거나 변경되지 않고 고정된 파일.
- Media file
  - 사용자가 웹에서 올리는 파일.
  - 파일 자체는 고정 이지만, 언제/어떤 파일이 정적 파일로 제공 되는지는 예측할 수 없는 파일.



### 0.2 Templates 에 정적 파일 참조

> [Manage static files](https://docs.djangoproject.com/ko/2.2/howto/static-files/)
>
> [Static Files](https://docs.djangoproject.com/ko/2.2/ref/settings/#static-files)

**정적 파일의 기본 경로**

- `/APP_NAME/static/`

- 추가적인 app이 존재한다면 `settings.py`의 INSTALLED_APPS 에서 정적 하위 디렉토리를 찾는다. (등록한 app의 순서대로 찾는다. 템플릿과 동일.)

- 그래서 마찬가지로 static 도 namespace 가 필요하다.

  - `/APP_NAME/static/APP_NAME/`

- `articles/static/articles/images`에 실습용 이미지를 넣고 로드해보자

  ```django
  <!-- articles/index.html -->
  
  {% extends 'base.html' %}
  {% load static %}
  
  {% block content %}
    <img src="{% static 'articles/images/sample.png' %}" alt="sample">
    <h1 class="text-center">Articles</h1>
  ```



**`{% load static %}`**

- 주로 html 태그 위쪽에 작성한다. 만약에 템플릿 상속이 있다면, **`{% extends '' %}`** 가 가장 위쪽에 위치하도록 한다.

- 그리고 나서 static 탬플릿 태그(`{% static %}`)를 사용할 수 있고 관련 URL을 요구되는 파일에 지정할 수 있다.

  ```django
  <!-- 예시 -->
  
  {% extends '' %}
  {% load static %}
  <html>
  ```



**`{% static %}`**

- 정적 파일 내의 절대 URL 생성
- URL 이 없는 파일들에게 접근할 수 있는 URL 을 만들어 준다.
- static file은 웹 서비스를 위해 미리 준비하고 제공되기 때문에 모든 위치가 고정되어 있다.
- 단, DB에 field로 image를 만들면 DB에 image에 대한 url 정보를 포함해서 저장해두기 때문에 `{% load static %}`태그가 필요없다.



### 0.3 추가적인 위치/임의의 경로에 정적 파일 참조

- 추가적인 위치 혹은 임의의 경로에 정적 파일을 놓고 싶으면, 정적 파일이 어디에 위치해 있는지 django에게 알려 주어야 한다.

- 이때는 static 이라는 폴더의 이름을 자동으로 찾는 것이 아니라 지정한 위치 안에 있는 파일을 찾아간다. 아래 설정의 경우는 `crud/assets/images/`아래 있는 정적 파일을 찾아가게 설정하는 것이다.



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

  

**`STATIC_URL`**

- Default: None
- django 는 정적 리소스들의 위치를 알 수 없기 때문에(또는 바뀔 수 있기 때문에), `STATIC_URL`전역 설정을 기준으로 탬플릿에서의 위치를 특정할 수 있도록 한다.
- 웹 페이지에서 사용할 정적 파일의 최상위 URL 경로이다.
- 실제 파일이나 디렉토리가 아니고, URL로만 존재하는 단위이다.

  - 예시 : http://127.0.0.1:8000/static/articles/images/sample.png
- 반드시 `/`로 끝나야 한다.



`crud/assets/images/`에 이미지 파일 넣고 테스트해보기.

```django
<!-- articles/create.html -->

{% extends 'base.html' %}
{% load static %}

{% block content %}
  <img src="{% static 'images/sample.png' %}" alt="sample">
  <h1 class="text-center">CREATE</h1>
	...
```



---



## 01. Image Upload

> [Model Field reference](https://docs.djangoproject.com/ko/2.2/ref/models/fields/#module-django.db.models.fields)
>
> [FileField](https://docs.djangoproject.com/ko/2.2/ref/models/fields/#filefield)

> **null or blank**
>
> 1. 두 가지 필드의 옵션은 비슷한 역할을 하지만 차이점이 있다.
>
>    - **null**: **DB와 관련**되어 있다.(Database-related) 주어진 데이터베이스 컬럼이 Null 을 가질 것인지를 결정한다.
>    - **blank**: **데이터 유효성**과 관련되어 있다. (Validation-related) `.is_valid()`, `full_clean()`등이 호출될 때 form 유효성 검사에 사용된다.
>
> 2. 위와 같은 정의에 의하여 `null=True, blank=False` 옵션을 하나의 필드 내에서 사용하는 것은 문제가 없다. DB에서는 해당 필드가 NULL을 허용하지만, application에서는 input 태그의 `required`필드 인 것을 의미한다.
>
> 3. 주의사항
>
>    - `CharField()`와 `TextField()`와 같은 문자열 기반 필드에 `null=True`를 정의하는 것.
>    - 이렇게 설정을 하게 되면 '데이터 없음' 에 두 가지의 값, **None 과 빈 문자열**을 갖게 된다. '데이터 없음'에 대해 두 가지 값을 갖는 것은 중복이다. Null 이 아닌 빈 문자열을 사용하는 것이 장고 컨벤션이다.
>    - **문자열 기반 필드에 null=True 금지**
>
> 4. 만약 문자열 기반 모델 필드를 'nullable' 하게 만들고 싶으면 아래와 같이 설정하자.
>
>    ```python
>    class Person(models.Model):
>        name = models.CharField(max_length=25)
>        bio = models.TextField(max_length=50, blank=True) # null=True 는 금지
>        birth_date = models.DateField(null=True, blank=True) # 여기서는 null = True 설정 가능 -> 문자열 기반 모델 필드가 아닌 숫자 필드이기 때문에
>    ```
>
>    - 만약, `BooleanField`에서 Null 을 받고 싶다면, `NullBooleanField()`를 사용!



### 1.1 Model

- `Article` 모델에 새로운 컬럼 추가
  
  - 원래 대로라면 새로운 컬럼(필드)를 추가하고 `makemigrations`를 하면 어떤 값을 넣을 건지 Django가 물어본다. 왜냐하면 blank 값은 False 이기 때문이다. (데이터 무결성의 원칙에 따라 비어있는 값은 넣을 수 없다.)
- 하지만 `blank=True`로 설정하게 되면 빈문자열이 들어가도 된다! 라는 의미이므로 `makemigrations`시에 아무 것도 물어보지 않는다. (데이터 유효성 검사에서 blank 를 허용했으니 물어보지 않는다.)
  
```python
  # articles/models.py

  class Article(models.Model):
	...(title / content)
  	image = models.ImageField(blank=True)
	...(created_at / updated_at)
  ```

  - image 컬럼 코드를 기존 컬럼 코드 사이에 넣어도(title, content와 created_at과 updated_at 사이에 넣어도) 실제 추가 될 때는 테이블의 제일 우측(뒤)에 추가된다.

  ```bash
$ python manage.py makemigrations
  $ python manage.py migrate
```
  
> **추가 된 컬럼 확인**
  >
  > <img width="814" alt="7-1" src="https://user-images.githubusercontent.com/52446416/65940972-dac95180-e464-11e9-8fca-76a3947c6991.png">
  >
  > ```sqlite
  > $ sqlite3 db.sqlite3
  > 
> sqlite> .schema articles_article
  > CREATE TABLE IF NOT EXISTS "articles_article" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(20) NOT NULL, "content" text NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "image" varchar(100) NOT NULL);
> ```
  
- 모델의 변경 사항 적용

  - `makemigrations` 에서 에러가 난다면 `pip install Pillow` 설치 후 다시 진행

  - Pillow는 이미지 파일 형식을 지원하고 이미지 처리가 가능한 오픈 소스 라이브러리다.

  - 실제로 image 필드를 넣으면 아래와 같은 에러가 발생한다. Pillow를 설치하자.

    <img width="749" alt="7-2" src="https://user-images.githubusercontent.com/52446416/65940973-dac95180-e464-11e9-9013-6b2369bdd8bf.png">

    

### 1.2 Create

>  [HTML form enctype Attribute](https://developer.mozilla.org/ko/docs/Web/HTML/Element/form)

- column(필드)을 만들었으니 views 로직을 수정하고 template에 input 추가

  ```python
  # articles/views.py
  
  def create(request):
      if request.method == 'POST':
          title = request.POST.get('title')
          content = request.POST.get('content')
          image = request.FILES.get('image')
          article = Article(title=title, content=content, image=image)
          article.save()
          return redirect(article)
      ...
  ```

  

- 이미지 파일을 사용자에게 받아 보자

  - form 태그 **enctype**(인코딩) 메서드

    1. `apllication/x-www-form-urlencoded`: (기본값) 모든 문자 인코딩
    2. `multipart/form-data`: 전송되는 데이터의 형식을 지정한다. (파일/이미지 업로드 시에 반드시 사용해야 한다.)
    3. `text/plain`: 인코딩을 하지 않은 문자 상태로 전송. (공백은 '+' 기호로 변환하지만, 특수 문자는 인코딩 하지 않는다.)
- input 태그 **`accept='image/*'`**
  
  1. 업로드 시 이미지 파일만 업로드 하도록 설정
    2. 파일 업로드 시 선택 목록을 필터링 해준다. 하지만 파일 검증 까지는 못한다. (이미지만 accept 해 놓아도 비디오나 오디오 파일을 선택해서 제출할 수 있다.)
  
```django
  <!-- articles/create.html -->

  {% extends 'base.html' %}
{% load static %}
  
  {% block content %}
    ...
    <form action="{% url 'articles:create' %}" method="POST" enctype="multipart/form-data">
      {% csrf_token %}
      ...
      <label for="image">IMAGE</label>
      <input type="file" name="image" id="image" accept="image/*"><br>
      <input type="submit" value="submit">
    </form>
    <hr>
    <a href="{% url 'articles:index' %}">[back]</a>
  {% endblock %}
  ```
  
  

### 1.3 Read

> `image`에 무엇이 들어있는지 확인
>
> ```python
> # articles/views.py
> 
> from IPython import embed
> 
> def create(request):
>     if request.method == 'POST':
>         ...
>         article.save()
>         embed()
>         ...
> ```
>
> ```python
> In [1]: dir(image)                                                     
> Out[1]: 
> ['DEFAULT_CHUNK_SIZE',
>  ...,
>  'charset',
>  'chunks',
>  'close',
>  'closed',
>  'content_type',
>  'content_type_extra',
>  'encoding',
>  'field_name',
>  'file',
>  'fileno',
>  'flush',
>  'isatty',
>  'multiple_chunks',
>  'name',
>  'newlines',
>  'open',
>  'read',
>  'readable',
>  'readinto',
>  'readline',
>  'readlines',
>  'seek',
>  'seekable',
>  'size',
>  'tell',
>  'truncate',
>  'writable',
>  'write',
>  'writelines']
> 
> In [2]: image.field_name                                               
> Out[2]: 'image'
> 
> In [3]: image.name                                                     
> Out[3]: 'sample.png'
> 
> In [4]: article.image                                                  
> Out[4]: <ImageFieldFile: sample.png>
> 
> In [5]: dir(article.image)           
> Out[5]: 
> ['DEFAULT_CHUNK_SIZE',
>  ...,
>  'chunks',
>  'close',
>  'closed',
>  'delete',
>  'encoding',
>  'field',
>  'file',
>  'fileno',
>  'flush',
>  'height',
>  'instance',
>  'isatty',
>  'multiple_chunks',
>  'name',
>  'newlines',
>  'open',
>  'path',
>  'read',
>  'readable',
>  'readinto',
>  'readline',
>  'readlines',
>  'save',
>  'seek',
>  'seekable',
>  'size',
>  'storage',
>  'tell',
>  'truncate',
>  'url',
>  'width',
>  'writable',
>  'write',
>  'writelines']
> 
> In [6]: article.image.url                                              
> Out[6]: 'sample.png'
> ```



- `article.image.url` - 파일의 주소

- `article.image` - 파일 이름

  ```django
  <!-- articles/detail.html -->
  
  {% extends 'base.html' %}
  
  {% block content %}
    <h1 class='text-center'>DETAIL</h1>
    <img src="{{ article.image.url }}" alt="{{ article.image }}">
  ...
  ```

- 새로운 글을 작성해서 확인해보면

  - 이미지가 로드 되지 않는다.

  - 그리고 이미지 파일 위치가 이상한 곳(app, project, manage.py와 동일한 위치)에 업로드 된다. (개발자 도구-Network 탭 확인)

    <img width="234" alt="7-3" src="https://user-images.githubusercontent.com/52446416/65941501-26302f80-e466-11e9-847c-75a7ec6e75ab.png">
<img width="691" alt="7-4" src="https://user-images.githubusercontent.com/52446416/65941502-26c8c600-e466-11e9-8cef-dafa71200b52.png">
    
- `settings.py]`에서 `MEDIA_ROOT`를 설정 해주지 않았기 때문이다.
  
  

------



## 02. MEDIA

> [이미지 파일 필드 사용](https://docs.djangoproject.com/ko/2.2/faq/usage/#how-do-i-use-image-and-file-fields)
>
> - `FileField`/ `ImageField`를 사용할 때는 `MEDIA_ROOT`를 설정해야 한다.
>
> [Model field reference | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/fields/#imagefield)
>
> [MEDIA_ROOT& MEDIA_URL](https://docs.djangoproject.com/ko/2.2/ref/settings/#media-root)



### 2.1 기본 설정

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

---

