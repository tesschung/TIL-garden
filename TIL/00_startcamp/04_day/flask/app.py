from flask import Flask, render_template, request
from datetime import datetime
import random

app = Flask(__name__)

@app.route('/')
def hello():
    # return 'Hello World!'
    return render_template('index.html')


@app.route('/ssafy')
def ssafy():
    return 'This is SSAFY!'


@app.route('/dday')
def dday():
    # 오늘 날짜
    today_time = datetime.now()
    # 수료 날짜
    endgame = datetime(2019, 11, 29)
    # 수료 날짜 - 오늘 날짜
    dday = endgame - today_time
    return f'{dday.days} 일 남았습니다.'


@app.route('/html')
def html():
    return '<h1>This is HTML TAG</h1>'


@app.route('/html_line')
def html_line():
    return """
    <h1>여러 줄을 보내 봅시다</h1>
    <ul>
        <li>1번</li>
        <li>2번</li>
    </ul>
    """

# variable routing

@app.route('/greeting/<name>')
def greeting(name):
    # return f'반갑습니다! {name}'
    return render_template('greeting.html', html_name=name)


@app.route('/cube/<int:number>')
def cube(number):
    # 연산을 모두 끝내고 변수만 cube.html 로 넘긴다
    result = number**3
    # return f'{number} 세제곱은 {number**3}입니다.'
    return render_template('cube.html', result=result, number=number)

@app.route('/lunch/<int:people>')
def lunch(people):
    menu = ['짜장면', '짬뽕', '탕수육', '팔보채', '마파두부밥', '북경오리']
    order = random.sample(menu, people)
    return str(order)


@app.route('/movie')
def movie():
    movies = ['토이스토리4', '스파이더맨', '알라딘', '기생충', '엔드게임']
    return render_template('movie.html', movies=movies)


@app.route('/ping')
def ping():
    return render_template('ping.html')


@app.route('/pong')
def pong():
    # print(request.args)
    name = request.args.get('data') # 안녕하세요
    return render_template('pong.html', name=name)


@app.route('/naver')
def naver():
    return render_template('naver.html')


@app.route('/google')
def google():
    return render_template('google.html')


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

