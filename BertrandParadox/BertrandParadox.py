# Illustrate the three solutions of the Betrand paradox on a disk.
# The three solutions are labelled A, B and C, which correspond to
# solutions 1, 2 and 3 in, for example, the Wikipedia article:
# https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
# Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting
from matplotlib import collections  as mc #for plotting line segments

plt.close("all"); # close all figures

###START Parameters START###
#Simulation disk dimensions
xx0=0; yy0=0; #center of disk
r=1; #disk radius
numbLines=100;#number of lines
###END Parameters END###

###START Simulate three solutions on a disk START###
#Solution A
thetaA1=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly
thetaA2=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly

#calculate segment endpoints
xxA1=xx0+r*np.cos(thetaA1);
yyA1=yy0+r*np.sin(thetaA1);
xxA2=xx0+r*np.cos(thetaA2);
yyA2=yy0+r*np.sin(thetaA2);
#calculate midpoints of segments
xxA0=(xxA1+xxA2)/2; yyA0=(yyA1+yyA2)/2;

#Solution B
thetaB=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly
pB=r*np.random.uniform(0,1,numbLines); #choose radial component uniformly
qB=np.sqrt(r**2-pB**2); #distance to circle edge (alonge line)

#calculate trig values
sin_thetaB=np.sin(thetaB);
cos_thetaB=np.cos(thetaB);

#calculate segment endpoints
xxB1=xx0+pB*cos_thetaB+qB*sin_thetaB;
yyB1=yy0+pB*sin_thetaB-qB*cos_thetaB;
xxB2=xx0+pB*cos_thetaB-qB*sin_thetaB;
yyB2=yy0+pB*sin_thetaB+qB*cos_thetaB;
#calculate midpoints of segments
xxB0=(xxB1+xxB2)/2; yyB0=(yyB1+yyB2)/2;

#Solution C
#choose a point uniformly in the disk
thetaC=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly
pC=r*np.sqrt(np.random.uniform(0,1,numbLines)); #choose radial component
qC=np.sqrt(r**2-pC**2); #distance to circle edge (alonge line)

#calculate trig values
sin_thetaC=np.sin(thetaC);
cos_thetaC=np.cos(thetaC);

#calculate segment endpoints
xxC1=xx0+pC*cos_thetaC+qC*sin_thetaC;
yyC1=yy0+pC*sin_thetaC-qC*cos_thetaC;
xxC2=xx0+pC*cos_thetaC-qC*sin_thetaC;
yyC2=yy0+pC*sin_thetaC+qC*cos_thetaC;
#calculate midpoints of segments
xxC0=(xxC1+xxC2)/2; yyC0=(yyC1+yyC2)/2;
###END Simulate three solutions on a disk END###

#create points for circle 
t=np.linspace(0,2*np.pi,100);
xp=r*np.cos(t); yp=r*np.sin(t);

### START Plotting START###
#Segments
#Solution A
#draw circle
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp);
plt.axis('equal');
plt.xlabel('x'); plt.ylabel('y');
plt.title('Solution A');
#plot segments of Solution A
#need to create a list to plot the segments (probably a better way to do this)
segments=[]; #initiate list
for i in range(numbLines):
    segments.append([(xxA1[i],yyA1[i]),(xxA2[i],yyA2[i])]);    
lc = mc.LineCollection(segments,colors="red")
ax.add_collection(lc) #plot segments

#Solution B
#draw circle
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp);
plt.axis('equal');
plt.xlabel('x'); plt.ylabel('y');
plt.title('Solution B');
#plot segments of Solution B
#need to create a list to plot the segments (probably a better way to do this)
segments=[]; #initiate list
for i in range(numbLines):
    segments.append([(xxB1[i],yyB1[i]),(xxB2[i],yyB2[i])]);    
lc = mc.LineCollection(segments,colors='black')
ax.add_collection(lc) #plot segments

#Solution B
#draw circle
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp);
plt.axis('equal');
plt.xlabel('x'); plt.ylabel('y');
plt.title('Solution C');
#plot segments of Solution C
#need to create a list to plot the segments (probably a better way to do this)
segments=[]; #initiate list
for i in range(numbLines):
    segments.append([(xxC1[i],yyC1[i]),(xxC2[i],yyC2[i])]);    
lc = mc.LineCollection(segments,colors='green')
ax.add_collection(lc) #plot segments

#Midpoints
#Solution A
#draw circle
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp);
plt.axis('equal');
plt.xlabel('x'); plt.ylabel('y');
plt.title('Midpoints of Solution A');
#plot midpoints of Solution A
ax.scatter(xxA0,yyA0,s=5, edgecolor='r', facecolor='r');

#Solution B
#draw circle
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp);
plt.axis('equal');
plt.xlabel('x'); plt.ylabel('y');
plt.title('Midpoints of Solution B');
#plot midpoints of Solution B
ax.scatter(xxB0,yyB0,s=5, edgecolor='k', facecolor='k');

#Solution C
#draw circle
fig, ax = plt.subplots();
ax.plot(xx0+xp,yy0+yp);
plt.axis('equal');
plt.xlabel('x'); plt.ylabel('y');
plt.title('Midpoints of Solution C');
#plot midpoints of Solution C
ax.scatter(xxC0,yyC0,s=5, edgecolor='g', facecolor='g');
###END Plotting END###