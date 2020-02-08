#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 20 16:07:24 2018

@author: deshag
"""

import numpy as np
from keras.models import Sequential
from keras.layers import LSTM, Dense
from sklearn.preprocessing import MinMaxScaler
from keras.regularizers import L1L2
from math import sqrt
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
import warnings
from sklearn.exceptions import DataConversionWarning
import pydot
from keras.utils.vis_utils import plot_model

warnings.filterwarnings(action='ignore', category=DataConversionWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning) 
warnings.simplefilter(action='ignore', category=FutureWarning)


# Fix random seed for reproducibility
np.random.seed(7)

# Load the dataset
df = pd.read_csv('cubic64.csv')
df.astype('float32')

# summarize first few rows
print(df.head())


iput_window = 1000


def create_sequences(data, window=iput_window, step=1, prediction_distance=15):
    x = []
    y = []

    for i in range(0, len(data) - window - prediction_distance, step):
        x.append(data[i:i + window])
        y.append(data[i + window + prediction_distance][1])

    x, y = np.asarray(x), np.asarray(y)

    return x, y

x = df.drop('Y', axis=1)
y = df['Y']

#x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.40)

# Scaling and normalize the data before splitting
scaler_x = MinMaxScaler(feature_range=(0.01, 0.99))
scaler_y = MinMaxScaler(feature_range=(0.01, 0.99))

scaled_x = scaler_x.fit_transform(df.loc[:, "X"].reshape([-1,1]))
scaled_y = scaler_y.fit_transform(df.loc[:, "Y"].reshape([-1,1]))
scaled_data = np.column_stack((scaled_x, scaled_y))

# Build sequences
x_sequence, y_sequence = create_sequences(scaled_data)

test_size = int(len(x_sequence) * 0.90)
valid_len = int(len(x_sequence) * 0.90)
train_end = len(x_sequence) - (test_size + valid_len)
x_train, y_train = x_sequence[:train_end], y_sequence[:train_end]
x_valid, y_valid = x_sequence[train_end:train_end + valid_len], y_sequence[train_end:train_end + valid_len]
x_test, y_test = x_sequence[train_end + valid_len:], y_sequence[train_end + valid_len:]


print(scaled_x.shape)
print(df['Y'].shape)

print()
print("*****************************************************")

print ("Number of training examples = " + str(x_train.shape[0]))
print ("Number of test examples = " + str(x_test.shape[0]))
print ("X_train shape: " + str(x_train.shape))
print ("Y_train shape: " + str(y_train.shape))
print ("X_test shape: " + str(x_test.shape))
print ("Y_test shape: " + str(y_test.shape))

print("*****************************************************")


print()
print("**************************")
print("Building a Stateful LSTM Neural Model ......")
input_dim = x_train.shape[1]
print("The number of Input Dimestions:" + str(input_dim))

print()

# Initialising the RNN

model = Sequential()


# Adding the input layerand the LSTM layer
# The network has a visible layer with 15 input - try with 15 hidden layers
# Hidden layer with 15 LSTM blocks (or neurons) 
model.add(LSTM(15, input_shape=(input_dim, 2)))

# Adding the output layer
model.add(Dense(1, activation='relu'))

# Compiling the RNN
model.compile(loss='mae', optimizer='adam')
#model.compile(loss='mse', optimizer='adam', metrics=['accuracy'])
model.fit(x_train, y_train, epochs=500, batch_size=250, shuffle=True)

# Make predictions
y_pred = model.predict(x_test)

# invert the predictions
y_pred = scaler_y.inverse_transform(y_pred)
y_test = scaler_y.inverse_transform(y_test)

plot_colors = ['#332288', '#3cb44b']

# Plot the results
pd.DataFrame({"Actual": y_test, "Predicted": np.squeeze(y_pred)}).plot(color=plot_colors)
plt.xlabel('Time [Index]')
plt.ylabel('CWND [Segments]')

scores = model.evaluate(x_train, y_train)
#print("\n%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))
#print("scores:", scores)
np.squeeze(y_pred).shape[0]

rmseScore = sqrt(mean_squared_error(y_test, y_pred))
print('RMSE Score: %.2f RMSE' % (rmseScore))

for layer in model.layers:
    g=layer.get_config()
    h=layer.get_weights()
    print (g)
    print (h)
    print("Length of the Weights:"+str(len(h)))


for e in zip(model.layers[0].trainable_weights, model.layers[0].get_weights()):
    print('Param %s:\n%s' % (e[0],e[1]))

# Print the details of the layer
model.summary()

# Plot the neural network model and save it to a file
plot_model(model, to_file='model_plot.png', show_shapes=True, show_layer_names=True)


