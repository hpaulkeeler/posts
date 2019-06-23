#Simulate a Poisson point process on a disk.
#Author: H. Paul Keeler, 2018.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting

#Simulation window parameters
r=1;  #radius of disk
xx0=0; yy0=0; #centre of disk
areaTotal=np.pi*r**2; #area of disk

#Point process parameters
lambda0=100; #intensity (ie mean density) of the Poisson process

#Simulate Poisson point process
numbPoints = np.random.poisson(lambda0*areaTotal);#Poisson number of points
theta=2*np.pi*np.random.uniform(0,1,numbPoints); #angular coordinates 
rho=r*np.sqrt(np.random.uniform(0,1,numbPoints)); #radial coordinates 

#Convert from polar to Cartesian coordinates
xx = rho * np.cos(theta);
yy = rho * np.sin(theta);

#Shift centre of disk to (xx0,yy0) 
xx=xx+xx0; yy=yy+yy0;

#Plotting
plt.scatter(xx,yy, edgecolor='b', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");
plt.axis('equal');
