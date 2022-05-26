# This code takes a single realization of a (homogeneous) Poisson point 
# process on a rectangle and opies or tiles it, wrapping around the 
# original rectangle. 
# 
# It can also tile a random Poisson point process, meaning each tile will 
# have a different realization
#
# Author: H. Paul Keeler, 2022.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np  # NumPy package for arrays, random number generation, etc
import numpy.matlib
from numpy.random import RandomState
import matplotlib.pyplot as plt  # for plotting
from matplotlib.patches import Rectangle  # for drawing rectangles

plt.close('all')  # close all figures

numbSimS=1; #number of street simulations
seedRandS=5; #random seed for reproducing results (-1 to use computer seed)
boolePlot=1; #set to 1 to plot street layout, 0 for no plot

choiceTile=1; #1 tile a single realization; 2 tile the random point process
numbWrap=1; #number tiles tiles are wrapped around centre tile

#Poisson point process parameter
lambdaS=5   ; #intensity (ie mean density) of the Poisson point process

#Simulation window parameters
xDelta=1; #width
yDelta=1; #height
x0=0; #x centre
y0=0; #y centre
xMin=x0-xDelta/2; #minimum x value
xMax=x0+xDelta/2; #maximum x value
yMin=y0-yDelta/2; #minimum y value
yMax=y0+yDelta/2; #maximum y value
areaTotal=xDelta*yDelta; #area of (inner) simulation window

#plotting parameters
#simulation window dimensions
dimBox=np.array([xMin, yMin, xDelta, yDelta]);
#axis limits
xAxisLim=np.array([xMin, xMax])*1.2;
yAxisLim=np.array([yMin, yMax])*1.2;

if seedRandS==-1:
    np.random.seed();
    #retrieves random seed used by computer    
    seedRandS=np.random.get_state()[1][0];   
else:
    #sets random seed
    np.random.seed(seedRandS);
#end if statemenet

#tiling parameters
numbSide=(2*numbWrap+1); #width of tiling (ie number of tiles across)
numbTile=numbSide**2; #total number of tiles

for ss in range(numbSimS):
    #loop through each simulation
    
    ###START - Simulate Poisson point process - START###
    if choiceTile==1:
        #tile realization
        numbPointsSingle=np.random.poisson(areaTotal*lambdaS);
        #Poisson number of points (repeated numbTile times)
        numbPoints=np.tile(numbPointsSingle,numbTile);
        numbPointsTotal=np.sum(numbPoints); # number of points in all the tiles
        #x/y coordinates of a realization of Poisson process
        xxSingle=xDelta*(np.random.rand(numbPointsSingle))+xMin;
        yySingle=yDelta*(np.random.rand(numbPointsSingle))+yMin;
        #repeat realization numbTile times
        xx=np.tile(xxSingle,numbTile);
        yy=np.tile(yySingle,numbTile);
        
    elif choiceTile==2:
        #tile point process
        #numbTile number of Poisson number of points
        numbPoints=np.random.poisson(areaTotal*lambdaS,numbTile);
        numbPointsTotal=np.sum(numbPoints); # number of points in all the tiles
        #x/y coordinates of copies of a Poisson process
        xx=xDelta*(np.random.rand(numbPointsTotal))+xMin;
        yy=yDelta*(np.random.rand(numbPointsTotal))+yMin;
    else:
        #Test case - KEEP FOR Python code
        xxSingle=np.array([-.3,-.4,0,.2,.1,.2])/2;
        yySingle=np.array([.4,.3,.1,.1,.3,.4]);
        numbPointsSingle=xxSingle.size;
        numbPoints=np.tile(numbPointsSingle,(numbTile,1));
        numbPointsTotal=np.sum(numbPoints); # number of points in all the tiles
                #repeat realization numbTile times
        xx=np.tile(xxSingle.flatten(),numbTile);
        yy=np.tile(yySingle.flatten(),numbTile);
    #end if statemenet
    
    indexPoints= np.cumsum(numbPoints[0:-1]);  # index for creating lists
    # convert to cell arrays, where each cell is a tile    
    xxTiledCell = np.split(xx,indexPoints,axis=0);
    yyTiledCell = np.split(yy,indexPoints,axis=0);
    ####end for-loop - Simulate Poisson point process - #end for-loop###
    
    ###START - Tile point process by shifting x/y values - START###
    xShift=xDelta*np.arange(-numbWrap,numbWrap+1); #all possible x value shifts
    yShift=yDelta*np.arange(-numbWrap,numbWrap+1); #all possible y value shifts
    
    # update plotting boole variable (ie no plot with two many points)
    boolePlotSim=boolePlot&(numbPointsTotal<100*numbTile);
    # create figure
    if boolePlotSim&(ss==numbSimS-1):
       plt.figure();
       fig, ax = plt.subplots();  # use subplots for multiple plots in one window
    #end if statemenet
    
    countTile=0; #initialize tile count
    for ii in range(numbSide):
        #loop through each x shift (corresponding to horizontal tiling)
        
        for jj in range(numbSide):
            #loop through each y shift (corresponding to vertical tiling)
            
            #shift x and y values
            xxTiledCell[countTile]=xxTiledCell[countTile]+xShift[ii];
            yyTiledCell[countTile]=yyTiledCell[countTile]+yShift[jj];
            
            if boolePlotSim&(ss==numbSimS-1):
                #plot each tile
                xxPlot=xxTiledCell[countTile];
                yyPlot=yyTiledCell[countTile];
                colorTemp=np.random.rand(3); #each color is a different vector
                plt.plot(xxPlot,yyPlot,'.',color=colorTemp, markersize=9); #,'Color',colorTemp
                #update box/tile dimensions
                dimBoxTemp=[xMin+xShift[ii], yMin+yShift[jj]];
                #draw box in black
                ax.add_patch(Rectangle(dimBoxTemp, xDelta, yDelta, fc='none', ec='k', lw=2))
                                
                #if last tile, adjust plot settings
                if countTile==numbTile-1:
                    plt.xlim(np.array([-numbSide*xDelta, numbSide*xDelta])/2);
                    plt.ylim(np.array([-numbSide*yDelta, numbSide*yDelta])/2);                    
                    #remove ticks on x and y axes
                    plt.axis('off')                    
                #end if statemenet
            #end if statemenet
            countTile=countTile+1;
        #end for-loop
    #end for-loop
    
    #turn coordinate lists into 1-D arrays
    xxTiled=np.concatenate(xxTiledCell).flatten();
    yyTiled=np.concatenate(yyTiledCell).flatten();
    ###END - Tile point process by shifting x/y values - END###    
#end for-loop