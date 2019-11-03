from flask import Flask, render_template, request
<<<<<<< HEAD
from decouple import config # send_message.py 에서 복사
import requests # send_message.py 에서 복사

app = Flask(__name__)

api_url = 'https://api.telegram.org' # send_message.py 에서 복사
token = config('TELEGRAM_BOT_TOKEN') # send_message.py 에서 복사
chat_id = config('CHAT_ID') # send_message.py 에서 복사
naver_client_id = config('NAVER_CLIENT_ID') 
naver_client_secret = config('NAVER_CLIENT_SECRET')

# https://api.telegram.org/bot643259608:AAH8e9jZ6419YJF_xEj5g1mkT036l3DEzUk/setWebhook?url=https://aee0d68d.ngrok.io

@app.route("/")
def hello():
    return "Hello World!"


@app.route('/write')
def write():
    return render_template('write.html')


@app.route('/send')
def send():
    token = config('TELEGRAM_BOT_TOKEN')
    chat_id = config('CHAT_ID')
    text = request.args.get('message')

    requests.get(f'{api_url}/bot{token}/sendMessage?chat_id={chat_id}&text={text}')

    return render_template('send.html')


@app.route(f'/{token}', methods=['POST']) # methods는 명시해줘야함
def telegram():
    # step 1. 구조 print 해보기 & 변수 저장
    print(request.get_json())
    from_telegram = request.get_json()

    # step 2. 그대로 돌려보내기
    if from_telegram.get('message') is not None: # NoneType일 경우 예외처리
        chat_id = from_telegram.get('message').get('from').get('id')
        text = from_telegram.get('message').get('text')

        # 2. keyword
        if text[0:4] == '/번역 ':
            headers = {'X-Naver-Client-Id': naver_client_id, 'X-Naver-Client-Secret': naver_client_secret}
            data = {'source': 'ko', 'target': 'en', 'text': text[4:]}
            papago_res = requests.post('https://openapi.naver.com/v1/papago/n2mt', headers=headers, data=data)
            text = papago_res.json().get('message').get('result').get('translatedText')

        res = requests.get(f'{api_url}/bot{token}/sendMessage?chat_id={chat_id}&text={text}')
    
    return '', 200



=======
import requests
from decouple import config

app = Flask(__name__)

api_url = 'https://api.telegram.org'
token = config('TELEGRAM_BOT_TOKEN')
chat_id = config('CHAT_ID')
naver_client_id = config('NAVER_CLIENT_ID')
naver_client_secret = config('NAVER_CLIENT_SECRET')


@app.route('/')
def hello():
    return 'Hi there!'


@app.route(f'/{token}', methods=['POST'])
def telegram():
    # step 1. 데이터 구조 print 해보기
    from_telegram = request.get_json()

    if from_telegram.get('message') is not None:
        chat_id = from_telegram.get('message').get('from').get('id')
        text = from_telegram.get('message').get('text')
        # 한글 키워드 받기

        # `/번역 `으로 입력이 시작된다면, 파파고로 번역이 동작한다.
        if text[0:4] == '/한영 ':
            headers = {
                'X-Naver-Client-Id': naver_client_id,
                'X-Naver-Client-Secret': naver_client_secret    
            }
            data = {'source': 'ko', 'target': 'en', 'text': text[4:]}
            papago_res = requests.post('https://openapi.naver.com/v1/papago/n2mt', headers=headers, data=data)
            text = papago_res.json().get('message').get('result').get('translatedText') # 여기에 한/영 번역 텍스트가 있다.
        
        if text[0:4] == '/한불 ':
            headers = {
                'X-Naver-Client-Id': naver_client_id,
                'X-Naver-Client-Secret': naver_client_secret    
            }
            data = {'source': 'ko', 'target': 'fr', 'text': text[4:]}
            papago_res = requests.post('https://openapi.naver.com/v1/papago/n2mt', headers=headers, data=data)
            text = papago_res.json().get('message').get('result').get('translatedText') # 여기에 한/영 번역 텍스트가 있다.
        
        # 로또 당첨 번호 봇
        if text[0:4] == '/로또 ':
            num = text[4:]
            res = requests.get(f'https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo={num}')
            lotto = res.json()

            winner = []
            for i in range(1, 7):
                winner.append(lotto[f'drwtNo{i}'])

            bonus_num = lotto['bnusNo']
            text = f'로또 {num} 회차의 당첨 번호는 {winner} 입니다. 보너스 번호는 {bonus_num}'

        requests.get(f'{api_url}/bot{token}/sendMessage?chat_id={chat_id}&text={text}')


    return '', 200
>>>>>>> 851cc505f4254e2b9d26c364e278c0fb67591f85
