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






