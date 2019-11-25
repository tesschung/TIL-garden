191123 영화추천사이트 구축을 위해 감정분석과 의견분석에 대한 공부의 필요성을 느꼈다.

191125 의견분석과 감성분석의 차이 확인



**감정분석(sentiment analysis)과 의견분석(opinion mining)**

인간언어의 근원적 문제 – 중의성 (ambiguity) 

- ‘감기’ 

-  ‘늙은 사또와 기생’ 

- ‘여기 물이 좋은데’ 

중의성 해결이 자연언어처리의 목표



# 감정분석(Sentiment Analysis)

# 의견분석(Opinion Analysis)



감정이란? 

Sentiment = feelings

A strong feeling deriving from one’s circumstances, mood, or relationships with others.

![emotion](http://datamining.dongguk.ac.kr/lectures/bigdata/figures/emotion.png)

- Attitudes

  - 나도 아이패드 사고싶다.
- Emotions
  - 아이폰을 사게되어 기쁘다
- Opinions
  - 갤럭시 화질은 깨끗하다.
  - 아이폰이 갤럭시보다 튼튼하다

---


- 감성분석이란 텍스트의 정보(information)을 추출하는 텍스트 마이닝과는 다르게 어떤 주제에 대한 주관적인 인상, 감정, 태도, 개인의 의견들을 텍스트로부터 뽑아내는 분석

- Subjectivity analysis (`주관분석`): 개인의 생각, 감정, 신념 또는 객관적으로 볼 수 없는 “개인적 상태”와 관련된 기타 정보를 나타내는 텍스트의 식별 (Quirk 외 1985)

  - “청와대의 *고위공무원*은 북미정상회담이 성공할 것으로 *믿는다*.”
  - 분노, 슬픔, 기쁨과 같은 beyond polarity와 같은 감정의 상태도 분석 가능하다.

- Sentiment analysis (`감성분석`): 텍스트의 주관적인 가치(valence)를 식별
  
  - 문맥(context)의 안과 밖의 단어 유형
- 구문, 문장, 단락 또는 전체문서 단위의 다양한 세부단위에서 분석 가능
  - 각 수준의 분석에서 이진점수(positive vs. negative) 또는 그 이상의 점수(1,2,3,4,5)를 부여
  - “청와대의 고위공무원은 북미정상회담이 *성공할* 것으로 믿는다.”
    - 텍스트의 polarity(극단성)을 긍정, 부정 혹은 중립을 파악하여 알아낸다.
      - 오늘 갔던 음식점 직원이 너무 불친절해서 **불편**했다. (부정)
      - 어제 본 겨울왕국2가 너무 **재밌었다**. 두 번 **보고 싶다**. (긍정)
  
- `Opinion analysis (의견분석): 주관분석 + 감성분석`

- 확장성
  - 초기/ 문서단계: 제품리뷰와 영화리뷰의 polarity에 집중
  - 점수가 글쓴이의 감정을 대변할 수 있다는 생각, 별점이나 평점같은 스코어 예측으로 확장
  - 더 다양한 제품의 특성에 대한 평점 예측으로 확장
    - 화질이 구리다
      - 속성: 디스플레이, 속성표현: 화질, 속성값: 구리다
  
- 방법1
  - 분류기 
    - Max Entropy 
    - SVM
    - SentiWordnet
    - LIWC
    - [한국어 감정 분석 말뭉치](http://word.snu.ac.kr/kosac/)
  - -10 ~ 10 범위의 긍정, 부정, 중립 스케일링
  
- 방법2

  - Knowledge-based techniques

    - 텍스트의 기쁨, 슬픔, 두려움, 지루함 같은 확실한 효과단어(affect word)의 존재에 기반한 affect categories로 분류
      - the steak was tough and tasteless but the wine was **wonderful**
    - 특정 감정과 관련성 있음직한 임시적 단어(arbitrary word)할당 가능

  - Statistical methods

    - 기계학습 사용
      - Latent semantic analysis
      - Support vector machines
      - Bag of words
      - semantic orientation
      - 해당효과감성을 가진 사람 혹은 타겟을 찾는다. 문맥상 혹은 특징의 의견을 얻기위해 단어들의 문법적 관계들도 사용

  - Hybrid approaches

    - 미묘한 방식으로 표현된 의미들을 감지하기 위해 사용
    - 관련 정보들을 명시적으로 전달하지는 않지만 암묵적으로 전달하는 연결된 다른 개념들에 대한 분석
      - ontologies
      - Semantic networks

- 데이터 수집

    - 인터넷 상에 있는 방대한 양의 소셜미디어 및 블로그, 게시판 등의 자료 수집 
    - 보통 검색 엔진 활용 
    - 수집된 데이터는 ‘감정’과는 관련이 없는 자료도 있기 때문에 필요한 자료만을 추출하는 주관성 탐지 작업이 필요 
    - 대개 인터넷 자료는 비형식적, 비문법적 자료가 많기 때 문에 이를 처리할 수 있는 선처리 작업이 필요

- 결론

  - Humans are subjective creatures, thus opinions are powerful resources. Being able to interact with people on that level has many advantages for information systems.

  

참고문헌:

Introduction to Sentiment Analysis

https://lct-master.org/files/MullenSentimentCourseSlides.pdf

Sentiment analysis From Wikipedia, the free encyclopedia

https://en.wikipedia.org/wiki/Sentiment_analysis

[Keras] KoNLPy를 이용한 한국어 영화 리뷰 감정 분석

https://cyc1am3n.github.io/2018/11/10/classifying_korean_movie_review.html

텍스트에서 자동 감정/의견 분석 - 신효필

[http://hosting02.snu.ac.kr/~snucss/wp-content/uploads/2016/04/11.11_%E1%84%89%E1%85%B5%E1%86%AB%E1%84%92%E1%85%AD%E1%84%91%E1%85%B5%E1%86%AF%E1%84%80%E1%85%AD%E1%84%89%E1%85%AE.pdf](http://hosting02.snu.ac.kr/~snucss/wp-content/uploads/2016/04/11.11_신효필교수.pdf)

