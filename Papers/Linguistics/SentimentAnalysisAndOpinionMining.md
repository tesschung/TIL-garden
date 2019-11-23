191123 영화추천사이트 구축을 위해 감정분석과 의견분석에 대한 공부의 필요성을 느꼈다.



**감정분석(sentiment analysis)과 의견분석(opinion mining)**

감정이란? Sentiment = feelings

- Attitudes
- Emotions
- Opinions



감정분석

- 감성분석이란 텍스트의 정보(information)을 추출하는 텍스트 마이닝과는 다르게 어떤 주제에 대한 주관적인 인상, 감정, 태도, 개인의 의견들을 텍스트로부터 뽑아내는 분석
- 텍스트의 polarity(극단성)을 긍정, 부정 혹은 중립을 파악하여 알아낸다.
  - 오늘 갔던 음식점 직원이 너무 불친절해서 **불편**했다. (부정)
  - 어제 본 겨울왕국2가 너무 **재밌었다**. 두 번 **보고 싶다**. (긍정)

- 분노, 슬픔, 기쁨과 같은 beyond polarity와 같은 감정의 상태도 분석 가능하다.

- 확장성
  - 초기/ 문서단계: 제품리뷰와 영화리뷰의 polarity에 집중
  - 점수가 글쓴이의 감정을 대변할 수 있다는 생각, 별점이나 평점같은 스코어 예측으로 확장
  - 더 다양한 제품의 특성에 대한 평점 예측으로 확장
  
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

- 결론

  - Humans are subjective creatures, thus opinions are powerful resources. Being able to interact with people on that level has many advantages for information systems.
  
  

참고문헌:

Introduction to Sentiment Analysis

https://lct-master.org/files/MullenSentimentCourseSlides.pdf

Sentiment analysis From Wikipedia, the free encyclopedia

https://en.wikipedia.org/wiki/Sentiment_analysis

[Keras] KoNLPy를 이용한 한국어 영화 리뷰 감정 분석

https://cyc1am3n.github.io/2018/11/10/classifying_korean_movie_review.html









의견분석