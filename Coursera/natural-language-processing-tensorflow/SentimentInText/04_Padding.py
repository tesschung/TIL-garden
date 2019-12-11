import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

sentences = [
    'I love my dog',
    'I love my cat',
    'you love my dog!',
    'Do you think my dog is amazing?',
    'I really love my dog',
    'my dog loves my manatee',
]

tokenizer = Tokenizer(num_words = 100, oov_token = "<OOV>") # <OOV> 라는 단어를 outofindex화 하려고한다.
tokenizer.fit_on_texts(sentences)
word_index = tokenizer.word_index
print(word_index)

sequences = tokenizer.texts_to_sequences(sentences)
print(sequences)

padded = pad_sequences(sequences, padding = 'post', truncating='post', maxlen=10)
print(padded)

