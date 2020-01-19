import numpy as np
import matplotlib.pyplot as plt

csv_files = ['actual_data.csv','estimated_data.csv']

#--------------------------------------------------
def load_data(fname):
    return np.genfromtxt(fname, delimiter=',')
#--------------------------------------------------

data = [load_data(name) for name in csv_files]
actual_data = data[0]
estimated_data = data[1]
interpolated_estimation = np.interp(estimated_data[:,0],actual_data[:,0],actual_data[:,1])

plt.figure()
plt.plot(actual_data[:,0],actual_data[:,1], label='actual')


plt.plot(estimated_data[:,0],interpolated_estimation, label='interpolated')

# Saves data to a file
np.savetxt('interpolated_data.csv',
       np.vstack((estimated_data[:,0],interpolated_estimation)).T,
       delimiter=',',fmt='%10.6f') 
plt.legend()
plt.title('Actual vs. Interpolated')

plt.xlim(0,10)
#plt.ylim(0,500)
plt.xlabel('Time [Seconds]')
plt.ylabel('cwnd[Segments]')

plt.grid()
plt.show(block=True)
