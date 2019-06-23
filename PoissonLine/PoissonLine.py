# Simulate a uniform Poisson line process on a disk. 
# Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting
from matplotlib import collections  as mc #for plotting line segments

plt.close("all"); # close all figures

###START Parameters START###
#Poisson line process parameters
lambda0=4; #intensity (ie mean density) of the Poisson line process

#Simulation disk dimensions
xx0=0; yy0=0; #center of disk
r=1; #disk radius
massLine=2*np.pi*r*lambda0;  #total measure/mass of the line process
###END Parameters END###

###START Simulate a Poisson line process on a disk START###
#Simulate Poisson point process
numbLines=np.random.poisson(massLine);#Poisson number of points

theta=2*np.pi*np.random.rand(numbLines); #choose angular component uniformly
p=r*np.random.rand(numbLines); #choose radial component uniformly
q=np.sqrt(r**2-p**2); #distance to circle edge (alonge line)

#calculate trig values
sin_theta=np.sin(theta);
cos_theta=np.cos(theta);

#calculate segment endpoints of Poisson line process
xx1=xx0+p*cos_theta+q*sin_theta; 
yy1=yy0+p*sin_theta-q*cos_theta;
xx2=xx0+p*cos_theta-q*sin_theta;
yy2=yy0+p*sin_theta+q*cos_theta;
###END Simulate a Poisson line process on a disk END###

### START Plotting ###START
#draw circle
t=np.linspace(0,2*np.pi,200);
xp=r*np.cos(t); yp=r*np.sin(t);
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp,color='k');
plt.xlabel('x'); plt.ylabel('y');
plt.axis('equal'); 

#plot segments of Poisson line process
#need to create a list to plot the segments (probably a better way to do this)
segments=[]; #initiate list
segments=[[(xx1[i],yy1[i]),(xx2[i],yy2[i])] for i in range(numbLines)];   
lc = mc.LineCollection(segments,colors='b');
ax.add_collection(lc) #plot segments
###END Plotting END###
