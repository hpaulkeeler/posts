# Simulates a homogeneous Poisson point process on a circle.
# This code positions the points uniformly around a circle, which can be
# achieved by either using polar coordinates or normal random variables.
# Author: H. Paul Keeler, 2020.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# hpaulkeeler.com/simulating-a-poisson-point-process-on-a-circle/

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from numpy import linalg as la #linear algebra pack

plt.close('all');  # close all figures

r = 1;  # radius of circle

# centre of circle
xx0 = 0;
yy0 = 0;  

# Point process parameters
lambda0 = 10;  # intensity (ie mean density) of the Poisson process

lengthTotal=2*np.pi*r; #circumference of circle

# Simulate Poisson point process
numbPoints = np.random.poisson(lambda0 * lengthTotal);  # Poisson number of points

#METHOD 1 for positioning points: Use polar coodinates
theta = 2 * np.pi * np.random.uniform(0, 1, numbPoints);  # angular coordinates
rho = r ;  # radial coordinates

# Convert from polar to Cartesian coordinates
xx = rho * np.cos(theta);
yy = rho * np.sin(theta);

#METHOD 2 for positioning points: Use normal random variables
xxRand=np.random.normal(0,1,size=(numbPoints,2)); #generate two sets of normal variables
normRand=la.norm(xxRand,2,1); #Euclidean norms
xxRandBall=xxRand/normRand[:,None]; #rescale by Euclidean norms
xxRandBall=r*xxRandBall; #rescale for non-unit sphere
#retrieve x and y coordinates
xx= xxRandBall[:,0];
yy= xxRandBall[:,1];

# Shift centre of circle to (xx0,yy0)
xx = xx + xx0;
yy = yy + yy0;

# Plotting
plt.scatter(xx, yy, edgecolor='b', facecolor='none', alpha=0.5);
plt.xlabel('x');
plt.ylabel('y');
plt.axis('equal');
