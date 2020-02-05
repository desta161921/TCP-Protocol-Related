# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 14:35:03 2017

@author: deshag
"""
import xgboost
import sys
import pandas as pd
import math
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import GridSearchCV



#Load training and test data set from csv into panda
df_train=pd.read_csv('cubic_training_set.csv')
df_test=pd.read_csv('cubic_test_set.csv')

#Initial inspection of data 
print("Nr of obs training data: " + str(len(df_train)))
print("Nr of obs training data: " + str(len(df_test)))


#Check data types of both training and test data
print(df_train.dtypes)
print(df_test.dtypes)

#Get summary statisics of training data
print(df_train.describe(include='all'))


#Check if distribution is similar in test set, this is important to check if one is to attempt to generalize a model.
#If test set is significantly different from the training data it may not generalize well

print(df_test.describe(include='all'))



DTrain = xgboost.DMatrix(df_x_train, df_y_train)
param = {'max_depth':1, 'objective':'reg:linear','eta':0.1 }
cv=xgboost.cv(param, DTrain,num_boost_round=1000, early_stopping_rounds=500,nfold=150, metrics="rmse") 
min(cv["test-rmse-mean"])

#XGBoost
clf_lasso = xgboost.train()
params = {'max_depth':2, 'objective':'reg:linear','eta':0.1 }
clf = GridSearchCV(estimator=clf_lasso, param_grid=params, 
                          cv=5,
                           scoring='neg_mean_squared_error')
model = clf.fit(df_x_train, df_y_train)
math.sqrt(model.best_score_*-1)
model.grid_scores_
  
model=xgboost.train(param, DTrain,num_boost_round=324)

gbm = xgboost.XGBClassifier(objective='reg:linear')
gbm_params = {
    'learning_rate': [0.05, 0.1],
    'n_estimators': [300, 1000],
    'max_depth': [2, 3, 10],
    'objective':['reg:linear']
}
grid = GridSearchCV(gbm, gbm_params,scoring='neg_mean_squared_error',n_jobs=-1)
grid.fit(df_x_train, df_y_train)

#Write to csv
pd.Series(model.predict(xgboost.DMatrix(df_x_test))).to_csv('predictions.csv')

