# Simulate a binomial point process on a rectangle.
# Author: H. Paul Keeler, 2018.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

numbPoints=30; #number of points

#Simulation window parameters
xMin=0;
xMax=1;
yMin=0;
yMax=1;
#rectangle dimensions
xDelta=xMax-xMin;
yDelta=yMax-yMin; 

#Simulate Binomial point process
xx=xDelta*runif(numbPoints)+xMin;#x coordinates of uniform points
yy=yDelta*runif(numbPoints)+yMin;#y coordinates of uniform points

#Plotting
plot(xx,yy,'p',xlab='x',ylab='y',col='blue');


