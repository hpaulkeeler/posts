#Simulate a Poisson point process on a rectangle
#Then thin the Poisson point process according to a (spatially *independent*) 
#p-thinning 
#Author: H. Paul Keeler, 2019.

#Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

#Point process parameters
lambda=100; #intensity (ie mean density) of the Poisson process

#Thinning probability
p=0.25; 

#Simulate a Poisson point process
numbPoints=rpois(1,areaTotal*lambda);#Poisson number of points
xx=xDelta*runif(numbPoints)+xMin;#x coordinates of Poisson points
yy=xDelta*runif(numbPoints)+yMin;#y coordinates of Poisson points

#Generate Bernoulli variables (ie coin flips) for thinning
booleThinned=runif(numbPoints)<p; #points to be thinned
booleRetained=!booleThinned; #points to be retained

#x/y locations of thinned points
xxThinned=xx[booleThinned]; yyThinned=yy[booleThinned];
#x/y locations of retained points
xxRetained=xx[booleRetained]; yyRetained=yy[booleRetained];

#Plotting
par(pty="s")
plot(xxRetained,yyRetained,'p',xlab='x',ylab='y',col='blue'); #plot retained points
points(xxThinned,yyThinned,col='red'); #plot thinned points

