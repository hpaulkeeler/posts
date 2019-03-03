#Simulate an inhomogeneous Poisson point process on a rectangle
#This is done by simulating a homogeneous Poisson process, which is then
#thinned according to a (spatially *dependent*) p-thinning.
#The intensity function is lambda(x,y)=exp(-(x^2+y^2)/s^2), where s>0.
#Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #For plotting
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
    return 100*np.exp(-(x**2+y**2)/s**2); #intensity function

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
numbSim=10**3;  #number of simulations
numbPointsRetained=np.zeros(numbSim); #vector to record number of points
for ii in range(numbSim):
    #Simulate a Poisson point process
    numbPoints = np.random.poisson(areaTotal*lambdaMax);#Poisson number of points
    xx = np.random.uniform(0,xDelta,((numbPoints,1)))+xMin;#x coordinates of Poisson points
    yy = np.random.uniform(0,yDelta,((numbPoints,1)))+yMin;#y coordinates of Poisson points
    
    #calculate spatially-dependent thinning probabilities
    p=fun_p(xx,yy); 
    
    #Generate Bernoulli variables (ie coin flips) for thinning
    booleRetained=np.random.uniform(0,1,((numbPoints,1)))<p; #points to be retained
    
    #x/y locations of retained points
    xxRetained=xx[booleRetained]; yyRetained=yy[booleRetained];
    numbPointsRetained[ii]=xxRetained.size;

#Plotting
plt.scatter(xxRetained,yyRetained, edgecolor='b', facecolor='none', alpha=0.5 );
plt.xlabel("x"); plt.ylabel("y");
plt.show(); 

#run empirical test on number of points generated
if numbSim>1:
    #total mean measure (average number of points)
    LambdaNumerical=integrate.dblquad(fun_lambda,xMin,xMax,lambda x: yMin,lambda y: yMax)[0];
    #Test: as numbSim increases, LambdaEmpirical converges to numbPointsMean
    numbPointsMean=np.mean(numbPointsRetained);
    numbPointsVar=np.var(numbPointsRetained);   
    
