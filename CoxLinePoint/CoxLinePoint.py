# Simulate a Cox point process on a disk. 
# This Cox point process is formed by first simulating a uniform Poisson 
# line process. On each line (or segment) an independent Poisson point 
# process is then simulated.
# Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting
from matplotlib import collections  as mc #for plotting line segments

plt.close("all"); # close all figures

###START -- Parameters -- START###
#Cox (ie Poisson line-point) process parameters
lambda0=1; #intensity (ie mean density) of the Poisson *line* process
mu=5; #intensity (ie mean density) of the Poisson *point* process

#Simulation disk dimensions
xx0=0; yy0=0; #center of disk
r=1; #disk radius
massLine=2*np.pi*r*lambda0;    
###END -- Parameters -- END###

###START -- Simulate a Poisson line process on a disk -- START###
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

###START Simulate a Poisson point processes on each line START###
lengthLine=2*q; #length of each segment
massPoint=mu*lengthLine;#mass on each line
numbLinePoints=np.random.poisson(massPoint); #Poisson number of points on each line
numbLinePointsTotal=sum(numbLinePoints);
uu=2*np.random.rand(numbLinePointsTotal)-1; #uniform variables on (-1,1)

#replicate values to simulate points all in one step
xx0_all=np.repeat(xx0,numbLinePointsTotal);
yy0_all=np.repeat(yy0,numbLinePointsTotal);
p_all=np.repeat(p,numbLinePoints);
q_all=np.repeat(q,numbLinePoints);
sin_theta_all=np.repeat(sin_theta,numbLinePoints);
cos_theta_all=np.repeat(cos_theta,numbLinePoints);

#position points on Poisson lines/segments
xxPP_all=xx0_all+p_all*cos_theta_all+q_all*uu*sin_theta_all;
yyPP_all=yy0_all+p_all*sin_theta_all-q_all*uu*cos_theta_all;
### END Simulate a Poisson point processes on each line ###END

### START Plotting ###START
#plot circle
t=np.linspace(0,2*np.pi,200);
xp=r*np.cos(t); yp=r*np.sin(t);
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp,color='k');
plt.xlabel('x'); plt.ylabel('y');
plt.axis('equal');

#plot segments of Poisson line process
#need to create a list to plot the segments (probably a better way to do this)
segments=[[(xx1[i],yy1[i]),(xx2[i],yy2[i])] for i in range(numbLines)];
lc = mc.LineCollection(segments,colors='b')
ax.add_collection(lc) #plot segments


#plot Poisson points on line process
plt.plot(xxPP_all,yyPP_all,'r.');
###END Plotting END###

