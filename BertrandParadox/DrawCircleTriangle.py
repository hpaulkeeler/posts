# Illustrates the Betrand paradox with a triangle in circle.
# See, for example, the Wikipedia article:
# https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
# Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting
from matplotlib import collections  as mc #for plotting line segments

plt.close("all"); # close all figures

r=1; #circle radius
x0=0; y0=0; #centre of circle

#points for circle
t=np.linspace(0,2*np.pi,200);
xp=r*np.cos(t); yp=r*np.sin(t);

#angles of triangle corners
theta1=2*np.pi*np.random.uniform(1);
theta2=theta1+2*np.pi/3;
theta3=theta1-2*np.pi/3;
#points for equalateral triangle
x1=x0+r*np.cos(theta1);y1=x0+r*np.sin(theta1);
x2=x0+r*np.cos(theta2);y2=x0+r*np.sin(theta2);
x3=x0+r*np.cos(theta3);y3=x0+r*np.sin(theta3);

#Plotting
#draw circle
plt.plot(x0+xp,y0+yp,'k',linewidth=2);
plt.axis('equal');
plt.autoscale(enable=True, axis='x', tight=True)
plt.axis('off');


#draw triangle
plt.plot([x1,x2],[y1,y2],'b',linewidth=2);
plt.plot([x2,x3],[y2,y3],'b',linewidth=2);
plt.plot([x3,x1],[y3,y1],'b',linewidth=2);
