# This code generates a Voronoi-Poisson tessellation, meaning it generates
# a Poisson point process and then uses it to generate a corresponding 
# Voronoi tesselation. A Voronoi tesselation is also known as a Dirichlet
# tesselation or Voronoi diagram.
#
# A (homogeneous) Poisson point process (PPP) is created on a rectangle.
# Then the Voronoi tesselation is found using the SciPy function 
# Voronoi[1], which is based on the Qhull project[2] .
#
# All points and Voronoi cells of the PPP are numbered arbitrarily.
#
# Author: H.Paul Keeler, 2019
#
# [1] http://scipy.github.io/devdocs/generated/scipy.spatial.Voronoi.html
# [2] http://www.qhull.org/

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from scipy.spatial import Voronoi, voronoi_plot_2d #for voronoi tessellation

plt.close('all');  # close all figures

# Simulation window parameters
xMin = 0;
xMax = 1;
yMin = 0;
yMax = 1;
# rectangle dimensions
xDelta = xMax - xMin; #width
yDelta = yMax - yMin #height
areaTotal = xDelta * yDelta; #area of similation window

# Point process parameters
lambda0 = 10;  # intensity (ie mean density) of the Poisson process

# Simulate a Poisson point process
numbPoints = np.random.poisson(lambda0 * areaTotal);  # Poisson number of points
xx = xDelta * np.random.uniform(0, 1, numbPoints) + xMin;  # x coordinates of Poisson points
yy = yDelta * np.random.uniform(0, 1, numbPoints) + yMin;  # y coordinates of Poisson points

xxyy=np.stack((xx,yy), axis=1); #combine x and y coordinates
##Perform Voroin tesseslation using built-in function
voronoiData=Voronoi(xxyy);
vertexAll=voronoiData.vertices; #retrieve x/y coordinates of all vertices
cellAll=voronoiData.regions; #may contain empty array/set

####START -- Plotting section -- START###
#create voronoi diagram on the point pattern
voronoi_plot_2d(voronoiData, show_points=False,show_vertices=False); 
#plot underlying point pattern (ie a realization of a Poisson point process)
plt.scatter(xx, yy, edgecolor='b', facecolor='b');
#number the points
for ii in range(numbPoints):
    plt.text(xx[ii]+xDelta/50, yy[ii]+yDelta/50, ii);   
   
####END -- Plotting section -- END###
