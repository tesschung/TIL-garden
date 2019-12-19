# Sequence Models

[TOC]

## Intro

- how to implement sequence models
- similar meaning으로 labelling하는 것 뿐만아니라
- ordering도 생각하는 것
- The sequencwe of words matters too for the meaning of a sentence

- 불용어가 단어의 의미를 파악하는데 필요하다는 것을 week2에서 확인했음

- data와 labels를 f()안에 넣으면 rules를 갖게 된다.

  f(data, labels) = rules

- RNN



## Andrew's sequence modeling course

https://www.coursera.org/lecture/nlp-sequence-models/deep-rnns-ehs0S



## 순환 신경망(Recurrent Neural Network)

> 용어는 비슷하지만 순환 신경망과 재귀 신경망(Recursive Neural Network)은 전혀 다른 개념

- 시퀀스(Sequence) 모델 : 입력과 출력을 시퀀스 단위로 처리하는 모델
- 번역기를 생각해보면 입력은 번역하고자 하는 문장. 즉, **단어 시퀀스**입니다. 출력에 해당되는 번역된 문장 또한 단어 시퀀스입니다. 

-  RNN은 은닉층의 노드에서 활성화 함수를 통해 나온 **결과값**을 출력층 방향으로도 보내면서, 다시 은닉층 노드의 다음 계산의 입력으로 보내는 특징을 갖고있습니다.

![rnn_image1_ver2](https://wikidocs.net/images/page/22886/rnn_image1_ver2.PNG)

x는 입력층의 입력 벡터

y는 출력층의 출력 벡터

RNN에서 **은닉층에서 활성화 함수를 통해 결과를 내보내는 역할**을 하는 노드를 **셀(cell)**이라고 합니다. 이 셀은 이전의 값을 기억하려고 하는 일종의 메모리 역할을 수행하므로 이를 **메모리 셀** 또는 **RNN 셀**이라고 표현합니다.

은닉층의 메모리 셀은 각각의 시점(time step)에서 바로 이전 시점에서의 은닉층의 메모리 셀에서 나온 값을 자신의 입력으로 사용하는 재귀적 활동을 하고 있습니다.

앞으로는 **현재 시점**을 변수 **t**로 표현

이는 현재 시점 t에서의 메모리 셀이 갖고있는 값은 **과거의 메모리 셀들의 값에 영향을 받은 것**임을 의미합니다. 그렇다면 메모리 셀이 갖고 있는 이 값은 뭐라고 부를까요?

메모리 셀이 출력층 방향으로 또는 다음 시점 t+1의 자신에게 보내는 값을 **은닉 상태(hidden state)**라고 합니다. 다시 말해 t 시점의 메모리 셀은 t-1 시점의 메모리 셀이 보낸 은닉 상태값을 **t 시점의 은닉 상태 계산을 위한 입력값으로 사용**합니다.

<img src="https://wikidocs.net/images/page/22886/rnn_image2_ver3.PNG" alt="rnn_image2_ver3" style="zoom:50%;" />



단어 시퀀스에 대해서 하나의 출력(many-to-one)을 하는 모델은 

- 입력 문서가 긍정적인지 부정적인지를 판별하는 감성 분류(sentiment classification)
- 메일이 정상 메일인지 스팸 메일인지 판별하는 스팸 메일 분류(spam detection)에 사용



![rnn_image4_ver2](https://wikidocs.net/images/page/22886/rnn_image4_ver2.PNG)



현재 시점 t에서 은닉 상태값을 ht라고 정의

은닉층의 메모리 셀은 ht를 계산하기 위해서 총 두 개의 가중치를 갖는다.

Wh, Wx









## 장단기 메모리(Long Short-Term Memory, LSTM)
















## :key: Keys

시퀀스-투-시퀀스(Sequence-to-Sequence), seq2seq

- 번역기에서 대표적으로 사용되는 seq2seq 모델

<img src="https://wikidocs.net/images/page/24996/%EC%8B%9C%ED%80%80%EC%8A%A4%ED%88%AC%EC%8B%9C%ED%80%80%EC%8A%A4.PNG" alt="시퀀스투시퀀스" style="zoom:50%;" />

-  seq2seq 모델 내부

<img src="https://wikidocs.net/images/page/24996/seq2seq%EB%AA%A8%EB%8D%B811.PNG" alt="seq2seq모델11" style="zoom:50%;" />

- 크게 두 개로 구성된 아키텍처로 구성되는데, 바로 인코더와 디코더

- 인코더는 입력 문장의 모든 단어들을 순차적으로 입력받은 뒤에 

  마지막에 이 모든 단어 정보들을 압축해서 하나의 벡터로 만드는데, 이를 **컨텍스트 벡터(context vector)** 라고 한다.

![컨텍스트_벡터](https://wikidocs.net/images/page/24996/%EC%BB%A8%ED%85%8D%EC%8A%A4%ED%8A%B8_%EB%B2%A1%ED%84%B0.PNG)

- 입력 문장의 정보가 하나의 컨텍스트 벡터로 모두 압축되면, 인코더는 컨텍스트 벡터를 디코더로 전송

- 디코더는 컨텍스트 벡터를 받아서 번역된 단어를 한 개씩 순차적으로 출력

![인코더디코더모델](https://wikidocs.net/images/page/24996/%EC%9D%B8%EC%BD%94%EB%8D%94%EB%94%94%EC%BD%94%EB%8D%94%EB%AA%A8%EB%8D%B8.PNG)



- 인코더 아키텍처와 디코더 아키텍처의 내부는 사실 두 개의 RNN 아키텍처
- 인코더: 입력 문장을 받는 RNN 셀
- 디코더: 출력 문장을 출력하는 RNN 셀



![image-20191216165732774](003_SequenceModels.assets/image-20191216165732774.png)





**입력층의 노드**들은 **들어온 신호를 그대로 다음 노드에 전달**하는 창구 역할만 합니다. 즉, 입력층 노드에서는 앞에서 설명한 가중합이나 활성함수 **계산을 하지 않습니다.**
이러한 이유로 입력층의 노드는 다른 노드와 다르게 사각형으로 표시 했습니다.

한편 가장 오른쪽에 배열된 노드들은 **'출력층'** 이라고 합니다. 이 노드들의 **출력이 신경망의 최종 결과값**이 됩니다.

입력층과 출력층 사이에 있는 계층들은 **'은닉층'** 이라고 부릅니다. **신경망의 외부에서는 이 계층의 노드들에 직접 접근할 수가 없어**서 이런 이름이 붙었습니다.

**입력층 - 출력층**으로만 구성된 신경망을 **'단층 신경망'** 이라고 합니다.
**단층 신경망에 은닉층이 추가**된 신경망은 **'다층 신경망'** 이라고 합니다.
**다층 신경망**은 **입력층 - 은닉층(들) - 출력층** 으로 구성

![img](https://mblogthumb-phinf.pstatic.net/MjAxNzAxMDRfMjI2/MDAxNDgzNTI2ODEzODI1.8ClG6QLFcMBbTVKIWJlrkh6IYovr0yJKgDgyKrqPoOEg.uQAnynHl1YFD205Bz8_vOBF_cv4X9rhFTt5tt53z4iUg.PNG.infoefficien/image.png?type=w800)



참고문헌:

https://m.blog.naver.com/PostView.nhn?blogId=infoefficien&logNo=220902818960&proxyReferer=https%3A%2F%2Fwww.google.com%2F