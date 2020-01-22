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
n_features=1000
#%reset


df = pd.read_csv('cubic.csv')

for i in range(0,n_features):
    df['X_t'+str(i)] = df['X'].shift(i) 
    df['X_tp'+str(i)] = (df['X'].shift(i) - df['X'].shift(i+1))/(df['X'].shift(i))

print(df)
pd.set_option('use_inf_as_null', True)


#df.replace([np.inf, -np.inf], np.nan).dropna(axis=1)

df.dropna(inplace=True)


#X = (pd.DataFrame({ 'X_%d'%i : df['X'].shift(i) for i in range(n_features)}).apply(np.nan_to_num, axis=0).values)
                  
X = df.drop('Y', axis=1)
y = df['Y']


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.40)

X_train = X_train.drop('time', axis=1)
X_train = X_train.drop('X_t1', axis=1)
X_train = X_train.drop('X_t2', axis=1)
X_test = X_test.drop('time', axis=1)
X_test = X_test.drop('X_t1', axis=1)
X_test = X_test.drop('X_t2', axis=1)



print(X.shape)
print(df['Y'].shape)

print()
print("Size of X_train:",(len(X_train)))
print("Size of Y_train:",(len(y_train)))
print("Size of X_test:",(len(X_test)))
print("Size of Y_test:",(len(y_test)))

#Lasso CV
clf_lasso = LassoCV()
params = {'tol':[0.001, 0.01, 0.1], 'n_alphas':[10,100], 'max_iter':[1000]}
clf = GridSearchCV(estimator=clf_lasso, param_grid=params, 
                          cv=5,
                           scoring='neg_mean_squared_error', n_jobs=-1)
model = clf.fit(X_train, y_train)
math.sqrt(model.best_score_*-1)
model.grid_scores_

print(model.grid_scores_)

#####
print()
print(model.grid_scores_)
print("The best score: ",model.best_score_)

print("RMSE:",math.sqrt(model.best_score_*-1))

#reg = RandomForestRegressor(criterion='mse')
clf_lasso.fit(X_train,y_train)
modelPrediction = clf_lasso.predict(X_test)
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

modelPred_test = clf_lasso.predict(X_test)
ax.plot(pd.Series(index_values), y_test.values)

standard_deviation=int(round(np.std(modelPred_test))*3)

smoothed=pd.rolling_mean(modelPred_test, standard_deviation, min_periods=standard_deviation, freq=None, center=False, how=None)
PlotInOne=pd.DataFrame(pd.concat([pd.Series(smoothed), pd.Series(y_test.values)], axis=1))



plt.figure(); PlotInOne.plot(); plt.legend(loc='best')


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