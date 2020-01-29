#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 14:35:03 2017

@author: deshag
"""
import sys
import imp
import pandas as pd
import numpy as np
import glob
import os    
import math
from sklearn.feature_extraction.text import CountVectorizer 
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import GridSearchCV
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LassoCV
from sklearn.metrics import r2_score, mean_squared_error, make_scorer
from sklearn.model_selection import train_test_split
from math import sqrt
import time


import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 

start_time = time.time()
#%reset


df = pd.read_csv('tcp_reno.csv')
n_features=3000
for i in range(1,n_features):
    df['X_t'+str(i)] = df['X'].shift(i)

print(df)

df.dropna(inplace=True)


                  
X = df.drop('Y', axis=1)
y = df['Y']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.50)

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

#Gradient boosting
clf_xgb = GradientBoostingRegressor()
params = {'n_estimators': [10,100,300, 500], 'max_depth': [1,2,3,5],'learning_rate': [0.1, 0.5]}
clf = GridSearchCV(estimator=clf_xgb, param_grid=params, 
                          cv=3,
                           scoring='neg_mean_squared_error')
model = clf.fit(X_train, y_train)
math.sqrt(model.best_score_*-1)
model.grid_scores_

#####
print()
print(model.grid_scores_)
print("The best score: ",model.best_score_)

print("RMSE:",math.sqrt(model.best_score_*-1))


clf_xgb.fit(X_train,y_train)
modelPrediction = clf_xgb.predict(X_test)
print(modelPrediction)

print("Number of predictions:",len(modelPrediction))

meanSquaredError=mean_squared_error(y_test, modelPrediction)
print("Mean Square Error (MSE):", meanSquaredError)
rootMeanSquaredError = sqrt(meanSquaredError)
print("Root-Mean-Square Error (RMSE):", rootMeanSquaredError)


####### to add the trendline
fig, ax = plt.subplots()
#df.plot(x='time', y='Y', ax=ax)
ax.plot(df['time'].values, df['Y'].values)


fig, ax = plt.subplots()
index_values=range(0,len(y_test))

y_test.sort_index(inplace=True)
X_test.sort_index(inplace=True)

modelPred_test = clf_xgb.predict(X_test)
ax.plot(pd.Series(index_values), y_test.values)


PlotInOne=pd.DataFrame(pd.concat([pd.Series(modelPred_test), pd.Series(y_test.values)], axis=1))

plt.figure(); PlotInOne.plot(); plt.legend(loc='best')


end_time = time.time()
elapsed_time = end_time-start_time

print("Elapsed Time:", elapsed_time ,"Seconds")
hours = elapsed_time//3600
elapsed_time = elapsed_time - 3600*hours
minutes = elapsed_time//60
seconds = elapsed_time - 60*minutes
print('%d:%d:%d' %(hours,minutes,seconds))