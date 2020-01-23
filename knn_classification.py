#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Feb  3 23:09:08 2019

@author: deshag
"""

import numpy as np
from numpy import genfromtxt
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt



#protocols = {}
types = {
        "TCP Vegas": ["vegas_sender.csv", "vegas_monitor.csv"], 
        "TCP Veno": ["veno_sender.csv", "veno_monitor.csv"], 
        "TCP CUBIC": ["cubic_sender.csv", "cubic_monitor.csv"], 
        "TCP Reno": ["reno_sender.csv", "reno_monitor.csv"]
        }

dataset = None
ground_truth = None

for idx, csv_list in types.items():
    for csv_f in csv_list:
    
        col_time,col_window = np.loadtxt(csv_f,delimiter=',').T
        trailing_window = col_window[:-1] # "past" cwnd values at a given index
        leading_window  = col_window[1:]  # "current cwnd values at a given index
        decreasing_inds = np.where(leading_window < trailing_window)[0]
        beta_value = leading_window[decreasing_inds]/trailing_window[decreasing_inds]
        quotient_times = col_time[decreasing_inds]
        baseRTT=min(col_time[decreasing_inds])
        expected=col_window/baseRTT
        actual=col_window/col_time
        diff=expected - actual
        
        my_data = genfromtxt(csv_f, delimiter=',')
        diff=quotient_times
        my_data = my_data[:,1]
        my_data = my_data[:int(my_data.shape[0]-my_data.shape[0]%200)].reshape(-1, 200)
        labels = np.full(1, idx)
      
        if dataset is None:
            dataset = beta_value.reshape(1,-1)[:,:15]
        else:
            dataset = np.concatenate((dataset,beta_value.reshape(1,-1)[:,:15]))
        
        if ground_truth is None:
            ground_truth = labels
        else:
            ground_truth = np.concatenate((ground_truth,labels))
    

    
X_train, X_test, y_train, y_test = train_test_split(dataset, ground_truth, test_size=0.25, random_state=42)

# TRAINING
knn_classifier = KNeighborsClassifier(n_neighbors=3, weights='distance', algorithm='auto', leaf_size=300, p=2, metric='minkowski')
knn_classifier.fit(X_train, y_train)

## TESTING
print("***********==============***********")

## Print the accuracy

print("Accuracy before PCA:",(knn_classifier.score(X_test, y_test)))  

print("***********==============***********")

## PCA - Principal component analysis
#print("PCA....")

pca = PCA(n_components=2,svd_solver='full') 
pca_result = pca.fit_transform(X_train)




pca = PCA(n_components=2)
X_train_pca = pca.fit_transform(X_train)
X_test_pca = pca.fit_transform(X_test)

X_train_pca, X_test_pca, y_train_pca, y_test_pca = train_test_split(pca.fit_transform(dataset), ground_truth, test_size=0.25, random_state=42)


plot_data=dataset.transpose()
#plt.plot(plot_data)

#plt.plot(diff[:15], plot_data)


for i, key in enumerate(types.keys()):
    plt.plot(diff[:15], plot_data[:, 2*i], label=key)
    #plt.plot(plot_data[:, 2*i+1], label=key)
    plt.xlabel("$Estimated \ Diff$")
    plt.ylabel("$Estimated \ Beta \ Values$")
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.13), shadow=True, ncol=4, frameon=False)
    plt.savefig('knn2.svg', format='svg')
