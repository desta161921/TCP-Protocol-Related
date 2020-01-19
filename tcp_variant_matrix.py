# /usr/bin/python -tt

from __future__ import division
import csv
import os
import pandas as pd
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
import numpy as np

#----------------------------------------------------------------------------
def get_tcp_variant(filepath):
    def tcp_congestion_variant(beta):
        print('predict({}; abs({})'.format(beta, abs(beta)))
        if (beta>0.61 and beta<=0.75):
            return "Cubic"
        if (beta>=0.45 and beta<0.61):
            return "Reno"
        if (beta>0.75 and beta<=0.99):
            return "BIC"

        return "The TCP Variant can not be characterized"
#----------------------------------------------------------------------------

    with open(filepath, "r") as csvfile:
        ff = csv.reader(csvfile)

        beta_values = []
        cwnd_loss = 0
        for current_cwnd, col2 in ff:
            value = int(current_cwnd)
            if value >= cwnd_loss:
                cwnd_loss = value
            else:
                beta_value = int(current_cwnd)/cwnd_loss
                beta_value=(round(beta_value,2))
                beta_values.append(beta_value)
                cwnd_loss = value

    return tcp_congestion_variant(sum(beta_values)/len(beta_values))

print()
print ("*********************************************")
print ("Confusion matrix ")
print ("*********************************************")
matrix = {'actual':[], 'predict':[]}
path = './csv_files'

#----------------------------------------------------------------------------
def get_variant_predict(filename):
    if 'cubic' in filename:
        return 'Cubic'
    if 'reno' in filename:
        return "Reno"
    if 'bic' in filename:
        return "BIC"
    else:
        return filename [0]
#----------------------------------------------------------------------------

for filename in os.listdir(path):
    #matrix['predict'].append(filename[:4])
    matrix['predict'].append(get_variant_predict(filename))
    matrix['actual'].append(get_tcp_variant(os.path.join(path, filename)))

data_frame = pd.crosstab(pd.Series(matrix['actual'], name='Actual'),
                 pd.Series(matrix['predict'], name='    Predicted'))
                 #,margins=True) # To add "All"
print (" ")

print(data_frame)

print(classification_report(matrix['actual'], 
                            matrix['predict'], 
                            target_names=['BIC', 'Cubic', 'Reno']))



print("Accuracy:",(data_frame * np.eye(3)).values.sum() / data_frame.values.sum())


