#Simulate a Poisson point process on a rectangle.
#Author: H. Paul Keeler, 2018.

#Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta;

#Point process parameters
lambda=100; #intensity (ie mean density) of the Poisson process

#Simulate a Poisson point process
numbPoints=rpois(1,areaTotal*lambda);#Poisson number of points
xx=xDelta*runif(numbPoints)+xMin;#x coordinates of Poisson points
yy=xDelta*runif(numbPoints)+yMin;#y coordinates of Poisson points

#Plotting
par(pty="s")
plot(xx,yy,'p',xlab='x',ylab='y',col='blue');


