#Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate two 
#jointly distributed random variuables with probability density
#p(x,y)=80*exp(-(x^2+y^2)/s^2)+100*exp(-(x^2+y^2)/s^2), where s>0.
#
#Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting
from matplotlib import cm #for heatmap plotting
from mpl_toolkits import mplot3d #for 3-D plots
from scipy import integrate #for integrating

plt.close("all"); #close all previous plots

#Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;

numbSim=10**5; #number of random variables simulated
numbSteps=25; #number of steps for the Markov process
numbBins=50; #number of bins for histogram
sigma=2; #standard deviation for normal random steps

#probability density parameters
s=.5; #scale parameter for distribution to be simulated
def fun_lambda(x,y):
    return 100*np.exp(-(x**2+y**2)/s**2);

#normalization constant
consNorm=integrate.dblquad(fun_lambda,xMin,xMax,lambda x: yMin,lambda y: yMax)[0];

def fun_p(x,y):
    return (fun_lambda(x,y)/consNorm)*(x>=xMin)*(y>=yMin)*(x<=xMax)*(y<=yMax);

xRand=np.random.uniform(xMin,xMax,numbSim); #random intial values
yRand=np.random.uniform(yMin,yMax,numbSim); #random intial values

probCurrent=fun_p(xRand,yRand); #current transition probabilities

for jj in range(numbSteps):
    zxRand= xRand +sigma*np.random.normal(0,1,numbSim);#take a (normally distributed) random step        
    zyRand= yRand +sigma*np.random.normal(0,1,numbSim);#take a (normally distributed) random step        
    #Conditional random step needs to be symmetric in x and y
    #For example: Z|x ~ N(x,1) (or Y=x+N(0,1)) with probability density
    #p(z|x)=e(-(z-x)^2/2)/sqrt(2*pi)    
    probProposal=fun_p(zxRand,zyRand); #proposed probability
    
    #acceptance rejection step
    booleAccept=np.random.uniform(0,1,numbSim) < probProposal/probCurrent;
    #update state of random walk/Marjov chain
    xRand[booleAccept]=zxRand[booleAccept];
    yRand[booleAccept]=zyRand[booleAccept];
    #update transition probabilities
    probCurrent[booleAccept]=probProposal[booleAccept];
   
#for histogram, need to reshape as vectors 
xRand= np.reshape(xRand,numbSim);
yRand= np.reshape(yRand,numbSim);

p_Estimate, xxEdges, yyEdges = np.histogram2d(xRand,yRand,bins=numbSteps,normed='pdf');
xValues=(xxEdges[1:]+xxEdges[0:xxEdges.size-1])/2; #mid-points of bins
yValues=(yyEdges[1:]+yyEdges[0:yyEdges.size-1])/2; #mid-points of bins
X, Y = np.meshgrid(xValues,yValues); #create x/y matrices for plotting

#analytic solution of probability density
p_Exact=fun_p(X,Y);

#Plotting
#Plot empirical estimate
fig1 = plt.figure();
ax = plt.axes(projection='3d');  
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
surf = ax.plot_surface(X, Y,p_Estimate,cmap=plt.cm.plasma);
plt.xlabel("x"); plt.ylabel("y");
plt.title('$p(x,y)$ Estimate'); 

#Plot exact expression
fig2 = plt.figure();
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
ax = plt.axes(projection='3d');
surf = ax.plot_surface(X, Y,p_Exact,cmap=plt.cm.plasma);
plt.xlabel("x"); plt.ylabel("y");
plt.title('$p(x,y)$ Exact Expression'); 