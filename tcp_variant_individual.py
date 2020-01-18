# /usr/bin/python -tt

from __future__ import division
import csv
import statistics
import os
from collections import Counter
#----------------------------------------------------------------------------
def tcp_congestion_variant(beta):
    if (beta>=0.60 and beta<=0.75):
        return "CUBIC TCP variant"

    if (beta>=0.45 and beta<0.60):
        return "RENO TCP Variant"

    if (beta>0.75 and beta <=0.99):
        return "BIC TCP Variant"

    return "The TCP variant can not be characterized"
#----------------------------------------------------------------------------

with open("cubic42_estimated.csv", "r") as csvfile:
    ff = csv.reader(csvfile)

    beta_values = []
    cwnd_loss = 0
    for current_cwnd, col2 in ff:
        if not current_cwnd.isdigit():
            continue
        value = int(current_cwnd)
        if value >= cwnd_loss:
            cwnd_loss = value
            continue
        else:
            beta_value = int(current_cwnd)/cwnd_loss
            beta_value=(round(beta_value,2))
            beta_values.append(beta_value)
            # roundeBetaList = [round(element,2) for element in beta_values]
            cwnd_loss = value
    #print(beta_values)
    print ()
    print ("===============================================================")
    print ("Length of Beta Values:", (len(beta_values)))
    print ("Median of the Beta Values:%.2f"% (statistics.median(beta_values)))
    print ("Sum of Beta Values:%.2f"%(sum(beta_values)))
    print ("Average of Beta Values:%.2f"% (sum(beta_values)/len(beta_values)))
    print ("TCP Variant:", (tcp_congestion_variant(sum(beta_values)/len(beta_values))))
    print ("===============================================================")
