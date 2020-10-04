# Simulate a Poisson point process on a circle.
# Author: H. Paul Keeler, 2020.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting

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
theta = 2 * np.pi * np.random.uniform(0, 1, numbPoints);  # angular coordinates
rho = r ;  # radial coordinates

# Convert from polar to Cartesian coordinates
xx = rho * np.cos(theta);
yy = rho * np.sin(theta);

# Shift centre of circle to (xx0,yy0)
xx = xx + xx0;
yy = yy + yy0;

# Plotting
plt.scatter(xx, yy, edgecolor='b', facecolor='none', alpha=0.5);
plt.xlabel('x');
plt.ylabel('y');
plt.axis('equal');
