# Simulate a Cox point process on a disk. 
# This Cox point process is formed by first simulating a uniform Poisson 
# line process. On each line (or segment) an independent Poisson point 
# process is then simulated.
# Author: H. Paul Keeler, 2019.


###START -- Parameters -- START###
#Cox (ie Poisson line-point) process parameters
lambda=4; #intensity (ie mean density) of the Poisson *line* process
mu=5; #intensity (ie mean density) of the Poisson *point* process

#Simulation disk dimensions
xx0=0; yy0=0; #center of disk
r=1; #disk radius
massLine=2*pi*r*lambda; #total measure/mass of the line process
###END -- Parameters -- END###

###START -- Simulate a Poisson line process on a disk -- START###
#Simulate Poisson point process
numbLines=rpois(1,massLine);#Poisson number of points

theta=2*pi*runif(numbLines); #choose angular component uniformly
p=r*runif(numbLines); #choose radial component uniformly
q=sqrt(r^2-p^2); #distance to circle edge (alonge line)

#calculate trig values
sin_theta=sin(theta);
cos_theta=cos(theta);

#calculate segment endpoints of Poisson line process
xx1=xx0+p*cos_theta+q*sin_theta;
yy1=yy0+p*sin_theta-q*cos_theta;
xx2=xx0+p*cos_theta-q*sin_theta;
yy2=yy0+p*sin_theta+q*cos_theta;
###END Simulate a Poisson line process on a disk END###

###START Simulate a Poisson point processes on each line START###
lengthLine=2*q; #length of each segment
massPoint=mu*lengthLine;#mass on each line
numbLinePoints=rpois(rep(1,numbLines),massPoint); #Poisson number of points on each line
numbLinePointsTotal=sum(numbLinePoints);
uu=2*runif(numbLinePointsTotal)-1; #uniform variables on (-1,1)

#replicate values to simulate points all in one step
xx0_all=rep(xx0,numbLinePointsTotal);
yy0_all=rep(yy0,numbLinePointsTotal);
p_all=rep(p,numbLinePoints);
q_all=rep(q,numbLinePoints);
sin_theta_all=rep(sin_theta,numbLinePoints);
cos_theta_all=rep(cos_theta,numbLinePoints);

#position points on Poisson lines/segments
xxPP_all=xx0_all+p_all*cos_theta_all+q_all*uu*sin_theta_all;
yyPP_all=yy0_all+p_all*sin_theta_all-q_all*uu*cos_theta_all;
### END Simulate a Poisson point processes on each line ###END

### START Plotting ###START
#plot circle
t=seq(0,2*pi,len=200);
xp=r*cos(t); yp=r*sin(t);
par(pty='s'); #use square plotting region
plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black');

#plot segments of Poisson line process
segments(xx1,yy1,xx2,yy2,col='blue'); 
#plot Poisson points on line process
points(xxPP_all,yyPP_all,pch=20, col='red');

###END Plotting END###

