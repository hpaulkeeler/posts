#Simulate an inhomogeneous Poisson point process on a rectangle
#This is done by simulating a homogeneous Poisson process, which is then
#thinned according to a (spatially *dependent*) p-thinning.
#The intensity function is lambda(x,y)=exp(-(x^2+y^2)/s^2), where s>0.
#Author: H. Paul Keeler, 2019.

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays
#Need xMin, xMax, yMin, yMax to be floats eg xMax=1.;

using Distributions #for random simulations
using Plots #for plotting
using BlackBoxOptim #for blackbox optimizing

#Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

s=0.5; #scale parameter

#Point process parameters
function fun_lambda(x,y)
    100*exp.(-(x.^2+y.^2)/s^2); #intensity function
end

###START -- find maximum lambda -- START ###
#For an intensity function lambda, given by function fun_lambda,
#finds the maximum of lambda in a rectangular region given by
#[xMin,xMax,yMin,yMax].
function fun_Neg(x)
     -fun_lambda(x[1],x[2]); #negative of lambda
end
xy0=[(xMin+xMax)/2,(yMin+yMax)/2];#initial value(ie centre)

#Find largest lambda value
boundSearch=[(1.0xMin,1.0xMax), (1.0yMin, 1.0yMax)];
#WARNING: Values of boundSearch cannot be integers!
resultsOpt=bboptimize(fun_Neg;SearchRange = boundSearch);
lambdaNegMin=best_fitness(resultsOpt); #retrieve minimum value found by bboptimize
lambdaMax=-lambdaNegMin;
###END -- find maximum lambda -- END ###

#define thinning probability function
function fun_p(x,y)
    fun_lambda(x,y)/lambdaMax;
end

#Simulate a Poisson point process
numbPoints=rand(Poisson(areaTotal*lambdaMax)); #Poisson number of points
xx=xDelta*rand(numbPoints,1).+xMin;#x coordinates of Poisson points
yy=yDelta*(rand(numbPoints,1)).+yMin;#y coordinates of Poisson points

#calculate spatially-dependent thinning probabilities
p=fun_p(xx,yy);
#Generate Bernoulli variables (ie coin flips) for thinning
booleRetained=rand(numbPoints,1).<p; #points to be retained
xxRetained=xx[booleRetained]; yyRetained=yy[booleRetained];

#Plotting
plot1=scatter(xxRetained,yyRetained,xlabel ="x",ylabel ="y", leg=false);
display(plot1);
