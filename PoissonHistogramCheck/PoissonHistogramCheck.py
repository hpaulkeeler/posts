#Simulate an inhomogeneous Poisson point process on a rectangle
#This is done by simulating a homogeneous Poisson process, which is then
#thinned according to a (spatially *dependent*) p-thinning
#Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #For plotting
from matplotlib import cm #for heatmap plotting
from mpl_toolkits import mplot3d #for 3-D plots
from scipy.optimize import minimize #For optimizing
from scipy import integrate
 
#Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

s=0.5; #scale parameter

#Point process parameters
def fun_lambda(x,y):
    lambdaValue=80*np.exp(-((x+0.5)**2+(y+0.5)**2)/s**2)+100*np.exp(-((x-0.5)**2+(y-0.5)**2)/s**2);
    return lambdaValue;

###START -- find maximum lambda -- START ###
#For an intensity function lambda, given by function fun_lambda, 
#finds the maximum of lambda in a rectangular region given by 
#[xMin,xMax,yMin,yMax].    
def fun_Neg(x):
    return -fun_lambda(x[0],x[1]); #negative of lambda 
    
xy0=[(xMin+xMax)/2,(yMin+yMax)/2];#initial value(ie centre)
#Find largest lambda value
resultsOpt=minimize(fun_Neg,xy0,bounds=((xMin, xMax), (yMin, yMax)));
lambdaNegMin=resultsOpt.fun; #retrieve minimum value found by minimize
lambdaMax=-lambdaNegMin; 
###END -- find maximum lambda -- END ###

#define thinning probability function
def fun_p(x,y):
    return fun_lambda(x,y)/lambdaMax;    

#for collecting statistics -- set numbSim=1 for one simulation
numbSim=10**4;  #number of simulations
numbPointsRetained=np.zeros(numbSim); #vector to record number of points
xxArrayAll=[]; yyArrayAll=[];

for ii in range(numbSim):
    #Simulate a Poisson point process
    numbPoints = np.random.poisson(lambdaMax*areaTotal);#Poisson number of points
    xx = np.random.uniform(0,xDelta,((numbPoints,1)))+xMin;#x coordinates of Poisson points
    yy = np.random.uniform(0,yDelta,((numbPoints,1)))+yMin;#y coordinates of Poisson points
    
    #calculate spatially-dependent thinning probabilities
    p=fun_p(xx,yy); 
    
    #Generate Bernoulli variables (ie coin flips) for thinning
    booleRetained=np.random.uniform(0,1,((numbPoints,1)))<p; #points to be thinned
    
    #x/y locations of retained points
    xxRetained=xx[booleRetained]; yyRetained=yy[booleRetained];
    numbPointsRetained=xxRetained.size;
    xxArrayAll.extend(xxRetained); yyArrayAll.extend(yyRetained);

#Plotting
fig1 = plt.figure();
plt.scatter(xxRetained,yyRetained, edgecolor='b', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");
plt.show(); 

#total mean measure (average number of points)
LambdaNumerical=integrate.dblquad(fun_lambda,xMin,xMax,lambda x: yMin,lambda y: yMax)[0];
#Test: as numbSim increases, LambdaEmpirical converges to LambdaNumerical
LambdaEmpirical=np.mean(numbPointsRetained);

p_Estimate, xxEdges, yyEdges = np.histogram2d(xxArrayAll, yyArrayAll,bins=40,normed='pdf');

xxValues=(xxEdges[1:]+xxEdges[0:xxEdges.size-1])/2;
yyValues=(yyEdges[1:]+yyEdges[0:yyEdges.size-1])/2;

X, Y = np.meshgrid(xxValues,yyValues)

fig2 = plt.figure();
ax = plt.axes(projection='3d');  
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
surf = ax.plot_surface(X, Y,p_Estimate,cmap=plt.cm.plasma);
plt.xlabel("x"); plt.ylabel("y");
plt.title('Estimate of $\lambda(x)$ normalized'); 


p_Exact=fun_p(X,Y);
fig3 = plt.figure();
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
ax = plt.axes(projection='3d');
surf = ax.plot_surface(X, Y,p_Exact,cmap=plt.cm.plasma);
plt.xlabel("x"); plt.ylabel("y");
plt.title('$\lambda(x)$ normalized'); 

#These links may help in plotting.
#https://matplotlib.org/gallery/mplot3d/hist3d.html
#https://matplotlib.org/mpl_toolkits/mplot3d/tutorial.html#bar-plots
#https://plot.ly/python/3d-surface-plots/
#https://chrisalbon.com/python/basics/set_the_color_of_a_matplotlib/
#https://matplotlib.org/examples/color/colormaps_reference.html



#funNeg=@(x)(-lambda(x(1),x(2)));
#funPos=@(x)(lambda(x(1),x(2)));



#def funAuxMaxIntensity(fun_lambda,boxSample):
#    def fun_Neg(x):
#        return -fun_lambda(x[0],x[1]); #negative of lambda 
#    
#    xy0=[(boxSample[0]+boxSample[1])/2,(boxSample[2]+boxSample[3])/2];#initial value(ie centre)
#    #Find largest lambda value
#    resultsOpt=minimize(fun_Neg,xy0,bounds=((boxSample[0], boxSample[1]), (boxSample[2], boxSample[3])));
#    lambdaNegMin=resultsOpt.fun;
#    lambdaMax=-lambdaNegMin;
#    return lambdaMax; #retrieve minimum value
