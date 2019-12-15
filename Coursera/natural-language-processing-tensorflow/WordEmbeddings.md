# Word Embeddings

[TOC]

## Intro 

- how embeddings work for representing the semantics of a word

- instead of the word just being a number, using a vector in n-dimensional space.



[말뭉치 - corpus]([https://ko.wikipedia.org/wiki/%EB%A7%90%EB%AD%89%EC%B9%98](https://ko.wikipedia.org/wiki/말뭉치))

자연언어 연구를 위해 특정한 목적을 가지고 **언어의 표본을 추출한 집합**이다. 컴퓨터의 발달로 말뭉치 분석이 용이해졌으며 분석의 정확성을 위해 해당 자연언어를 [형태소 분석](https://ko.wikipedia.org/wiki/형태소_분석)하는 경우가 많다. 확률/통계적 기법과 시계열적인 접근으로 전체를 파악한다. 언어의 빈도와 분포를 확인할 수 있는 자료이며, 현대 언어학 연구에 필수적인 자료이다. 인문학에 자연과학적 방법론이 가장 성공적으로 적용된 경우로 볼 수 있다.



[word embedding](https://3months.tistory.com/136 )

Deep Learning 분야, 이 중에서도 특히 자연어처리에서 필수적으로 알아야할 개념이다. Word Embedding은 Word를 R차원의 Vector로 매핑시켜주는 것을 말한다.

<img src="WordEmbeddings.assets/image-20191212100307167.png" alt="image-20191212100307167" style="zoom:25%;" />

- Words and associated words are clustered as vectors in a multi-dimensional space

- movie review classification; positive and negative



## The IMBD dataset

- tensorflow에서 기본적으로 제공하는 imdb dataset을 사용하여 실습할 것

[Large Movie Review Dataset](http://ai.stanford.edu/~amaas/data/sentiment/)

contains 50,000 movie reviews etc

```
@InProceedings{maas-EtAl:2011:ACL-HLT2011,
  author    = {Maas, Andrew L.  and  Daly, Raymond E.  and  Pham, Peter T.  and  Huang, Dan  and  Ng, Andrew Y.  and  Potts, Christopher},
  title     = {Learning Word Vectors for Sentiment Analysis},
  booktitle = {Proceedings of the 49th Annual Meeting of the Association for Computational Linguistics: Human Language Technologies},
  month     = {June},
  year      = {2011},
  address   = {Portland, Oregon, USA},
  publisher = {Association for Computational Linguistics},
  pages     = {142--150},
  url       = {http://www.aclweb.org/anthology/P11-1015}
}
```



## Looking into the details

- data 준비, tokenizing 시작





## How can we use vectors?

- say a negative review and the words dull and boring show up a lot in the negative review so that they have similar sentiments, and they are close to each other in the sentence. Thus their vectors will be similar.

- Dull and boring
- exciting and fun
- Meaning of the words comes from the labels



## More into the details



```python
import tensorflow as tf # 가장 처음 선언
print(tf.__version__)

# 1.x 버전이면 이거 사용해야 한다. 2.x는 default임
tf.enable_eager_execution()
# 내 환경에서 하면,
# pip install -q tensorflow-datasets


# 데이터 셋 불러오기
# Downloading and preparing dataset imdb_reviews
# info 지금은 사용하지 않는다.
import tensorflow_datasets as tfds
imdb, info = tfds.load("imdb_reviews", with_info=True, as_supervised=True)


import numpy as np
# train과 test를 나눠서 25,000 25,000 으로 저장 한다.
train_data, test_data = imdb['train'], imdb['test'] # 25,000 25,000


training_sentences = []
training_labels = []

testing_sentences = []
testing_labels = []

# str(s.tonumpy()) is needed in Python3 instead of just s.numpy()
# converting into other type
for s, l in train_data: ## iterate data
    training_sentences.append(str(s.numpy()))
    training_labels.append(l.numpy())

for s, l in test_data: ## iterate data
    testing_sentences.append(str(s.numpy()))
    testing_labels.append(l.numpy())

training_labels_final = np.array(training_labels) # 타입을 통일시킨다.
testing_labels_final = np.array(testing_labels)

'''''''''''''''''''tokeninzing sentences
vocab_size = 10000
embedding_dim = 16
max_length = 120
trunc_type='post'
oov_tok = "<OOV>"

from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

tokenizer = Tokenizer(num_words=vocab_size, oov_token=oov_tok)
tokenizer.fit_on_texts(training_sentences)
word_index = tokenizer.word_index

sequences = tokenizer.texts_to_sequences(training_sentences)
# padding sequences
padded = pad_sequences(sequences,maxlen=max_length, truncating=trunc_type)

# oov를 많이 보게 될 것
testing_sequences = tokenizer.texts_to_sequences(testing_sentences)
testing_padded = pad_sequences(testing_sequences,maxlen=max_length)
'''''''''''''''''''


# {hello:1} => {1:hello} 이런식으로 key와 value를 flip
reverse_word_index = dict([(value, key) for (key, value) in word_index.items()])

def decode_review(text):
    return ' '.join([reverse_word_index.get(i, '?') for i in text])

print(decode_review(padded[1]))
print(training_sentences[1])


model = tf.keras.Sequential([
    tf.keras.layers.Embedding(vocab_size, embedding_dim, input_length=max_length),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(6, activation='relu'),
    tf.keras.layers.Dense(1, activation='sigmoid')
])
model.compile(loss='binary_crossentropy',optimizer='adam',metrics=['accuracy'])
model.summary()

'''
Model: "sequential"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
embedding (Embedding)        (None, 120, 16)           160000    
_________________________________________________________________
flatten (Flatten)            (None, 1920)              0         
_________________________________________________________________
dense (Dense)                (None, 6)                 11526     
_________________________________________________________________
dense_1 (Dense)              (None, 1)                 7         
=================================================================
Total params: 171,533
Trainable params: 171,533
Non-trainable params: 0
_________________________________________________________________
'''


#
num_epochs = 10
model.fit(padded,
          training_labels_final,
          epochs=num_epochs,
          validation_data=(testing_padded,
                           testing_labels_final))
'''epoch 1번 전체 데이터 학습을 할때마다 acc가 높아진다.
25000/25000 [==============================] - 9s 344us/sample - loss: 0.4941 - acc: 0.7406 - val_loss: 0.3537 - val_acc: 0.8432
Epoch 2/100
25000/25000 [==============================] - 7s 279us/sample - loss: 0.2392 - acc: 0.9066 - val_loss: 0.3651 - val_acc: 0.8404
Epoch 3/100
25000/25000 [==============================] - 7s 285us/sample - loss: 0.0865 - acc: 0.9785 - val_loss: 0.4548 - val_acc: 0.8264
Epoch 4/100
'''
# acc가 1.000인데도 계속 학습하는 경우 overfitting이다.


e = model.layers[0]
weights = e.get_weights()[0]
print(weights.shape) # shape: (vocab_size, embedding_dim) (10000, 16)
# 10000개의 단어 16차원


# file 쓰기
import io
out_v = io.open('vecs.tsv', 'w', encoding='utf-8')
out_m = io.open('meta.tsv', 'w', encoding='utf-8')
for word_num in range(1, vocab_size):
  word = reverse_word_index[word_num]
  embeddings = weights[word_num]
  # words쓰기
  out_m.write(word + "\n")
  out_v.write('\t'.join([str(x) for x in embeddings]) + "\n")
out_v.close()
out_m.close()


try:
  from google.colab import files
except ImportError:
  pass
else:
  files.download('vecs.tsv')
  files.download('meta.tsv')


sentence = "I really think this is amazing. honest."
sequence = tokenizer.texts_to_sequences(sentence)
print(sequence)

```





## Diving into the code (part 1)

https://github.com/tensorflow/datasets/tree/master/docs

https://github.com/tensorflow/datasets/blob/d4e0e83a2c7b5ee8b807d036493ef0329e8f446e/docs/catalog/imdb_reviews.md















1번 쭉 듣고

다시 처음부터 듣기



## :key: Keys

vector(벡터) 

-  수의 순서쌍

- 방향이 있고 순서가 있고 차원의 공간에 존재하는 점

```python
import numpy as np
a = np.array([1, 2])
b = np.array([1, 2])
print (a + b)    #결과: array([2, 4])


## 백터와 스칼라(상수) 곱 연산
lista = np.array([1,2,3,4,5])
lista * 2
#결과는 array([2,4,6,8,10])

```



embedding

epoch

- *One Epoch is when an ENTIRE dataset is passed forward and backward through the neural network only ONCE*
- 한 번의 epoch는 인공 신경망에서 전체 데이터 셋에 대해 forward pass/backward pass 과정을 거친 것을 말함. 즉, 전체 데이터 셋에 대해 한 번 학습을 완료한 상태

- **epochs = 40이라면 전체 데이터를 40번 사용해서 학습을 거치는 것입니다.**





overfitting

weight





머신러닝 모델의 학습 방법은

1. 데이터를 탐색한 후 전처리하고
2. 데이터 변수 등을 분석하여 전체 훈련용, 테스트용 데이터 셋을 구성한 다음
3. 해결하고자 하는 문제에 맞는 알고리즘을 선택하여 모델을 만든 후
4. **훈련용 데이터 셋으로 모델을 학습**시키고
5. k-folds 교차검증 및 테스트용 데이터 셋 으로 모델 간 검증을 진행하고
6. 최고의 성능을 보이는 모델을 최종 배치한다.





참고문헌:

http://colah.github.io/posts/2014-07-NLP-RNNs-Representations/