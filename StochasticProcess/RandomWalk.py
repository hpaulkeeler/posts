# Simulate a simple random walk 
#
# Author: H. Paul Keeler, 2021.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# https://hpaulkeeler.com/stochastic-processes/

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from numpy import linalg as la #linear algebra pack for norms

plt.close('all');  # close all figures

###START Parameters START###
#Random walk (or Bernoulli process) parameter
p=0.5; #probability of a +1 step

#discrete time parameters
tFirst=0; #first time value
tLast=15; #last time value
numb_t=tLast-tFirst+1; #number of time points
###END Paramters END###

#create time values
tValues=np.arange(tFirst,tLast+1,1); #time vector

###START Create Random walk START###
xBernoulli=(np.random.rand(numb_t)<p); #Boolean trials ie flip coins
xBernoulli=xBernoulli.astype(int); #convert to integers (ie 0 and 1)
xSteps=2*xBernoulli-1; #convert to -1/+1 steps
xSteps[0]=0; #start at zero
xWalk=np.cumsum(xSteps);

###END Create Random walk END###

###START Plotting START###
plt.plot(tValues,xWalk,'.',markersize=30);
plt.xlabel('T');
plt.ylabel('S');
plt.title('Random walk');
###END Plotting END###