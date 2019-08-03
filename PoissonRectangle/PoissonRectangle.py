# Simulate a Poisson point process on a rectangle.
# Author: H. Paul Keeler, 2018.

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting

plt.close('all');  # close all figures

# Simulation window parameters
xMin = 0;
xMax = 1;
yMin = 0;
yMax = 1;
xDelta = xMax - xMin;
yDelta = yMax - yMin;  # rectangle dimensions
areaTotal = xDelta * yDelta;

# Point process parameters
lambda0 = 100;  # intensity (ie mean density) of the Poisson process

# Simulate a Poisson point process
numbPoints = np.random.poisson(lambda0 * areaTotal);  # Poisson number of points
xx = xDelta * np.random.uniform(0, 1, numbPoints) + xMin;  # x coordinates of Poisson points
yy = yDelta * np.random.uniform(0, 1, numbPoints) + yMin;  # y coordinates of Poisson points

# Plotting
plt.scatter(xx, yy, edgecolor='b', facecolor='none', alpha=0.5);
plt.xlabel('x');
plt.ylabel('y');