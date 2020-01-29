#!/usr/bin/env python3

# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 13:18:39 2017

@author: deshag
"""


import sys
import imp
import glob
import os
import pandas as pd
import math
from sklearn.feature_extraction.text import CountVectorizer 
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import matplotlib
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt
import numpy as np
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import GridSearchCV
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LassoCV
from sklearn.metrics import r2_score, mean_squared_error, make_scorer
from sklearn.model_selection import train_test_split
from math import sqrt
from sklearn.cross_validation import train_test_split
import time
import scipy.signal as sps

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 

start_time = time.time()
n_features=3000


### Concatenation - 
#df = pd.concat(map(pd.read_csv, glob.glob(os.path.join('', "cubic*.csv"))), ignore_index=True)
df = pd.read_csv('cubic.csv')

for i in range(1,n_features):
    df['X_t'+str(i)] = df['X'].shift(i)

print(df)

df.dropna(inplace=True)

#X = (pd.DataFrame({ 'X_%d'%i : df['X'].shift(i) for i in range(n_features)}).apply(np.nan_to_num, axis=0).values)
                  
X = df.drop('Y', axis=1)
y = df['Y']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.40)

X_train = X_train.drop('time', axis=1)
X_test = X_test.drop('time', axis=1)


print(X.shape)
print(df['Y'].shape)

print()
print("Size of X_train:",(len(X_train)))
print("Size of Y_train:",(len(X_train)))
print("Size of X_test:",(len(X_test)))
print("Size of Y_test:",(len(y_test)))

print()


#Fit models with some grid search CV=5 (not to low), use the best model

parameters = {'n_estimators': [10,30,100,500,1000], 'max_features':["sqrt"], 'max_depth':[10], 'oob_score': [True]}
clf_rf = RandomForestRegressor(random_state=1)
clf = GridSearchCV(clf_rf, parameters, cv=5, scoring='neg_mean_squared_error', n_jobs=-1)
model = clf.fit(X_train, y_train)
model.cv_results_['params'][model.best_index_]
math.sqrt(model.best_score_*-1)
model.grid_scores_

#####
print()
print(model.grid_scores_)
print("The best score: ",model.best_score_)

print("RMSE:",math.sqrt(model.best_score_*-1))

#reg = RandomForestRegressor(criterion='mse')
clf_rf.fit(X_train,y_train)
modelPrediction = clf_rf.predict(X_test)
print(modelPrediction)

print("Number of predictions:",len(modelPrediction))

meanSquaredError=mean_squared_error(y_test, modelPrediction)
print("Mean Square Error (MSE):", meanSquaredError)
rootMeanSquaredError = sqrt(meanSquaredError)
print("Root-Mean-Square Error (RMSE):", rootMeanSquaredError)



fig, ax = plt.subplots()
index_values=range(0,len(y_test))

y_test.sort_index(inplace=True)
X_test.sort_index(inplace=True)

modelPred_test = clf_rf.predict(X_test)
ax.plot(pd.Series(index_values), y_test.values)
modelPred_test.tofile(file_Name,sep="\n",format="%s")


smoothed = np.convolve(modelPred_test, np.ones(10)/10)
#modelPred_test = sps.filtfilt(np.ones(10), 10, modelPred_test)
PlotInOne=pd.DataFrame(pd.concat([pd.Series(smoothed), pd.Series(y_test.values)], axis=1))

plt.figure(); PlotInOne.plot(); plt.legend(loc='best')

plt.show()
# MAPE - measure of prediction accuracy - expresses accuracy as a percentage

def calculate_mape(y_test, modelPrediction): 
    mask = y_test != 0
    return (np.fabs(y_test[mask] - modelPrediction[mask])/y_test[mask]).mean()
MAPE=(calculate_mape(y_test, modelPrediction)*100)
print("Mean Absolute Percentage Error (MAPE):%.2f%%"% MAPE)

print()


end_time = time.time()
elapsed_time = end_time-start_time

print("Elapsed Time (Seconds):", elapsed_time)
hours = elapsed_time//3600
elapsed_time = elapsed_time - 3600*hours
minutes = elapsed_time//60
seconds = elapsed_time - 60*minutes

print("=========================================")
print("Time Elapsed (Hours:Minutes:Seconds):",'%d:%d:%d' %(hours,minutes,seconds))

print("=========================================")

