import requests
from bs4 import BeautifulSoup

url = 'https://www.naver.com'

# 요청 보내서 html 파일 받고
html = requests.get(url).text

# 뷰숲으로 정제
soup = BeautifulSoup(html, 'html.parser')

# slect 메서드로 사용해서 list 를 얻어낸다
searchings = soup.select('#PM_ID_ct > div.header > div.section_navbar > div.area_hotkeyword.PM_CL_realtimeKeyword_base > div.ah_roll.PM_CL_realtimeKeyword_rolling_base > div > ul > li > a')


# 뽑은 list 를 with 구문으로 잘 작성해보자.(txt)
with open('naver_search.txt', 'w', encoding='utf-8') as f:
    for searching in searchings:
        rank = searching.select_one('span.ah_r').text
        keyword = searching.select_one('span.ah_k').text
        f.write(f'{rank}위: {keyword}\n')
