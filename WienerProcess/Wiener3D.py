# Simulate a 3-D Wiener (or Brownian motion) process, where each vector 
# vector component of the stochastic process is an independent Wiener process.
#
# Author: H. Paul Keeler, 2021.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# 

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from numpy import linalg as la #linear algebra pack for norms
from mpl_toolkits import mplot3d

plt.close('all');  # close all figures


###START Paramters START###
#Brownian/Wiener process parameters
mu=0; #drift coefficient; mu=0 for a standard Brownian/Winer process
sigma=1; #standard deviation; sigma=1 for a standard Brownian/Winer process

#time parameters
tMin=0; #first time value
tMax=1; #last time value
numb_t=10**3; #number of time points

numbPaths=1; #number of sample paths (ie realizations)
###END Paramters END###

#create time values
tValues=(np.linspace(0,tMax,numb_t)); #time vector
tDelta=tValues[1]-tValues[0]; #step size

###START Create Brownian/Wiener processes START###
#First Brownian/Wiener process
xWienerSteps=mu*tDelta+sigma*np.sqrt(tDelta) \
*np.random.normal(0,1,size=(numb_t,1)); #normally distributed steps
xWiener=np.cumsum(xWienerSteps); #find Wiener/Brownian process values
xWiener=xWiener-xWiener[0]; #set initial value to zero 

#Second Brownian/Wiener process
yWienerSteps=mu*tDelta+sigma*np.sqrt(tDelta) \
*np.random.normal(0,1,size=(numb_t,1)); #normally distributed steps
yWiener=np.cumsum(yWienerSteps); #find Wiener/Brownian process values
yWiener=yWiener-yWiener[0]; #set initial value to zero 
###END Create Brownian/Wiener processes END###

###START Plotting START###
fig = plt.figure();
ax = plt.axes(projection='3d')
ax.plot3D(tValues,xWiener,yWiener);
plt.title("Three-dimensional Wiener (or Brownian motion) process");
plt.xlabel("x");
plt.ylabel("y");

###END Plotting END###
