#Simulate a Poisson point process on a disk
#Author: H. Paul Keeler, 2018.

#Simulation window parameters
r=1; #radius of disk
xx0=0; yy0=0; #centre of disk
areaTotal=pi*r^2; #area of disk

#Point process parameters
lambda=100; #intensity (ie mean density) of the Poisson process

#Simulate Poisson point process
numbPoints=rpois(1,areaTotal*lambda);#Poisson number of points
theta=2*pi*runif(numbPoints);#angular  of Poisson points
rho=r*sqrt(runif(numbPoints));#radial coordinates of Poisson points

#Convert from polar to Cartesian coordinates
xx=rho*cos(theta);
yy=rho*sin(theta);

#Shift centre of disk to (xx0,yy0)
xx=xx+xx0;
yy=yy+yy0;

#Plotting
par(pty="s"); #use square plotting region
plot(xx,yy,'p',xlab='x',ylab='y',col='blue');

#Simulate a Poisson point process with spatstat library
library("spatstat");
ppPoisson<-rpoispp(lambda,win=disc(radius=r,centre=c(xx0,yy0))) #create Poisson "point pattern" object
plot(ppPoisson); #Plot point pattern object
#retrieve x/y values from point pattern object
xx=ppPoisson$x; 
yy=ppPoisson$y;

#do the above, but in one line
plot(ppPoisson<-rpoispp(lambda,win=disc(radius=r,centre=c(xx0,yy0))) ); #create and plot point pattern object
