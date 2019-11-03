[TOC]

# SQL과 django ORM

## 기본 준비 사항

```bash
# 폴더구조

TIL
	00_StartCamp
	...
	04_db
		00_sql # only SQL
			hellodb.csv
			tutorial.sqlite3
			users.csv
		01_sql_orm # SQL + ORM
			...
			users.csv # 해당 디렉토리로 다운로드
```

* django app

  * 가상환경 세팅

  * django project : `sql`

  * django app : `users`

  * `django_extensions` 설치 및 등록

  * users.csv 파일에 맞춰 `models.py` 작성 및 migratation

    ```python
    # users/models.py
    
    from django.db import models
    
    class User(models.Model):
        first_name = models.CharField(max_length=10)
        last_name = models.CharField(max_length=10)
        age = models.IntegerField()
        country = models.CharField(max_length=10)
        phone = models.CharField(max_length=15)
        balance = models.IntegerField()
    ```

    ```bash
    $ python manage.py makemigrations
    $ python manage.py migrate 
    ```

    아래의 명령어를 통해서 실제 쿼리문 확인

    ```bash
    $ python manage.py sqlmigrate users 0001
    ```

* `db.sqlite3` 활용

  * `sqlite3`  실행

    ```bash
    $ ls
    db.sqlite3 manage.py ...
    $ sqlite3 db.sqlite3
    ```

  * csv 파일 data 로드

    ```sqlite
    sqlite > .tables
    auth_group                  django_admin_log
    auth_group_permissions      django_content_type
    auth_permission             django_migrations
    auth_user                   django_session
    auth_user_groups            auth_user_user_permissions  
    users_user
    sqlite > .mode csv
    sqlite > .import users.csv users_user
    sqlite > SELECT COUNT(*) FROM user_users;
    100
    ```

* 확인

  * sqlite3에서 스키마 확인

    ```sqlite
    sqlite > .schema users_user
    CREATE TABLE IF NOT EXISTS "users_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "first_name" varchar(10) NOT NULL, "last_name" varchar(10) NOT NULL, "age" integer NOT NULL, "country" varchar(10) NOT NULL, "phone" varchar(15) NOT NULL, "balance" integer NOT NULL);
    ```



---



## 문제

> 아래의 문제들을 보면서 서로 대응되는 ORM문과 SQL문을 작성하시오.
>
> **vscode 터미널을 좌/우로 나누어 진행하시오. (sqlite / shell_plus)**

`.headers on` 을 켜고 작성해주세요.



### 1. 기본 CRUD 로직

1. 모든 user 레코드 조회

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

2. user 레코드 생성

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```

   * 하나의 레코드를 빼고 작성 후 `NOT NULL` constraint 오류를 orm과 sql에서 모두 확인 해보세요.

3. 해당 user 레코드 조회

   - `101` 번 id의 전체 레코드 조회

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```

4. 해당 user 레코드 수정

   - ORM: `101` 번 글의 `last_name` 을 '김' 으로 수정
   - SQL: `101` 번 글의 `first_name` 을 '철수' 로 수정

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

5. 해당 user 레코드 삭제

   - ORM: `101` 번 글 삭제
   - `SQL`:  `101` 번 글 삭제 (ORM에서 삭제가 되었기 때문에 아무런 응답이 없음)

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```



---



### 2. 조건에 따른 쿼리문

1. 전체 인원 수 

   - `User` 의 전체 인원수

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```

2. 나이가 30인 사람의 이름

   - `ORM` : `.values` 활용
     - 예시: `User.objects.filter(조건).values(컬럼이름)`

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

3. 나이가 30살 이상인 사람의 인원 수

   -  ORM: `__gte` , `__lte` , `__gt`, `__lt` -> 대소관계 활용

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

4. 나이가 20살 이하인 사람의 인원 수 

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```

5. 나이가 30이면서 성이 김씨인 사람의 인원 수

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

6. 나이가 30이거나 성이 김씨인 사람?

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```

7. 지역번호가 02인 사람의 인원 수

   - `ORM`: `__startswith` 

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

8. 거주 지역이 강원도이면서 성이 황씨인 사람의 이름

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```



---



### 3. 정렬 및 LIMIT, OFFSET

1. 나이가 많은 사람순으로 10명

      ```python
   # orm
   ```

      ```sql
   -- sql
      ```

2. 잔액이 적은 사람순으로 10명

      ```python
   # orm
   ```

      ```sql
   -- sql
      ```

3. 잔고는 오름차순, 나이는 내림차순으로 10명?

      ```python
   # orm
   ```

   ```sql
   -- sql
   ```
   
4. 성, 이름 내림차순 순으로 5번째 있는 사람

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```



---



### 4. 표현식

> ORM: `aggregate` 사용
>
> https://docs.djangoproject.com/en/2.2/topics/db/aggregation/#aggregation
>
> - '종합', '합계' 등의 사전적 의미
> - 특정 필드 전체의 합, 평균 등을 계산할 때 사용

1. 전체 평균 나이

      ```python
   # orm
   ```

      ```sql
   -- sql
      ```

2. 김씨의 평균 나이

      ```python
   # orm
   ```

      ```sql
   -- sql
      ```

3. 강원도에 사는 사람의 평균 계좌 잔고

   ```python
   # orm
   ```

   ```sql
   -- sql
   ```

4. 계좌 잔액 중 가장 높은 값

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```

5. 계좌 잔액 총액

   ```python
   # orm
   ```

      ```sql
   -- sql
      ```