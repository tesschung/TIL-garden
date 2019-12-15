# pip install tensorflow==2.0.0-alpha0
import tensorflow as tf # 가장 처음 선언
print(tf.__version__)

import tensorflow_datasets as tfds
imdb, info = tfds.load('imdb_reviews/subwords8k', with_info=True, as_supervised=True)

train_data, test_data = imdb['train'], imdb['test']

tokenizer = info.features['text'].encorder