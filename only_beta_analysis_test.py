#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 15 09:36:09 2019

@author: deshag
"""

import numpy as np
import pandas as pd
import csv
import numpy as np
import scipy.stats
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import norm
from statsmodels.graphics.tsaplots import plot_acf, acf

#plt.rcParams["figure.figsize"] = (14, 10)

protocols = {}


types = {"TCP Vegas": "vegas.csv", "TCP Veno": "veno.csv", "TCP CDG": "cdg.csv"}

for protname, fname in types.items():
    col_time = []  # time-stamp 
    col_window = []  # data (cwnd)
    with open(fname, mode='r', encoding='utf-8-sig') as f:
        reader = csv.reader(f, delimiter=",")
        for i in reader:
            col_time.append(float(i[0]))
            col_window.append(int(i[1]))
    col_time, col_window = np.array(col_time), np.array(col_window)
    diff_time = np.diff(col_time)
    diff_window = np.diff(col_window)
    diff_time = diff_time[diff_window > 0] 
    diff_window = diff_window[diff_window > 0] # To keep only the increased values
    protocols[protname] = {
        "col_time": col_time,
        "col_window": col_window,
        "diff_time": diff_time,
        "diff_window": diff_window,
    }

# plot the original data
for protname, values in protocols.items():
    plt.plot(values["col_window"], label=protname)
    plt.legend()
    plt.show()

## plot histogram of each TCP protocol with original data
for protname, values in protocols.items():
    plt.hist(np.diff(values["col_window"], 1), label=protname, alpha=0.5, bins=100)
    plt.legend()
    plt.show()


## compare the histograms of each TCP Protocol
for protname, values in protocols.items():
    d, l = np.histogram(values["col_window"][-20000:], bins=100) #d = dropout, -20000 ignore the first 20000 data points
    d[l[1:] > 16] = 0
    #plt.plot(l[1:], d, "-", label=protname, alpha=0.5)
    plt.bar(l[1:], d,  label=protname, alpha=0.5)
    plt.legend()
    plt.show()


## plot the patterns of each protocol
for protname, values in protocols.items():
    d = values["col_window"][-200:]
    plt.plot(d,  label=protname, alpha=0.5)
    plt.legend()
    plt.show()
    
### Distribution plots
for protname, values in protocols.items():
    d = values["col_window"]#[-20000:]
    w = 50
    d = np.array([d[i: i + w].max() for i in range(0, d.shape[0] - w, w)])
    d = np.diff(d, 3)  ## 3rd order differential 
    #plt.plot(d, ".", label=protname, alpha=1)
    plt.hist(d, label=protname)
    plt.legend()
    plt.show()

## delta time, delata delay and delta increase (decrease)
for protname, values in protocols.items():
    d = values["col_window"]#[-2000:]
    t = values["col_time"]#[-2000:]
    #d = d[1:]
    d = np.diff(d, 1) #/ d[:-1]
    t = np.diff(t, 1)
    plt.plot(t, d, ".", label=protname, alpha=0.5) #plot both alphas and betas
    plt.xlabel("Delay")
    plt.ylabel("Bacoff Factors")
    plt.legend()
    plt.show()
    
# To plot only the Number of Betas
for protname, values in protocols.items():
    d = values["col_window"]#[-2000:]
    t = values["col_time"]#[-2000:]
    d = np.diff(d, 1) #/ d[:-1]
    t = np.diff(t, 1)
    plt.plot(t[d < 0], abs(d[d < 0]), ".", label=protname, alpha=0.5)
    #plt.hlines(np.mean(d), np.min(t), np.max(t))
    plt.xlabel("Delay")
    plt.ylabel("Backoff Factors")
    plt.legend()
    plt.show()

# Plot the exact beta values
rt = np.exp(np.diff(np.log(col_window)))

for protname, fname in types.items():
    col_time, col_window = protocols[protname]["col_time"], protocols[protname]["col_window"]
    rt = np.exp(np.diff(np.log(col_window)))
    plt.plot(np.diff(col_time), rt, ".", markersize=4, label=protname, alpha=0.1)
    plt.ylim(0, 1.0001)
    plt.xlim(0, 0.003)
    plt.title(protname)
    plt.xlabel("Delay")
    plt.ylabel("Backoff Factor")
    plt.legend()
    plt.show()

## Mean, std, maximum and minimum of each protocol
for protname, values in protocols.items():
    print(protname, "\n".join("%s: %.3f" %(v, v(values["diff_window"])) for v in (np.mean, np.std, np.max, np.min)))
    