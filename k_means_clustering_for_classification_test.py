#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 23 15:10:41 2019

@author: deshag
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.cluster import completeness_score

protocols = {}

types = {"TCP Vegas": "vegas.csv", "TCP Veno": "veno.csv", "TCP Cubic": "cubic.csv", "TCP Reno": "reno.csv"}



for protname, fname in types.items():
    col_time,col_window = np.loadtxt(fname,delimiter=',').T
    trailing_window = col_window[:-1] # "past" values at a given index
    leading_window  = col_window[1:]  # "current values at a given index
    decreasing_inds = np.where(leading_window < trailing_window)[0]
    beta_value = leading_window[decreasing_inds]/trailing_window[decreasing_inds]
    delay = col_time[decreasing_inds]
     
    protocols[protname] = {
        "col_time": col_time,
        "col_window": col_window,
        "delay": delay,
        "beta_value": beta_value,
    }

   
    plt.figure(); plt.clf()
    plt.plot(delay,beta_value, ".", label=protname, color="blue")
    plt.ylim(0, 1.0001)
    plt.title(protname)
    plt.xlabel("Diff")
    plt.ylabel("quotient")
    plt.legend()
    plt.show()
    


### KMeans
k_means = KMeans(algorithm='auto', copy_x=True, init='k-means++', max_iter=300,
    n_clusters=4, n_init=10, n_jobs=None, precompute_distances='auto',
    random_state=0, tol=0.0001, verbose=0)

quotient_2d = beta_value.reshape(-1,1)
k_means.fit(quotient_2d)

print(k_means.labels_)

### Plot the centroids
colors = ['r','g','b']

Z = k_means.predict(quotient_2d)

##Plot each class as a separate colour
n_clusters = 4 
for n in range(n_clusters):
    # Filter data points to plot each in turn.
    ys = beta_value[ Z==n ]
    xs = delay[ Z==n ]

    plt.scatter(xs, ys, color=colors[n])

plt.title("Points by cluster")
