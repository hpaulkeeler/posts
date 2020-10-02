# Simulate a binomial point process on a unit square.
# Author: H. Paul Keeler, 2018.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

numbPoints=10; #number of points

#Simulate Binomial point process
xx=runif(numbPoints);#x coordinates of Binomial points
yy=runif(numbPoints);#y coordinates of Binomial points

#Plotting
plot(xx,yy,'p',xlab='x',ylab='y',col='blue');


