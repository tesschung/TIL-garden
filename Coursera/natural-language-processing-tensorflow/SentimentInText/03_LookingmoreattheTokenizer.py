import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.preprocessing.text import Tokenizer

sentences = [
    'I love my dog',
    'I love my cat',
    'you love my dog!',
    'Do you think my dog is amazing?',
]

tokenizer = Tokenizer(num_words = 100, oov_token = "<OOV>") # <OOV> 라는 단어를 outofindex화 하려고한다.
tokenizer.fit_on_texts(sentences)
word_index = tokenizer.word_index

sequences = tokenizer.texts_to_sequences(sentences)




test_data = [
    'i really love my dog',
    'my dog loves my manatee',
]

test_seq = tokenizer.texts_to_sequences(test_data)
print(word_index)
print(test_seq)
print(sequences)