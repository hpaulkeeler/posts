# Compares two methods for simulating a homogeneous Poisson point process,
# where the idea behind one method is faster than the other. In this code, the
# two methods are labelled A and B.
#
# Method A simulates all the Poisson ensembles randomly by first randomly
# generating all the Poisson random variables in one step. It then randomly
# positions all the points (across all ensembles) in one step. All the
# points are then are then separated accordingly into ensembles.
#
# Method B iterates through a for-loop, and for each iteration, it randomly
# generates a Poisson variable and positions the points for each ensemble.
#
# Method A uses more vectorization than Method B so it should be faster 
# than Method B in general.
#
# Author: H. Paul Keeler, 2019.

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from matplotlib import collections  as mc  # for plotting line segments
import time

###START Parameters START###
numbSim = 10 ** 6;  # number of simulations

# Point process parameters
lambda0 = 20;  # intensity (ie mean density) of Poisson point process

# Simulation window parameters
xMin = 0;
xMax = 1;
yMin = 0;
yMax = 1;
xDelta = xMax - xMin;
yDelta = yMax - yMin;  # rectangle dimensions
areaTotal = xDelta * yDelta;  # area of rectangle
massTotal = areaTotal * lambda0;  # total measure/mass of the point process
###END Parameters END###

###START Simulation section START###
###START Method A: Generate *all* ensembles at once START###
t0 = time.time();  # start timing
numbPointsA = np.random.poisson(massTotal, numbSim);  # Poisson number of points
numbPointsTotal = sum(numbPointsA);
# uniform x/y coordinates of Poisson points
xxAll = xDelta * (np.random.rand(numbPointsTotal)) + xMin;  # x coordinates of Poisson points
yyAll = yDelta * (np.random.rand(numbPointsTotal)) + yMin;  # y coordinates of Poisson points

# convert Poisson point processes into lists
indexPoints = np.cumsum(numbPointsA[0:-1]);  # index for creating lists
xxListA = np.split(xxAll, indexPoints, axis=0);  # list for x values
yyListA = np.split(yyAll, indexPoints, axis=0)  # list for y values
numbListA = np.split(numbPointsA, 1);
t1 = time.time();  # finish timing
print('Elapsed time is ', (t1 - t0), 'seconds.');

###END Method A: Generate *all* ensembles at once END###

###START Method B: Generate each ensemble separately START###
t0 = time.time();  # start timing
xxListB = [];
yyListB = [];
numbPointsB = np.zeros(numbSim);
# loop through for all ensembles
for ss in range(numbSim):
    numbPointsTemp = np.random.poisson(massTotal);  # Poisson number of points
    xxListB.append(xDelta * (np.random.rand(numbPointsTemp)) + xMin);  # x coordinates of Poisson points
    yyListB.append(yDelta * (np.random.rand(numbPointsTemp)) + yMin);  # y coordinates of Poisson points
    numbPointsB[ss] = numbPointsTemp;

t1 = time.time();  # finish timing
print('Elapsed time is ', (t1 - t0), 'seconds.');
###END Method B: Generate each ensemble separately END###
###END Simulation section END###

####START Create point pattern structures START###
##create vector for describing the window
# windowSim=[xMin,xMax,yMin,yMax];
##create empty structure
# class structtype():
#    pass
# ppStructPoissonA = [ structtype() for ii in range(numbSim)];
# ppStructPoissonB = [ structtype() for ii in range(numbSim)];
# for ii in range(numbSim):
#    #structure array for point patterns from Method A
#    ppStructPoissonA[ii].xx=xxListA[ii];
#    ppStructPoissonA[ii].yy=yyListA[ii];
#    ppStructPoissonA[ii].n=numbPointsA[ii];
#    ppStructPoissonA[ii].window=windowSim;
#        
#    #structure array for point patterns from Method B
#    ppStructPoissonB[ii].xx=xxListB[ii];
#    ppStructPoissonB[ii].yy=yyListB[ii];
#    ppStructPoissonB[ii].n=numbPointsB[ii];
#    ppStructPoissonB[ii].window=windowSim;
####END Create point pattern structures END###
