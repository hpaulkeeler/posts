# Illustrate the three solutions of the Bertrand paradox on a disk.
# The paradox asks what is the probability of a random chord in a 
# circle being greater than a side of equilateral triangle inscribed in
# the circle. Traditionally this problem has three different solutions.
# The three solutions are labelled A, B and C, which correspond to
# solutions 1, 2 and 3 in, for example, the Wikipedia article:
# https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
# The empirical estimates are also done for the probability of the chord 
# length being greater than the side of the triangle. 
# The results are not plotted if the number of lines is equal to or 
# greater than a thousand (ie numbLines<1000 for plotting).
# Author: H. Paul Keeler, 2019.

###START Parameters START###
#Simulation disk dimensions
xx0=0; yy0=0; #center of disk
r=1; #disk radius
numbLines=10^2;#number of lines
###END Parameters END###

###START Simulate three solutions on a disk START###
#Solution A
thetaA1=2*pi*runif(numbLines); #choose angular component uniformly
thetaA2=2*pi*runif(numbLines); #choose angular component uniformly

#calculate segment endpoints
xxA1=xx0+r*cos(thetaA1);
yyA1=yy0+r*sin(thetaA1);
xxA2=xx0+r*cos(thetaA2);
yyA2=yy0+r*sin(thetaA2);
#calculate midpoints of segments
xxA0=(xxA1+xxA2)/2; yyA0=(yyA1+yyA2)/2;

#Solution B
thetaB=2*pi*runif(numbLines); #choose angular component uniformly
pB=r*runif(numbLines); #choose radial component uniformly
qB=sqrt(r^2-pB^2); #distance to circle edge (along line)

#calculate trig values
sin_thetaB=sin(thetaB);
cos_thetaB=cos(thetaB);

#calculate segment endpoints
xxB1=xx0+pB*cos_thetaB+qB*sin_thetaB;
yyB1=yy0+pB*sin_thetaB-qB*cos_thetaB;
xxB2=xx0+pB*cos_thetaB-qB*sin_thetaB;
yyB2=yy0+pB*sin_thetaB+qB*cos_thetaB;
#calculate midpoints of segments
xxB0=(xxB1+xxB2)/2; yyB0=(yyB1+yyB2)/2;

#Solution C
#choose a point uniformly in the disk
thetaC=2*pi*runif(numbLines); #choose angular component uniformly
pC=r*sqrt(runif(numbLines)); #choose radial component
qC=sqrt(r^2-pC^2); #distance to circle edge (alonge line)

#calculate trig values
sin_thetaC=sin(thetaC);
cos_thetaC=cos(thetaC);

#calculate segment endpoints
xxC1=xx0+pC*cos_thetaC+qC*sin_thetaC;
yyC1=yy0+pC*sin_thetaC-qC*cos_thetaC;
xxC2=xx0+pC*cos_thetaC-qC*sin_thetaC;
yyC2=yy0+pC*sin_thetaC+qC*cos_thetaC;
#calculate midpoints of segments
xxC0=(xxC1+xxC2)/2; yyC0=(yyC1+yyC2)/2;
###END Simulate three solutions on a disk END###

#Plot if there are less than a thousand lines.
if (numbLines<1000) {
  #create points for circle 
  t=seq(0,2*pi,len=200);
  xp=r*cos(t); yp=r*sin(t);
  
  ### START Plotting START###
  #Solution A
  #plot.new();
  par(mfrow=c(1,2));
  par(pty="s"); #use square plotting region
  plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black',main='Segments of Solution A');
  #plot segments of Solution A
  segments(xxA1,yyA1,xxA2,yyA2,col='red'); 
  #draw circle
  par(pty="s"); #use square plotting region
  plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black',main='Midpoints of Solution A');
  #plot midpoints of Solution A
  points(xxA0,yyA0,pch=20,col='red');  
  
  #Solution B
  #plot.new();
  par(mfrow=c(1,2));
  par(pty="s"); #use square plotting region
  plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black',main='Segments of Solution B');
  #plot segments of Solution B
  segments(xxB1,yyB1,xxB2,yyB2,col='blue'); 
  #draw circle
  par(pty="s"); #use square plotting region
  plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black',main='Midpoints of Solution B');
  #plot midpoints of Solution B
  points(xxB0,yyB0,pch=20,col='blue'); 
  
  #Solution C
  #plot.new();
  par(mfrow=c(1,2));
  par(pty="s"); #use square plotting region
  plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black',main='Segments of Solution C');
  #plot segments of Solution C
  segments(xxC1,yyC1,xxC2,yyC2,col='green'); 
  #draw circle
  par(pty="s"); #use square plotting region
  plot(xx0+xp,yy0+yp,xlab='x',ylab='y',type="l", col='black',main='Midpoints of Solution C');
  #plot midpoints of Solution C
  points(xxC0,yyC0,pch=20,col='green'); 
  ###END Plotting END###
}