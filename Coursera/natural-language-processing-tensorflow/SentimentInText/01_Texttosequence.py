import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.preprocessing.text import Tokenizer


test_data = [
    'i really love my dog',
    'my dog loves my manatee dsfnjks',
]

tokenizer = Tokenizer(num_words = 100)
tokenizer.fit_on_texts(test_data)
word_index = tokenizer.word_index

test_seq = tokenizer.texts_to_sequences(test_data)

print(word_index)
print(test_seq)