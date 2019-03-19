#Simulate a binomial point process on a unit square
#Author: H. Paul Keeler, 2018

import numpy as np
import matplotlib.pyplot as plt

numbPoints=10; #number of points

#Simulate binomial point process
xx = np.random.uniform(0,1,numbPoints)#x coordinates of binomial points
yy = np.random.uniform(0,1,numbPoints)#y coordinates of binomial points

#Plotting
plt.scatter(xx,yy, edgecolor='b', facecolor='none', alpha=0.5 )
plt.xlabel("x")
plt.ylabel("y")
