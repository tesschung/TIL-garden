import json # json 불러오기
'''
{'is_sarcastic': 1, 'headline': 'life-saving drug more accessible to lab rat than majority of americans', 'article_link': 'https://www.theonion.com/life-saving-drug-more-accessible-to-lab-rat-than-majori-1819578282'}, 
'''

datastore = []
for line in open("Sarcasm-Dataset.json", 'r'):
    datastore.append(json.loads(line))

sentences = []
labels = []
urls = []
for item in datastore:
    sentences.append(item['headline'])
    labels.append(item['is_sarcastic'])
    urls.append(item['article_link'])
print(sentences)
print(labels)
print(urls)

from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

# 딕셔너리 생성
tokenizer = Tokenizer(oov_token='<OOV>')
tokenizer.fit_on_texts(sentences)
word_index = tokenizer.word_index
print(len(word_index))
# print(word_index)


# sequence 생성
sequences = tokenizer.texts_to_sequences(sentences)

# padding 생성
padded = pad_sequences(sequences, padding='post')
print(sentences[2])
print(padded[2])
print(padded.shape)



