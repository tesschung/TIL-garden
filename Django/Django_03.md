[TOC]

## Django_03

### 00. CRUD with ORM

#### 0.1 프로젝트 & app 생성

**프로젝트 생성**

```
TIL
	...
	03_django
		00_django_intro
		01_django_orm_crud
```

```bash
# 가상환경 생성
$ python -m venv venv 

# 가상환경 활성화 (또는 vscode python interpreter 로 활성화)
$ source venv/Scripts/activate
 
# 장고 설치
$ pip install django

# 프로젝트 시작
$ django-admin startproject crud . 
```



**app 생성**

```bash
$ python manage.py startapp articles
```

```python
# crud/settings.py

INSTALLED_APPS = [
    'articles.apps.ArticlesConfig',	
		...
]
```



#### 0.2 Model & DB 기본 개념

**DB의 기본 구조**

- 쿼리(Query)
    - **Query를 날린다 → 데이터를 DB에 요청한다**. → 이때 결과로 받는 데이터는 QuerySet / Model Class의 인스턴스이다.
    - 데이터를 조회하기 위한 명령어
    - 정보 시스템에 데이터를 **질의**하는 일
    - (주로 테이블형 자료구조에서) **조건에 맞는 데이터를 추출하거나 조작**하는 명령어
    
- 데이터베이스(DB)
  
    - 체계화된 데이터의 모임
    
- 스키마 (Schema) —> *뼈대(Structure)*
    - 데이터베이스에서 자료의 구조, 표현 방법, 관계 등을 정의한 구조
    - 데이터베이스 관리 시스템(DBMS)이 주어진 설정에 따라 데이터베이스 스키마를 생상하며, 데이터베이스 사용자가 자료를 저장, 조회, 삭제, 변경할 때 DBMS는 자신이 생성한 데이터베이스 스키마를 참조하여 명령을 수행
    
- **테이블** (Table) *—> **관계(Relation)** —> **엑셀의 sheet!***
    - **필드(field)**: 속성, 컬럼(Column)
        - 모델 안에 정의한 클래스에서 클래스 변수가 필드가 된다.
    - **레코드(record)**: 튜플, 행(Row)
        - 우리가 ORM을 통해 해당하는 필드에 넣은 데이터(값)을 의미한다.
    
- **우리는? 지금 당장은 SQL문에 대해서 몰라도 된다! 왜?! Django ORM이 우리를 대신해 SQL Query를 날려주니까**
    - Flask에서는 SQLAlchemy, **Django는 내장 Django ORM**, Node.js에서 Sequalize ORM을 사용
    - 현대 사회의 대부분의 프레임워크는 ORM 사용
    
    
    
- **ORM 정리**
  
    1. **개념**
    - *wikipedia*
    
            "Object-Relational-Mapping 은 객체 지향 프로그래밍 언어를 사용하여 호환되지 않는 유형의 
            시스템간에(Django - SQL)데이터를 변환하는 프로그래밍 기술이다. 
                이것은 프로그래밍 언어에서 사용할 수 있는 '가상 객체 데이터베이스'를 만들어 사용한다."
        
        - OOP 프로그래밍에서 RDBMS을 연동할 때, **데이터베이스와 객체 지향 프로그래밍 언어 간의 호환되지 않는 데이터를 변환하는 프로그래밍 기법**이다. 객체 관계 매핑이라고도 부른다.
        - 객체 지향 언어에서 사용할 수 있는 '**가상' 객체 데이터베이스를 구축하는 방법**이다.
    2. **장/단점**
        - 장점
            - **SQL을 몰라도 DB 연동이 가능**하다. (SQL 문법을 몰라도 쿼리 조작 가능)
            - SQL의 절차적인 접근이 아닌 **객체 지향적인 접근**으로 인해 생산성이 증가한다.
            - 매핑 정보가 명확하여 ERD를 보는 것에 대한 의존도를 낮출 수 있다.
            - **ORM은 독립적으로 작성되어 있고, 해당 객체들을 재활용**할 수 있다. 때문에 모델에서 가공된 데이터를 컨트롤러(view)에 의해 뷰(template)과 합쳐지는 형태로 디자인 패턴을 견고하게 다지는데 유리하다.
        - 단점
            - ORM 만으로 완전한 서비스를 구현하기 어렵다.
            - 사용은 어렵지만 설계는 신중해야 한다.
            - 프로젝트의 복잡성이 커질 경우 난이도가 상승할 수 있다.
    3. **정리**
        - SQL 문법 숙지 필요
        - 개발 코드와 DB가 서로 종속
        - **ORM이 등장하고 나서**
            - SQL 문법을 숙지 하지 않아도 쿼리 조작이 가능
            - 개발 코드와 DB가 독립되어 유지보수가 편리해졌다.
        - **객체 지향 프로그래밍에서 DB를 관리**할 때 **데이터베이스 언어(SQL)를 숙지하고 쿼리로 인한 코드 가독성 저하, 프로그램과 DB관리를 독립하기 위함과 객체를 저장하는 문제등을 해결하기 위해 ORM 프레임워크가 등장함.**
        - 즉, 우리는 **DB를 객체(object) - 인스턴스로 조작하기 위해 ORM을 사용**한다.



