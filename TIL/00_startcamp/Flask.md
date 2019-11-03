[TOC]

---

## Flask

### 01_Flask

> **flask 추가 설명**
>
> 파일 이름은 자유지만 `flask.py` 는 사용해선 안되며 **`app.py` 를 사용하는 것이 기본적인 원칙**이다.
>
> ```bash
> # app.py 일 경우
> $ flask run
> ```
>
> 파일 이름이 [app.py](http://app.py/) 가 아닐 경우 (예를들어`hello.py` 인 경우) 아래처럼 실행한다.
>
> ```bash
> $ FLASK_APP=hello.py flask run # 매번
> 
> # 혹은
> 
> $ export FLASK_APP=hello.py 		# 한번만하면 더이상 하지 않아도 됨(단, bash  재시작하면 다시 해야함)
> $ flask run
> ```

- flask 공식 사이트 들어가서 처음 부분은 그대로 따라해보자.

    ```bash
    $ pip install Flask
    ```

    ```python
    # hello.py
    from flask import Flask
    app = Flask(__name__)
    
    @app.route('/')
    def hello():
        return 'Hello World!'
    ```

- 서버 실행

    ```bash
    $ FLASK_APP=hello.py flask run
    
    # 혹은
    
    $ export FLASK_APP=hello.py 		# 한번만하면 더 이상 하지 않아도 됨(단, bash 재시작하면 다시 해야함)
    $ flask run
    ```

- 그런데 서버 실행 명령어가 너무 길다.
  
> `bashrc` / `bash_profile`
    >
> - vscode integrated git bash에서는 `.bash_profile`을 로드해오지 않습니다. 그래서 혹시 환경변수를 설정하실 분들은 `.bashrc`에 만드시면 됩니다. 
    > - `.bash_profile`없이 `.bashrc` 만드는 경우 git bash 실행 시 경고 메시지가 나오긴 하지만, 처음 한번만 나오고 나서 git bash에서 자동으로 `.bash_profile`을 만들어 주기 때문에 괜찮습니다.

- 환경 변수 설정 (in `.bashrc`)

  ```bash
  # ~/.bashrc
  export FLASK_APP=hello.py
  ```

  ```bash
  # 환경변수 설정 적용
  $ source ~/.bashrc
  ```

  ```bash
  # 이제는 bash 를 껐다켜도 계속 이렇게 서버 동작이 가=능하다.
  $ flask run
  ```

- [hello.py](http://hello.py) 내용이 바뀌면 항상 서버 종료 후, 다시 실행해야한다.
  
  - 서버 종료는 `ctrl + c`
  
    
  
- 서버를 매번 다시 실행하고 싶지 않다면

    ```bash
    # ~/.bashrc
    export FLASK_ENV=development
    ```

    ```bash
    $ source ~/.bashrc
    ```

    

- [`app.py`](http://app.py) 로 변경 후 제대로 진행 해보자

    ```bash
    # ~/.bashrc 에서 해당 환경변수 삭제
    export FLASK_APP=hello.py
    ```

    

- 다른 페이지를 만들어 보자.

    ```python
    # app.py
    @app.route('/ssafy')
    def ssafy():
        return 'This is SSAFY!'
    ```

    

- D-DAY

    ```python
    import datetime
    
    # 11월 29일 부터 d-day 를 출력하는 것
    @app.route('/dday')
    def dday():
        today = datetime.datetime.now()
        endgame = datetime.datetime(2019, 11, 29)
        td = endgame - today
        return f'{td.days} 일 남았습니다.'
    ```

    

- html 을 보여주자

    ```python
    @app.route('/html')
    def html():
    return '<h1>This is HTML h1 tag!</h1>'
    ```
    
    ```python
    @app.route('/html_line')
    def html_lint():
        return """
        <h1>여러줄을 보내봅시다.</h1>
        <ul>
            <li>1번</li>
            <li>2번</li>
        </ul>
        """
    ```
    
    

#### 1.1 variable routing

- greeting

    ```python
    @app.route('/greeting/<string:name>')
    def greeting(name):
        return f'반갑습니다! {name}님!'
    ```

- cube

    ```python
    @app.route('/cube/<int:number>')
    def cube(number):
        # return str(number**3)
        return f'{number}의 3제곱은 {number**3} 입니다.'
    ```

- [실습] lunch

    ```python
    @app.route('/lunch/<int:people>')
    def lunch(people):
        menu = ['짜장면', '짬뽕', '볶음밥', '고추잡채밥', '마파두부밥']
        order = random.sample(menu, people)
        return str(order)
    ```
    
    

#### 1.2 render template

- **template 관련 파일은 반드시 `templates` 폴더 안에 위치해야 한다.**

    ```bash
    # 파일 구조
    app.py
    templates/
    	index.html
    	second.html
    	...
    ```

- render template

    ```python
    # app.py
    
    from flask import Flask, render_template
    ...
    
    @app.route('/')
    def hello():
        # return 'Hello World!'
        return render_template('index.html')
    ```

    ```html
    <!-- templates/index.html -->
    
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Document</title>
    </head>
    <body>
        <h1>Heading 1 !</h1>
    </body>
    </html>
    ```

- render template with parameters

    ```python
    @app.route('/greeting/<string:name>')
    def greeting(name):
        # return f'반갑습니다! {name}님!'
    return render_template('greeting.html', html_name=name)
    ```
    
    ```html
    <!-- templates/greeting.html -->
    <h2>{{ html_name }} 왔니?</h2>
    ```
    
    ```python
    @app.route('/cube/<int:number>')
    def cube(number):
        # return str(number**3)
    # return f'{number}의 3제곱은 {number**3} 입니다.'
        result = number**3
        return render_template("cube.html", result=result, number=number)
        # 사용자가 입력한 숫자를 받아서
        # 세제곱 후 cube.html파일을 통해 응답
    ```
    
    ```django
    <!-- templates/cube.html -->
    
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Document</title>
    </head>
    <body>
        <h1>{{ number }}의 3제곱은 {{ result }} 입니다.</h1>
    </body>
    </html>
    ```
    
    

#### 1.3 jinja2 활용

- 조건문

    ```django
    <!-- templates/greeting.html -->
    
    <body>
        <!-- jinja2 template engine -->
        {% if html_name == '재찬' %}
            <h2>{{ html_name }} 왔니?</h2>
        {% else %}
            <h2>{{ html_name }}님 오셨습니까.</h2>
        {% endif %}
    </body>
    ```

- 반복문

    ```python
    @app.route('/movie')
    def movie():
        movies = ['토이스토리4', '스파이더맨', '엔드게임']
    return render_template('movie.html', movies=movies)
    ```
    
    ```django
    <!-- movie.html -->
    
    <body>
        <h1>영화 목록</h1>
        <ol>
        {% for movie in movies %}
            <li>{{ movie }}</li>
        {% endfor %}
        </ol>
    </body>
    ```

---

### 02_Flask Request Response

#### 2.1 ping pong

- ping 이 `name` 이라는 이름표를 가진 input 값을 pong 으로 보내면(`action="/pong"`)

- pong 은 `name` 이름표를 받아 input 값을 받는다. (`request.args.get('name')`)

- ping, pong

    ```python
    # app.py
    
    from flask import Flask, render_template, request
    
    @app.route('/ping')
    def ping():
        return render_template('ping.html')
    
    
    @app.route('/pong')
    def pong():
        age = request.args.get('age')
    		return render_template('pong.html', age_in_html=age)
    ```

- ping.html, pong.html

    ```django
    <!-- templates/ping.html -->
    <form action="/pong" method="GET">
    	<input type="text" name="age">
    	<input type="submit">
    </form>
    
    <!-- templates/pong.html -->
    <h1>Pong! {{ age_in_html }}!</h1>
    ```

#### 2.2 fake naver, google

```python
@app.route("/naver")
def naver():
    return render_template("naver.html")


@app.route("/google")
def google():
    return render_template("google.html")
```

```django
<!-- templates/naver.html -->

<h1>네이버 검색!!</h1>
<form action="https://search.naver.com/search.naver">
    <input type="text" name="query"/>
    <input type="submit">
</form>
```

```django
<!-- templates/google.html -->

<h1>구글 검색!!</h1>
<form action="https://www.google.com/search">
    <input type="text" name="q"/>
    <input type="submit">
</form>
```

---

### 03_Flask jamjam

#### 3.1 신이 나를 만들 때

- 신이 나를 만들 때 검색해서 `vonvon` 에서 어떻게 동작하는지 생각

    ```python
    # app.py
    from flask import Flask, render_template, request
    import random
    
    
    app = Flask(__name__)
    
    @app.route('/vonvon')
    def vonvon():
        return render_template('vonvon.html')
    
    
    @app.route('/godmademe')
    def godmademe():
        name = request.args.get('name')
        first_list = ['잘생김', '못생김', '어중간한']
        second_list = ['자신감', '쑥스러움', '애교', '잘난척']
        third_list = ['허세', '돈복', '식욕', '물욕', '성욕']
        
        first = random.choice(first_list)
        second = random.choice(second_list)
        third = random.choice(third_list)
        
    return render_template('godmademe.html', name=name, first=first, second=second, third=third)
    ```
    
    ```html
    <!-- templates/vonvon.html -->
    
    <!DOCTYPE html>
    <html lang="en">
    
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Document</title>
    </head>
    
    <body>
      <h1>신이 당신을 만들 때</h1>
      <form action="/godmademe">
        <input type="text" name="name">
        <input type="submit">
      </form>
    </body>
    </html>
    ```
    
    ```django
    <!-- templates/godmademe.html -->
    
    <!DOCTYPE html>
    <html lang="en">
    
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Document</title>
    </head>
    
    <body>
      <h1>신이 {{ name }}님을 만들 때..</h1>
      <p>{{ first }} 한 스푼</p>
      <p>{{ second }} 두세 스푼</p>
      <p>{{ third }} 한 스ㅍ.. 으아아아아아아아악</p>
    </body>
    
    </html>
    ```
    
    
    
    ---
    
    
