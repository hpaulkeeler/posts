# Simulate a binomial point process on a rectangle.
# Author: H. Paul Keeler, 2018
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np
import matplotlib.pyplot as plt

plt.close('all');  # close all figures

numbPoints = 30;  # number of points

# Simulation window parameters
xMin = 0;
xMax = 1;
yMin = 0;
yMax = 1;
# rectangle dimensions
xDelta = xMax - xMin;
yDelta = yMax - yMin;  

# Simulate binomial point process
xx = xDelta*np.random.uniform(0, 1, numbPoints) + xMin  # x coordinates of binomial points
yy = yDelta*np.random.uniform(0, 1, numbPoints) + yMin # y coordinates of binomial points

# Plotting
plt.scatter(xx, yy, edgecolor='b', facecolor='none', alpha=0.5)
plt.xlabel('x')
plt.ylabel('y')
plt.show() 
