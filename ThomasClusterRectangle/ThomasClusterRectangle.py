# Simulate a Thomas cluster process on a rectangle.
# Author: H. Paul Keeler, 2018.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# hpaulkeeler.com/simulating-a-thomas-cluster-point-process/

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # For plotting

plt.close("all");  # close all figures

# Simulation window parameters
xMin = -.5;
xMax = .5;
yMin = -.5;
yMax = .5;

# Parameters for the parent and daughter point processes
lambdaParent = 10;  # density of parent Poisson point process
lambdaDaughter = 100;  # mean number of points in each cluster
sigma = 0.05;  # sigma for normal variables (ie random locations) of daughters

# Extended simulation windows parameters
rExt=6*sigma; # extension parameter 
# for rExt, use factor of deviation sigma eg 5 or 6
xMinExt = xMin - rExt;
xMaxExt = xMax + rExt;
yMinExt = yMin - rExt;
yMaxExt = yMax + rExt;
# rectangle dimensions
xDeltaExt = xMaxExt - xMinExt;
yDeltaExt = yMaxExt - yMinExt;
areaTotalExt = xDeltaExt * yDeltaExt;  # area of extended rectangle

# Simulate Poisson point process for the parents
numbPointsParent = np.random.poisson(areaTotalExt * lambdaParent);# Poisson number of points
# x and y coordinates of Poisson points for the parent
xxParent = xMinExt + xDeltaExt * np.random.uniform(0, 1, numbPointsParent);
yyParent = yMinExt + yDeltaExt * np.random.uniform(0, 1, numbPointsParent);

# Simulate Poisson point process for the daughters (ie final poiint process)
numbPointsDaughter = np.random.poisson(lambdaDaughter, numbPointsParent);
numbPoints = sum(numbPointsDaughter);  # total number of points

# Generate the (relative) locations in Cartesian coordinates by
# simulating independent normal variables
xx0 = np.random.normal(0, sigma, numbPoints);  # (relative) x coordinaets
yy0 = np.random.normal(0, sigma, numbPoints);  # (relative) y coordinates

# replicate parent points (ie centres of disks/clusters)
xx = np.repeat(xxParent, numbPointsDaughter);
yy = np.repeat(yyParent, numbPointsDaughter);

# translate points (ie parents points are the centres of cluster disks)
xx = xx + xx0;
yy = yy + yy0;

# thin points if outside the simulation window
booleInside = ((xx >= xMin) & (xx <= xMax) & (yy >= yMin) & (yy <= yMax));
# retain points inside simulation window
xx = xx[booleInside];  
yy = yy[booleInside];

# Plotting
plt.scatter(xx, yy, edgecolor='b', facecolor='none', alpha=0.5);
plt.xlabel("x");
plt.ylabel("y");
plt.axis('equal');