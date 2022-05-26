# Simulate a (homogeneous) Poisson stochastic process.
#
# Author: H. Paul Keeler, 2021.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
#

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting

#np.random.seed(2); #set random seed

###START Paramters START###
#Poisson stochastic process parameters
lambda0=6;

#time parameters
tFirst=0; #first time value
tLast=1; #last time value
numb_t=10**3; #number of time points

numbPaths=1; #number of sample paths (ie realizations)
###END Paramters END###

###START Create Poisson stochastic processes START###
tLength=tLast-tFirst; #length of segment
numbPoiss=np.random.poisson(lambda0*tLength);
tPoissJump=tFirst+tLength*np.random.uniform(0, 1, numbPoiss);

tPoissJump=np.sort(tPoissJump);
#process values
xPoiss0=np.arange(numbPoiss+1);
xPoiss=xPoiss0[1:numbPoiss+1];

tPoissJump0=np.append(tFirst,tPoissJump); #append last value
tPoissJump1=np.append(tPoissJump,tLast); #append last value

###END Create Poisson stochastic processes END###

###START Plotting START###
fig = plt.figure();
#draw jumps of Poisson process
plt.plot(tPoissJump0,xPoiss0, 'b.',markersize=10);
plt.grid(visible=True);
plt.title("Poisson stochastic process");
plt.xlabel("T");
plt.ylabel("S");

#draw additional blue lines
tFistTemp=tFirst;
tLastTemp=tPoissJump[0];
for jj in range(numbPoiss+1):
    tTemp=np.array([tFistTemp, tLastTemp]);
    xTemp=np.array([xPoiss0[jj],xPoiss0[jj]]);
    plt.plot(tTemp,xTemp,'b-');
    
    #don't update on the last loop
    if jj<numbPoiss:
        tFistTemp=tLastTemp;
        tLastTemp=tPoissJump1[jj+1];
    
# ##draw points of discontinuity
#plt.plot(tPoissJump,xPoiss-1, 'bo', fillstyle='none');
#draw Poisson point process corresponding to jumps
plt.plot(tPoissJump,np.zeros(np.size(tPoissJump)), 'r.', markersize=10);
###END Plotting END###