#### 0.3 Model 작성

**모델의 개념**

- 모델은 단일한 **데이터에 대한 정보**를 가지고 있다.
- 필수적인 필드(컬럼)와 데이터(레코드)에 대한 정보를 포함한다. 일반적으로 각각의 **모델(클래스)**는 단일한 데이터베이스 **테이블과 매핑**된다.
- 모델은 부가적인 메타데이터를 가진 **DB의 구조(layout)를 의미**
- 사용자가 저장하는 **데이터들의 필수적인 필드와 동작(behavior)** 포함



**`models.py` 정의**

```python
# articles/models.py

class Article(models.Model): # 상속
    # id(프라이머리 키)는 기본적으로 처음 테이블 생성시 자동으로 만들어진다.
    # id = models.AutoField(primary_key=True)
		
    title = models.CharField(max_length=10) # 클래스 변수(DB의 필드)
    content = models.TextField() # 클래스 변수(DB의 필드)
    created_at = models.DateTimeField(auto_now_add=True) # 클래스 변수
```

[Model field reference | Django documentation | Django](https://docs.djangoproject.com/en/2.2/ref/models/fields/#module-django.db.models.fields)

- `CharField(max_length=None, **options)`
    - **길이의 제한이 있는 문자열을 넣을 때 사용**
    - CharField의 **max_length는 필수 인자다.**
    - **필드의 최대 길이(문자)**이며 데이터베이스 레벨과 Django의 유효성 검사(값을 검증하는 것)에서 사용됨
    - 문자열 필드 → 텍스트 양이 많을 경우 `TextField()` 사용
    - 기본 양식 위젯은 **TextInput**

- `TextField(**options)`
    - **글의 수가 많을 때 사용**
    - max_length 옵션을 주면 자동양식필드의 textarea 위젯에 반영은 되지만 모델과 데이터베이스 수준에는 적용되지 않는다. (CharField 를 사용)
    - 기본 양식 위젯은 **Textarea**

- `DateTimeField(auto_now=False, auto_now_add=False, **options)`
    - **최초 생성 일자**: `auto_now_add=True`
        - django ORM이 **최초 insert(테이블에 데이터 입력)시**에만 **현재 날짜와 시간으로 갱신(테이블에 어떤 값을 최초로 넣을 때)**
    - **최종 수정 일자**: `auto_now=True`
        - django ORM이 **save를 할 때마다 현재 날짜와 시간으로 갱신**
- id(Primary Key)는 Django ORM이 자동으로 만들어 준다! (이따가 Migrations 라고 하는 폴더에 만들어진 설계도를 보고 확인하자!)




#### 0.4 Model 로직

**기본 작동 로직**

- DB 컬럼과 어떠한 타입으로 정의할 것인지에 대해 `django.db` 라는 모듈의 `models` 상속
- **각 모델은 `django.db.models.Model` 클래스의 서브 클래스로 표현된다. (자식 클래스 - 상속)**
- 모든 필드는 **기본적으로 NOT NULL 조건**이 붙는다. (NULL 값이 들어가면 안됨. 빈 값과는 다른 개념)
- 각각의 **클래스 변수**들은 **모델의 데이터베이스 필드**를 나타낸다.



#### 0.5 Migration

[Migrations](https://docs.djangoproject.com/ko/2.2/topics/migrations/)

**모델 활성화**

- **`makemigrations`**

    ```bash
    $ python manage.py makemigrations
    ```

    - makemigrations 명령어는 모델을 변경한 사실(생성/수정)과 변경 사항을 migration으로 저장한다는 사실을 Django 에게 알린다. (Python 코드 → DB 설계도)

    - migrations 폴더 안에 우리가 정의한 class를 토대로 Django ORM이 우리에게 만들어준 설계도를 확인해보자. (`0001_initial.py`)

    - Article 에 새로운 필드를 추가하고 다시 migrations 진행해보자.

        ```python
        # articles/models.py
        
        class Article(models.Model):
        		...
        updated_at = models.DateTimeField(auto_now=True)
        ```
        
        ```bash
        $ python manage.py makemigrations 
        ```
        
        

- **`migrate`**
  
- migrate 전에 `db.sqlite3` 가 정말 비어있는지 확인해보자.
  
    ```BASH
    $ sqlite3 db.sqlite3
    
    sqlite> .tables
    
    sqlite> .exit    
    ```
    
    ```BASH
    $ python manage.py migrate
    
    $ sqlite3 db.sqlite3
    ```
    
    ```BASH
    sqlite> .tables
    
    articles_article            auth_user_user_permissions
    auth_group                  django_admin_log          
    auth_group_permissions      django_content_type       
    auth_permission             django_migrations         
    auth_user                   django_session            
    auth_user_groups
    sqlite> .exit
    ```
    
    - 기존에 내가 `models.py` 에 정의하지 않았던 테이블은 장고가 기존에 미리 만들어 놓은 테이블들이다. `settings.py` 의 INSTALLED_APPS에 미리 작성되어 있던 친구들이다.
    - `migrate` 는 `makemigrations` 로 만든 설계도를 실제 `db.sqlite3` DB에 반영한다. **모델에서의 변경 사항들과 DB의 스키마가 동기화**를 이룬다.
    
    

>  **추가 사항**
>
>  **`sqlmigrate`**
>
>  - 해당 migrations 설계도가 SQL 문으로 어떻게 해석되어서 동작할지 미리 확인 할 수 있다.
>
>  ```bash
>  $ python manage.py sqlmigrate app_name 0001
>  ```
>
>  **`showmigrations`**
>
>  - migrations 설계도들이 migrate 됐는지 안됐는지 여부를 확인 할 수 있다.
>
>  ```bash
>  $ python manage.py showmigrations
>  ```



**Model 변경 시 작성 순서**

- `models.py` : 작성 및 변경(생성 / 수정)
- `makemigrations` : migration 파일 만들기(설계도)
- `migrate` : 실제 DB에 적용(테이블 생성)



**vs code로 실제 DB 테이블 확인 방법**

- vs code extension - sqlite3 검색 후 설치
  - `F1` → `sqlite` 검색 후 Open Database 클릭 → `db.sqlite3` 클릭 → 왼쪽 EXPLORER 하단에 보면 `SQLITE EXPLORER` 라고 되어있는 거 클릭

- 테이블을 확인해보면 `articles_article` 이라고 테이블 이름이 생성되어 있다.
    - INSTALLED_APPS 중 **몇몇은 최소 하나 이상의 DB 테이블을 사용**하기 때문에 migrate 와 함께 테이블이 만들어진다.
    - 테이블의 이름은 **app의 이름**과 **model 의 이름**이 조합(**모두 소문자**)되어 자동으로 생성된다. (소문자)
        - `CREATE TABLE "articles_article"` —> `app이름(articles)_소문자 모델이름(article)`

---



### 01. CRUD (DB API 조작)

#### 1.1 Django Shell

**Django shell**

- **장고 프로젝트 설정이 로딩된 파이썬 쉘**
    - **일반 파이썬 쉘을 통해서는 장고 프로젝트 환경에 접근 불가**
    - 즉, Django 프로젝트 환경에서 파이썬 쉘을 활용한다고 생각

- 프로젝트 내의 각종 모듈 패키지를 활용하기 위해서는 **Django Shell을 통해 접근**
    - `python` 이라고 실행하지 않고 `python manage.py shell` 이라고 시작한 이유는, `manage.py` 에 설정된 `DJANGO_SETTINGS_MODULE` 환경변수 때문
    
    - 이 환경변수는 `settings.py` 파일에 대한 Python 임포트 경로를 Django에게 제공하여, 대화식 Python 쉘에서 Django가 접근할 수 있는 Python 모듈 경로를 그대로 사용할 수 있다.

    - 즉, Django에서 동작하는 모든 명령을 대화식 Python 쉘에서 그대로 실행 할 수 있는 것이다
    
      ```bash
      $ pip install ipython
      
      $ python manage.py shell
      ```
    
      
    

#### 1.2 Create

**기초 설정**

- 우리가 만든 articles_article 라고 하는 테이블을 사용하기 위해서는 `import` 를 해야 한다.

    ```python
    # articles라는 앱의 models 로부터 Article 클래스를 불러오자
    >>> from articles.models import Article
    
    
    >>> Article.objects.all()
    <QuerySet []>
    # DB에 쿼리를 날려 인스턴스 객체를 전부 달라고 얘기! 이때, 레코드가 하나만 있으면 인스턴스 객체로, 두개이상이면 쿼리셋으로!(애초에 쿼리를 다르게 날림)
    ```
    
    

**Query Set 기본 개념**

- 전달 받은 모델 객체의 목록
    - QuerySet: 쿼리 set 객체
    - Query: 단일 객체
- 데이터베이스로부터 데이터를 읽고, 필터를 걸거나 정렬 등을 수행
- 쿼리(질문)를 DB에게 던저서 글을 읽거나, 생성하거나, 수정하거나, 삭제할 수 있다!
- Query(질문)을 던지는 Language(언어)를 활용해서 DB에게 데이터에 대한 조작을 요구한다!

- **`QuerySet`**
    - objects를 사용하여 **다수의 데이터를 가져오는 함수를 사용할 때 반환되는 객체**
    - 단일한 객체를 리턴할 때는 테이블(Class)의 인스턴스로 리턴됨
- **`objects`**
    - Model Manager와 Django Model 사이의 ***Query 연산의 인터페이스 역할*** 을 해주는 친구
    - 즉, `[models.py](http://models.py)` 에 설정한 **클래스(테이블)을 불러와서 사용할 때 DB와의 interface 역할(**쿼리를 날려 주는)을 하는 매니저이다.
    - 완전 러프하게는 ORM이 **클래스로 만든 인스턴스 객체**와 **db**를 연결하는데 그 사이에서 통역 역할을 하는게 ORM의 역할이라고 생각하면 된다. 즉, DB를 Python class로 조작할 수 있는 manager
        - DB ———— objects ———— Python Class(`models.py`)
    - Django는 기본적으로 모든 **Django 모델 클래스에 대해 'objects' 라는 Manager(django.db.models.Manager) 객체를 자동으로 추가**한다. Manager(objects)를 통해 특정 **데이터를 조작(메서드)**할 수 있다.
    
    


**데이터 객체를 만드는(생성하는) 3가지 방법**

**1. 첫번째 방식**

- ORM을 쓰는 이유는? DB를 조작하는 것을 객체지향 프로그래밍(클래스)처럼 하기 위해서!

- `article = Article()` : 우리가 클래스에서 **인스턴스**를 만들었던 것과 같다

- `article.title` : 인스턴스로 **클래스 변수에 접근해 해당 인스턴스 변수를 변경**하는 것과 같다.

- `article.save()` : **인스턴스로 메서드를 호출**한다!

    ```python
    # SQL문 - 특정 테이블에 새로운 행을 추가하여 데이터 추가
    # INSERT INTO table (column1, column2m ...) VALUES (value1, value2, ...);
    # INSERT INTO articles_article (title, content) VALUES ('first', 'django!');
    
    >>> article = Article() # Article(class)로부터 article(instance)
    >>> article.title = 'first' # 인스턴스 변수(title)에 값을 할당
    >>> article.content = 'django!' # 인스턴스 변수(content)에 값을 할당
    
    
    # save 를 하지 않으면 아직 DB에 값이 저장되지 않음
    >>> article
    <Article: Article object (None)>
    
    >>> Article.objects.all()                            
    <QuerySet []>
    
    
    # save 를 하고 확인하면 저장된 것을 확인할 수 있다
    >>> article.save()
    >>> article
    <Article: Article object (1)>
    >>> Article.objects.all()
    <QuerySet [Article: Article object (1)]>
    
    
    # 인스턴스인 article을 활용하여 변수에 접근해보자(저장된걸 확인)
    >>> article.title
    'first'
    >>> article.content
    'django!'
    >>> article.created_at
    datetime.datetime(2019, 8, 21, 2, 43, 56, 49345, tzinfo=<UTC>)
    ```
    
    

**두번째 방식**

- 함수에서 keyword 인자 넘기 방식과 동일

    ```python
    >>> article = Article(title='second', content='django!')
    
    
    # 아직 저장이 안되어 있음
    >>> article
    <Article: Article object (None)>
    
    
    # save를 해주면 저장이 된다.
    >>> article.save()
    >>> article
    <Article: Article object (2)>
    >>> Article.objects.all()
    <QuerySet [<Article: Article object (1)>, <Article: Article object (2)>]>
    
    
    # 값을 확인해보자
    >>> article.title
    'second'
    >>> article.content
    'django!'
    ```
    
    

**세번째 방식**

- `create()` 를 사용하면 쿼리셋 객체를 생성하고 저장하는 로직이 **한번의 스텝**

    ```python
    # 얘는 .save() 안해줘도 된다! 위의 2개의 방식과는 다르게 바로 쿼리 표현식 리턴
    >>> Article.objects.create(title='third', content='django!')
    <Article: Article object (3)>
    ```



**Query를 날려 생성한 데이터 객체 확인**

- 쿼리 메서드들은 하나 하나가 실제 데이터 결과를 직접 리턴한다기 보다는 **쿼리 표현식(Django에서는 QuerySet이라고 부르는 것)을 리턴**한다.
- 여러 메서드들을 체인처럼 연결해서 사용할 수 있다. 즉, 여러 체인으로 연결되어 리턴 된 쿼리가 해석되어 DB에 실제 하나의 쿼리를 보내게 된다.

    

**실습**

```python
# 1. 인스턴스 객체 생성 후 인스턴스 이름 공간 변수에 값 할당
>>> article = Article()
>>> article.title = 'fourth'
>>> article.content = 'django!'

# 2. id/글 생성 시각 찍어보는데 값이 안나온다.(저장이 안되서!)
>>> article.pk
>>> article.created_at

# 3. 저장을 해보자!(save 메서드 호출)
>>> article.save()

# 4. 이제 정상적으로 보인다.
>>> article.pk
4
>>> article.title
'fourth'
>>> article.content
'django!'
>>> article.created_at
datetime.datetime(2019, 8, 15, 14, 17, 0, 902812, tzinfo=<UTC>)
```



**유효성 검사**

- save 전에 `full_clean()` 메서드를 통해 article 인스턴스 객체가 validation(검증)에 적합한지를 알아 볼 수 있다.
    - `models.py` 에서 `Article` 라는 이름으로 정의한 클래스에 있는 `content` 필드의 레코드는 빈값으로 둘 수 없다고 알려준다.

    - `Charfield(max_length=10, blank=False)`

      - `blank=False` 는 기본 속성으로 적용된다.

      ```python
      >>> article = Article()
      >>> article.title = 'life is short, you need python'
      >>> article.full_clean()
      ---------------------------------------------------------------------------
      ValidationError                           Traceback (most recent call last)
      <ipython-input-30-ae01d73cadbe> in <module>
      ----> 1 article.full_clean()
      
      ~/Dropbox/ssafy/ssafy_02/03_django/01_django_orm_crud/venv/lib/python3.7/site-packages/django/db/models/base.py in full_clean(self, exclude, validate_unique)
         1201 
         1202         if errors:
      -> 1203             raise ValidationError(errors)
         1204 
         1205     def clean_fields(self, exclude=None):
      
      ValidationError: {'title': ['이 값이 최대 10 개의 글자인지 확인하세요(입력값 30 자).'], 'content': ['이 필드는 빈 칸으로 둘 수 없습니다.']}
      ```
      
      


#### 1.3 Read

**모든 객체 Query** 

```python
>>> Article.objects.all()
<QuerySet [<Article: Article object (1)>, <Article: Article object (2)>, <Article: Article object (3)>, <Article: Article object (4)>]>
```



**객체 표현 변경**

- QuerySet 객체를 그대로 return해서 불편하다. 객체의 표현식을 바꿔보자.

- 객체의 표현을 바꾸는 것은 **인터프리터에서 편하게 보기 위함** + **admin 사이트에서도 객체의 표현 사용**
    - 인스턴스 객체로 메서드를 호출하면, 인스턴스 객체는 첫번째 인자로 자기 자신을 넘긴다. 통상적으로 self를 첫번째 인자로 넣기 때문에 인스턴스 객체가 self가 된다.
    - `__str__` : 인스턴스 자체를 출력 할 때, 형식을 지정 해주는 함수(매직 메서드 - 특수 목적)

    ```python
    # articles/models.py
    
    class Article(models.Model):
    	...
    		def __str__(self):
        return f'{self.id}번글 - {self.title} : {self.content}'
    ```
    
- `__str__`
  
    - `str()`, `format()`, `print()` 에 의해 호출되어 객체의 '비형식적인(informal)' 또는 보기 좋게 인쇄 가능한 문자열 표현을 계산한다. return 값은 반드시 문자열 객체 여야 한다.



**변경된 객체 표현 확인**

- 객체의 표현을 변경 했으니 shell 을 재시작한다.

- **model이 변경된 건 아니기 때문에 따로 migrate는 필요 없음**

    ```bash
    $ python manage.py shell
    
    >>> from articles.models import Article
    
    
    # 인스턴스 객체로 메서드를 호출하면, 인스턴스 객체는 첫번째 인자로 자신을 넘긴다.   
    >>> Article.objects.all()
    <QuerySet [<Article: 1번글 - first>, <Article: 2번글 - second>, <Article: 3번글 - third>, <Article: 4번글 - fourth>]>
    ```
    
    
    
    

**SQL → ORM**

> **`.get()`**
>
> - `.get()` 을 사용할 때 객체가 없으면 DoesNotExist 에러가 나오고 객체가 여러 개일 경우에 MultipleObjectReturned 오류를 띄움.
> - 위와 같은 특징을 가지고 있기 때문에 unique 혹은 Not Null 특징을 가지고 있으면 사용할 수 있다.
> - 또한, 우리가 `.get(id=1)` 형태 뿐만 아니라 `.get(pk=1)` 로 사용할 수 있는 이유는(DB에는 id로 필드 이름이 지정 됨에도) `.get(pk=1)` 이`.get(id__exact=1)` 와 동일한 의미이기 때문이다. pk는 `id__exact` 의 shortcut 이다.
> - 쿼리셋은 쿼리셋 객체이고 단일 객체는 클래스의 인스턴스이다. (실제로 type을 찍어보면 QuerySet과 Article의 인스턴스라고 다르게 나온다.)

```python
# 1. SELECT * FROM articles_article; (articles라는 테이블에서 전체 컬럼(*) 데이터 가져오기

# 1. DB에 저장된 모든 글 가져오기
>>> articles = Article.objects.all()
>>> articles
<QuerySet [<Article: 1번글 - first>, <Article: 2번글 - second>, <Article: 3번글 - third>, <Article: 4번글 - fourth>]>


# 새로운 글 추가 작성
>>> Article.objects.create(title='fifth', content='hahaha')
<Article: 5번글 - fifth>


-----


# 2. SELECT * FROM articles_article WHERE title='first';
# 2. DB에 저장된 글 중에서 title이 first인 글만 가져오기

>>> articles = Article.objects.filter(title='first')
>>> articles
<QuerySet [<Article: 1번글 - first>]>


# title이 first인 글을 하나 더 추가하고 다시 확인
>>> Article.objects.create(title='first', content='vacation!')
<Article: 6번글 - first>


# filter 로 확인! (articles = Article.objects.filter(title='first'))
>>> articles
<QuerySet [<Article: 1번글 - first>, <Article: 6번글 - first>]>


-----


# 3. SELECT * FROM articles_article WHERE title='first' LIMIT 1; 
# LIMIT는 1개만 가져온다는 것을 의미
# 3. DB에 저장된 글 중에서 title이 first인 글 중에서 첫번째 글만 가져오기

>>> article = Article.objects.filter(title='first').first()
>>> article
<Article: 1번글 - first>

# 마지막 값을 가져옴
>>> article = Article.objects.all().last()
>>> article
<Article: 6번글 - first>


-----


# 4-1. SELECT * FROM articles_article WHERE id=1;
# 4. DB에 저장된 글 중에서 pk가 1인 글만 가져오기

>>> article = Article.objects.get(pk=1)
>>> article
<Article: 1번글 - first>
>>> type(article)



# PK 만 get으로 가져올 수 있다. (get은 값이 중복이거나 일치하는 값이 없으면 오류가 나기 때문) PK 에만 사용하자.
# 리턴 값은 article 객체이다.


# 4-2. 만약에 존재하지 않는 것을 가져오면 에러가 난다.
>>> article = Article.objects.get(pk=10)
DoesNotExist: Article matching query does not exist.

# 혹은 중복 값이 나오면 에러가 난다.
>>> article = Article.objects.get(title='first')
MultipleObjectsReturned: get() returned more than one Article -- it returned 2!


# 하지만 filter의 경우 존재하지 않으면 에러가 아닌 빈 QuerySet을 return 한다. 마치 딕셔너리에서 value를 꺼낼 때 [] 방식으로 꺼내냐 혹은 .get을 사용하느냐와 유사
>>> article = Article.objects.filter(pk=10)
>>> article
<QuerySet []>



# 4-3. filter / get 비교
# filter는 해당되는 QuerySet 객체를 전부 다 가지고 온다. (값이 몇개인지 보장하지 못하기 때문에 하나도 없으면 빈 QuerySet을 return)


# filter 자체가 여러 값을 가져올 수 있기 때문에 장고가 몇개인지 보장을 못해서 0개, 1개라도 쿼리셋을 리턴한다.
>>> article = Article.objects.filter(pk=1)
>>> article
<QuerySet [<Article: 1번글 - first>]>


# .get() 으로 pk 를 가져오는 것과 다르게 QuerySet(리스트형식) 으로 가져오기 때문에 article.id 등으로 접근 불가.
>>> article.pk
AttributeError: 'QuerySet' object has no attribute 'pk'
>>> article.title
AttributeError: 'QuerySet' object has no attribute 'title'


# 쿼리셋 객체(articles)라고 불렀을 때와 비교)
>>> type(article)
<class 'django.db.models.query.QuerySet'>

# .get() 으로 데이터를 가져와보자
>>> article = Article.objects.get(pk=1)
>>> type(article)
<class 'articles.models.Article'>

# .get() 으로 부르면 인스턴스 객체이기 때문에 변수 접근 하는 것처럼 사용 가능
>>> article = Article.objects.get(pk=1)
>>> article.pk
1
>>> article.title
'first'



-----



# 5-1. SELECT * FROM articles_article ORDER BY title ASC; 
# 주로 다른 것들과 조합해서 많이 사용

# 오름차순
>>> articles = Article.objects.order_by('pk')
>>> articles
<QuerySet [<Article: 1번글 - first>, <Article: 2번글 - second>, <Article: 3번글 - third>, <Article: 4번글 - fourth>, <Article: 5번글 - fifth>, <Article: 6번글 - first>]>


# 5-2. SELECT * FROM articles_article ORDER BY title DESC;
# 내림차순
>>> articles = Article.objects.order_by('-pk')
>>> articles
<QuerySet [<Article: 6번글 - first>, <Article: 5번글 - fifth>, <Article: 4번글 - fourth>, <Article: 3번글 - third>, <Article: 2번글 - second>, <Article: 1번글 - first>]>


-----


# 6. 쿼리셋은 list 자료형은 아니지만, 리스트에서 할 수 있는 인덱스 접근 및 슬라이싱이 모두 가능하다. (QuerySet은 2개 이상의 객체 - 1개이면 그냥 쿼리 객체)
# limit & offset
# [offset:limit]
# offset -> 앞에서 몇 번째 부터 
# limit -> 몇 개를 가져올 것인지!

>>> article = Article.objects.all()[2]
>>> article
<Article: 3번글 - third>


>>> articles = Article.objects.all()[1:3]
>>> articles
<QuerySet [<Article: 2번글 - second>, <Article: 3번글 - third>]>


# 타입을 찍어보면 list는 아니고 QuerySet 객체임을 알 수 있다.
>>> type(articles)
<class 'django.db.models.query.QuerySet'>

# 이건 그냥 Article 클래스의 객체
>>> article = Article.objects.get(pk=1)
>>> type(article)
<class 'articles.models.Article'>


-----


# 7. LIKE / startswith / endswith
# 장고 ORM 은 이름(title) 과 필터(contains) 를 더블언더스코어로 구분합니다.

# LIKE
>>> articles = Article.objects.filter(title__contains='fir')
>>> articles
<QuerySet [<Article: 1번글 - first>, <Article: 6번글 - first>]>


# startwith
>>> articles = Article.objects.filter(title__startswith='first')
>>> articles
<QuerySet [<Article: 1번글 - first>, <Article: 6번글 - first>]>


# endswith
>>> articles = Article.objects.filter(content__endswith='!')
>>> articles
<QuerySet [<Article: 1번글 - first>, <Article: 2번글 - second>, <Article: 3번글 - third>, <Article: 4번글 - fourth>, <Article: 6번글 - first>]>


# 이것도 당연히 인덱싱 접근이 가능하다 왜? 쿼리셋 이니까!
>>> Article.objects.filter(content__endswith='!')[1]
<Article: 2번글 - second>
```



#### 1.4 Update

- article 인스턴스 객체 생성

- `article.title = 'byebye'`: article 인스턴스 객체의 인스턴스 변수에 접근하여 기존의 값을 `byebye` 로 변경

- `article.save()` : article 인스턴스를 활용하여 `save()` 메서드 실행

    ```python
    # UPDATE articles SET title='byebye' WHERE id=1;
    >>> article = Article.objects.get(pk=1)
    >>> article.title
    'first'
    
    
    # 값을 변경하고 저장
    >>> article.title = 'byebye'
    >>> article.save()
    
    
    # 정상적으로 변경된 것을 확인
    >>> article.title
    'byebye'
    ```
    
    

#### 1.5 Delete

- article 인스턴스 생성후 `.delete()` 메서드 호출!

    ```python
    # UPDATE articles SET title='byebye' WHERE id=1;
    >>> article = Article.objects.get(pk=1)
    >>> article.title
    'first'
    
    
    # 값을 변경하고 저장
    >>> article.title = 'byebye'
    >>> article.save()
    
    
    # 정상적으로 변경된 것을 확인
    >>> article.title
    'byebye'
    ```

    - 핵심은 우리는 ORM을 통해 클래스의 인스턴스 객체로 DB를 조작할 수 있다는 사실을 배움
    - 앞으로 CRUD 로직을 작성하면서 이 부분들을 활용할 것이다.

    

---



### 02. Admin

- 사용자가 아닌 서버의 관리자가 활용하기 위한 페이지.
- Article class 를 `admin.py` 에 등록하고 관리
- record 생성 여부 확인에 매우 유용하고 직접 레코드를 삽입할 수도 있다.



#### 2.1 관리자 생성

```bash
$ python manage.py createsuperuser
```

- 관리자 계정 생성 후 서버를 실행한 다음 `/admin` 으로 가서 관리자 페이지 로그인
- 계정만 만들면 실제로 Django 관리자 화면에서 아무 것도 보이지 않는다. `admin.py` 로 가서 관리자 사이트에 등록하여 내가 만든 record를 보기 위해서는  Django에게 얘기를 해줘야 한다!
- **처음에 auth 관련된 기본 테이블이 생성되지 않으면 관리자를 생성할 수 없다.**



#### 2.2 관리자 사이트에 등록

- admin 사이트에 방문해서 우리가 현재까지 작성한 글들을 확인 해보자.
- `admin.py` 는 관리자 사이트에 Article 객체가 관리 인터페이스를 가지고 있다는 것을 알려주는 것이다.
- 이렇게 admin 사이트에 등록된 모습이 어딘가 익숙하다? 바로 `models.py` 에 정의한 `__str__` 의 형태로 객체가 표현된다. (`list_display` 를 설정하지 않은 경우 1개의 column으로 표현됨)
- 실제로 `__str__` 부분을 주석처리 하고 reload를 하면 객체 자체가 출력 되는 것을 볼 수 있다.

    ```python
    # articles/admin.py
    
    from django.contrib import admin
    from .models import Article # 명시적 상대경로 표현
    
    admin.site.register(Article)
    ```

- 모델의 각 필드 유형들은 적절한 HTML 입력 위젯으로 표현된다. 필드의 각 유형들은 Django 관리자 사이트에서 어떻게 표현되어야 할지 이미 알고 있다.
- `list_display` 설정을 하지 않으면, admin 페이지는 단일한 컬럼 값만 `__str__(self)` 에 설정한 형태로 결과를 보여 준다.



#### 2.3 관리자 변경 목록(change list) 커스터마이징

[https://docs.djangoproject.com/ko/2.2/intro/tutorial07/#customize-the-admin-form](https://docs.djangoproject.com/ko/2.2/intro/tutorial07/#customize-the-admin-form)

[https://docs.djangoproject.com/ko/2.2/ref/contrib/admin/#module-django.contrib.admin](https://docs.djangoproject.com/ko/2.2/ref/contrib/admin/#module-django.contrib.admin)

**list_display**

- admin 사이트에서 직접 레코드를 추가 해보자!

- `list_display` 는 admin 페이지에서 우리가 `models.py` 정의한 각각의 **속성(컬럼)들의 값(레코드)**를 보여준다.

    ```python
    # articles/admin.py
    
    from django.contrib import admin
    from .models import Article
    
    class ArticleAdmin(admin.ModelAdmin):
        list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
    
        admin.site.register(Article, ArticleAdmin)
    ```
    
    ```python
    # 또는 데코레이터를 사용해서도 할 수 있다.
    
    @admin.register(Article)
    class ArticleAdmin(admin.ModelAdmin):
        list_display = ('id', 'title', 'content', 'created_at', 'updated_at',)
    ```



**list_filter**

- 특정 필드에 의해 변경 목록을 필터링 할 수 있게 해주는 "Filter" 사이드 바를 추가한다.

    ```python
    # articles/admin.py
    
    class AricleAdmin(admin.ModelAdmin):
        list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
        list_filter = ('created_at',)
        
    admin.site.register(Article, AricleAdmin)
    ```
    
    - 표시되는 필터의 유형은 필터링중인 필드의 유형에 따라 다르다.
    - created_at 는 DateTimeField 이므로, Django는 "Any date", "Today", "Past 7 days", "This month", "This year" 등의 적절한 필터 옵션을 제공한다.



**list_display_links**

- 목록 내에서 링크로 지정할 필드 적용 (설정하지 않으면 기본 값을 첫번째 필드에 링크가 적용된다)

    ```python
    class AricleAdmin(admin.ModelAdmin):
        list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
        list_display_links = ('content',)
        list_filter = ('created_at',)
    
    admin.site.register(Article, AricleAdmin)
    ```



**list_editable**

- 목록 상에서 직접 수정할 필드 적용

    ```python
    class AricleAdmin(admin.ModelAdmin):
        list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
        list_display_links = ('content',)
        list_filter = ('created_at',)
        list_editable = ('title',)
    
    admin.site.register(Article, AricleAdmin)
    ```



**list_per_page**

- 한 페이지에 표시되는 항목 수 제어 (기본 값 : 100)

    ```python
    class AricleAdmin(admin.ModelAdmin):
        list_display = ('pk', 'title', 'content', 'created_at', 'updated_at',)
        list_display_links = ('content',)
        list_filter = ('created_at',)
        list_editable = ('title',)
        list_per_page = 2
    ```



---



### 03. Django extensions

https://django-extensions.readthedocs.io/en/latest/

#### 3.1 설치 & 등록

- Django-extension은 커스텀 확장 툴이다. Django app 구조로 되어 있기 때문에 한 프로젝트에서 사용하기 위해서는 해당 app을 활성화시켜야 한다. 즉, INSTALLED_APPS에 등록 필요

- Django-extensions를 설치하면 `shell_plus` 를 사용할 수 있는데, Django shell은 직접 모델을 import 해야 하는 불편함이 있었지만,  `shell_plus` 는 필요한 모델을 자동으로 import 해주기 때문에 매우 편리하다.

  ```bash
  $ pip install django-extensions
  ```

  ```python
  # settings.py
  
  INSTALLED_APPS = [
      ...
      'django_extensions',
      ...
  ]
  
  ```



#### 3.2 활용

- 글을 쓰는 3가지 방법을 활용해 글을 작성해보자

    ```bash
    $ python manage.py shell_plus
    ```
    
    ```python
    # 1. 첫번째
    >>> article = Article()
    >>> article.title = 'haha'
    >>> article.content = 'hoho'
    >>> article.save()
    
    # 2. 두번째
    >>> article = Article(title='yaya', content='yoyo')
    >>> article.save()
    
    # 3. 세번째
    >>> Article.objects.create(title='wowo', content='yeye')
    <Article: 9번글 - wowo>
    
    # 모든 글을 가져와보자
    >>> Article.objects.all()
    <QuerySet [<Article: 2번글 - second>, <Article: 3번글 - third>, 
    <Article: 4번글 - fourth>, <Article: 5번글 - fifth>, <Article: 6번글 - first>, <Article: 7번글 - haha>, 
    <Article: 8번글 - yaya>, <Article: 9번글 - wowo>]>
    ```

