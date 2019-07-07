# Illustrates the Betrand paradox with a triangle in circle.
# See, for example, the Wikipedia article:
# https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
# Author: H. Paul Keeler, 2019.

r=1; #circle radius
x0=0; y0=0; #centre of circle

#points for circle
t=seq(0,2*pi,len=200);
xp=r*cos(t); yp=r*sin(t);

#angles of triangle corners
thetaTri1=2*pi*runif(1);
thetaTri2=thetaTri1+2*pi/3;
thetaTri3=thetaTri1-2*pi/3;
#points for equalateral triangle
xTri1=x0+r*cos(thetaTri1);yTri1=x0+r*sin(thetaTri1);
xTri2=x0+r*cos(thetaTri2);yTri2=x0+r*sin(thetaTri2);
xTri3=x0+r*cos(thetaTri3);yTri3=x0+r*sin(thetaTri3);

#angles of chords 
thetaChord1=2*pi*runif(1);
thetaChord2=2*pi*runif(1);
#points chord
xChord1=x0+r*cos(thetaChord1);yChord1=x0+r*sin(thetaChord1);
xChord2=x0+r*cos(thetaChord2);yChord2=x0+r*sin(thetaChord2);

#Plotting
#draw circle
par(pty="s"); #use square plotting region
plot(x0+xp,y0+yp,type="l", col='black');

#draw triangle
lines(c(xTri1,xTri2),c(yTri1,yTri2));
lines(c(xTri2,xTri3),c(yTri2,yTri3));
lines(c(xTri3,xTri1),c(yTri3,yTri1));

#draw chord
lines(c(xChord1,xChord2),c(yChord1,yChord2),col='red');