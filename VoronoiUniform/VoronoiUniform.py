# This code generates a Voronoi-Poisson tessellation
# A (homogeneous) Poisson point process (PPP) is created on a rectangle.
# Then the Voronoi tesselation is found using the SciPy function[1], which is based on 
# the Qhull project[2] .
# All points (or cells) of the PPP are numbered arbitrarily.
# In each *bounded* Voronoi cell a new point is uniformly placed.
#
# The placement step is done by first dividing each (bounded) Voronoi cell
# (ie an irregular polygon) with, say, m sides into m scalene triangles.
# The i th triangle is then randomly chosen based on the ratio of areas.
# A point is then uniformly placed on the i th triangle (via eq. 1 in [3]).
# The placement step is repeated for all bounded Voronoi cells.
# A Voronoi diagram is displayed over the PPP. Points of the underlying PPP
# are marked green and blue if they are located respectively in bounded and
# unbounded Voronoi cells. The uniformally placed points in the bounded
# cells are marked red.
# If there are no bounded Voronoi cells, no diagram is created.
#
# Author: H.Paul Keeler, 2019
#
# [1] http://scipy.github.io/devdocs/generated/scipy.spatial.Voronoi.html
# [2] http://www.qhull.org/
# [2] Osada, R., Funkhouser, T., Chazelle, B. and Dobkin. D.,
# "Shape distributions", ACM Transactions on Graphics, vol 21, issue 4,
# 2002

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from scipy.spatial import Voronoi, voronoi_plot_2d #for voronoi tessellation

plt.close('all');  # close all figures

boolePlot=True; # set to True for plot, False for no plot

# Simulation window parameters
xMin = 0;
xMax = 1;
yMin = 0;
yMax = 1;
xDelta = xMax - xMin;
yDelta = yMax - yMin;  # rectangle dimensions
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
vertexAll=voronoiData.vertices; #retrieve x/y coordiantes of all vertices
cellAll=voronoiData.regions; #may contain empty array/set
numbCells=numbPoints; #number of Voronoi cells (including unbounded)

indexP2C=voronoiData.point_region; #index mapping between cells and points

##initiate arrays
booleBounded=np.zeros(numbCells,dtype=bool);
uu=np.zeros(numbCells);
vv=np.zeros(numbCells);

##Loop through for all Voronoi cells
for ii in range(numbCells):        
    booleBounded[ii]=not(any(np.array(cellAll[indexP2C[ii]])==-1));
    #checks if the Voronoi cell is bounded. if bounded, calculates its area 
    #and assigns a single point uniformally in the Voronoi cell.
    
    ### START -- Randomly place a point in a Voronoi cell -- START###
    if booleBounded[ii]:               
        xx0=xx[ii];yy0=yy[ii]; #the (Poisson) point of the Voronoi cell
        
        #print(jj,xx0,yy0)        
        #x/y values for current cell
        xxCell=vertexAll[cellAll[indexP2C[ii]],0];        
        yyCell=vertexAll[cellAll[indexP2C[ii]],1];
                
        ### START -- Caclulate areas of triangles -- START###
        #calculate area of triangles of bounded cell (ie irregular polygon)
        numbTri=len(xxCell); #number of triangles        
        
        #create some indices for calculating triangle areas
        indexVertex= np.arange(numbTri+1); #number vertices
        indexVertex[-1]=0; #repeat first index (ie returns to the start)
        indexVertex1=indexVertex[np.arange(numbTri)]; #first vertex index
        indexVertex2=indexVertex[np.arange(numbTri)+1];  #second vertex index
        #using area equation for a triangle
        areaTri=abs((xxCell[indexVertex1]-xx0)*(yyCell[indexVertex2]-yy0)\
                    -(xxCell[indexVertex2]-xx0)*(yyCell[indexVertex1]-yy0))/2;            
        areaPoly=sum(areaTri);        
        ###END-- Caclulate areas of triangles -- END###
        
        ###START -- Randomly placing point -- START###
        ### place a point uniformaly in the (bounded) polygon
        #randomly choose the triangle (from the set that forms the polygon)
        cdfArea=np.cumsum(areaTri)/areaPoly; #create triangle CDF
        indexTri=(np.random.rand() <= cdfArea).argmax(); #use CDF to choose #
                    
        indexVertex1=indexVertex[indexTri]; #first vertex index
        indexVertex2=indexVertex[indexTri+1]; #second vertex index
        #for all triangles except the last one
        xxTri=[xx0, xxCell[indexVertex1],xxCell[indexVertex2]];
        yyTri=[yy0, yyCell[indexVertex1],yyCell[indexVertex2]];
        
        #create two uniform random variables on unit interval
        uniRand1=np.random.rand(); uniRand2=np.random.rand();
        
        #x coordinate
        uu[ii]=(1-np.sqrt(uniRand1))*xxTri[0]\
        +np.sqrt(uniRand1)*(1-uniRand2)*xxTri[1]\
        +np.sqrt(uniRand1)*uniRand2*xxTri[2]
        #y coordinate
        vv[ii]=(1-np.sqrt(uniRand1))*yyTri[0]\
        +np.sqrt(uniRand1)*(1-uniRand2)*yyTri[1]\
        +np.sqrt(uniRand1)*uniRand2*yyTri[2];
        ###END -- Randomly placing point -- END###

### END -- Randomly place a point in a Voronoi cell -- END###

indexBound=np.arange(numbCells)[booleBounded]; #find bounded cells
uu=uu[indexBound]; vv=vv[indexBound]; #remove unbounded cells
numbBound=len(indexBound); #number of bounded cells
percentBound=numbBound/numbCells #percent of bounded Voronoi cells

####START -- Plotting section -- START###
if (numbBound>0) and (boolePlot):
#    figure; grid; hold on;
    #plotting points in PPP
    voronoi_plot_2d(voronoiData); #create voronoi diagram on the PPP
    #put a red o uniformally in each bounded Voronoi cell
    plt.scatter(uu, vv, edgecolor='r', facecolor='none');
    #put a green star on the base station of each Voronoi bounded cell
    plt.scatter(xx[indexBound], yy[indexBound], edgecolor='g', marker='*');
    #number the points
    for ii in range(numbPoints):
        plt.text(xx[ii], yy[ii], ii);   
   
####END -- Plotting section -- END###