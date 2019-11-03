<<<<<<< HEAD
from decouple import config # 추가
import requests

api_url = 'https://api.telegram.org'
token = config('TELEGRAM_BOT_TOKEN') # 수정
chat_id = config('CHAT_ID') # 수정
text = '안녕하세요!'

send_message = requests.get(f'{api_url}/bot{token}/sendMessage?chat_id={chat_id}&text={text}')

print(send_message.text)
=======
import requests
from decouple import config

api_url = 'https://api.telegram.org'
token = config('TELEGRAM_BOT_TOKEN')
chat_id = config('CHAT_ID')
text = '안녕하세요'

send_message = requests.get(f'{api_url}/bot{token}/sendMessage?chat_id={chat_id}&text={text}')

print(send_message.text)
>>>>>>> 851cc505f4254e2b9d26c364e278c0fb67591f85
