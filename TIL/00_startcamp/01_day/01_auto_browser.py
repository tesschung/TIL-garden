# import webbrowser

# 1. 리스트가 필요
# sites = ['www.naver.com', 'www.google.com', 'www.daum.net']

# idols = ['bts', 'nrg', 'hot', 'babyvox']
# url = 'https://search.naver.com/search.naver?query='

# 2. 반복문(for) 안에서 webborwser.open_new() 이 실행
# for idol in idols:
#     webbrowser.open_new(url + idol)


import requests

response = requests.get('https://www.naver.com/').status_code
print(response)




