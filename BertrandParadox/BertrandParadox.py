# Illustrate the three solutions of the Bertrand paradox on a disk.
# The three solutions are labelled A, B and C, which correspond to
# solutions 1, 2 and 3 in, for example, the Wikipedia article:
# https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
# Author: H. Paul Keeler, 2019.

import numpy as np; #NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt #for plotting
from matplotlib import collections  as mc #for plotting line chords

plt.close("all"); # close all figures

###START Parameters START###
#Simulation disk dimensions
xx0=0; yy0=0; #center of disk
r=1; #disk radius
numbLines=10**2;#number of lines
###END Parameters END###

###START Simulate three solutions on a disk START###
#Solution A
thetaA1=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly
thetaA2=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly

#calculate chord endpoints
xxA1=xx0+r*np.cos(thetaA1);
yyA1=yy0+r*np.sin(thetaA1);
xxA2=xx0+r*np.cos(thetaA2);
yyA2=yy0+r*np.sin(thetaA2);
#calculate midpoints of chords
xxA0=(xxA1+xxA2)/2; yyA0=(yyA1+yyA2)/2;

#Solution B
thetaB=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly
pB=r*np.random.uniform(0,1,numbLines); #choose radial component uniformly
qB=np.sqrt(r**2-pB**2); #distance to circle edge (alonge line)

#calculate trig values
sin_thetaB=np.sin(thetaB);
cos_thetaB=np.cos(thetaB);

#calculate chord endpoints
xxB1=xx0+pB*cos_thetaB+qB*sin_thetaB;
yyB1=yy0+pB*sin_thetaB-qB*cos_thetaB;
xxB2=xx0+pB*cos_thetaB-qB*sin_thetaB;
yyB2=yy0+pB*sin_thetaB+qB*cos_thetaB;
#calculate midpoints of chords
xxB0=(xxB1+xxB2)/2; yyB0=(yyB1+yyB2)/2;

#Solution C
#choose a point uniformly in the disk
thetaC=2*np.pi*np.random.uniform(0,1,numbLines); #choose angular component uniformly
pC=r*np.sqrt(np.random.uniform(0,1,numbLines)); #choose radial component
qC=np.sqrt(r**2-pC**2); #distance to circle edge (alonge line)

#calculate trig values
sin_thetaC=np.sin(thetaC);
cos_thetaC=np.cos(thetaC);

#calculate chord endpoints
xxC1=xx0+pC*cos_thetaC+qC*sin_thetaC;
yyC1=yy0+pC*sin_thetaC-qC*cos_thetaC;
xxC2=xx0+pC*cos_thetaC-qC*sin_thetaC;
yyC2=yy0+pC*sin_thetaC+qC*cos_thetaC;
#calculate midpoints of chords
xxC0=(xxC1+xxC2)/2; yyC0=(yyC1+yyC2)/2;
###END Simulate three solutions on a disk END###

###START Do some statistics on chord lengths START###
lengthSide=r*np.sqrt(3); #length of triangle side
#chord lengths
lengthA=np.hypot(xxA1-xxA2,yyA1-yyA2); #Method A
lengthB=np.hypot(xxB1-xxB2,yyB1-yyB2); #Method B
lengthC=np.hypot(xxC1-xxC2,yyC1-yyC2); #Method C

#estimated probability of chord being longer than triangle side
probEstA=np.mean(lengthA>lengthSide) #Method A
probEstB=np.mean(lengthB>lengthSide) #Method B
probEstC=np.mean(lengthC>lengthSide) #Method C
###END Do some statistics on chord lengths END###

#Plot if there are less than a thousand lines.
if numbLines<1000:
    #create points for circle 
    t=np.linspace(0,2*np.pi,200);
    xp=r*np.cos(t); yp=r*np.sin(t);
    
    ### START Plotting START###
    #Solution A
    #draw circle
    fig, ax = plt.subplots(1,2);
    ax[0].plot(xx0+xp,yy0+yp,color='k');
    ax[0].axis('equal');
    ax[0].set_xlabel('x'); ax[0].set_ylabel('y');
    ax[0].set_title('chords of Solution A');
    #plot chords of Solution A
    #need to create a list to plot the chords (probably a better way to do this)
    chordsA=[[(xxA1[i],yyA1[i]),(xxA2[i],yyA2[i])] for i in range(numbLines)];
    lc = mc.LineCollection(chordsA,colors='r');
    ax[0].add_collection(lc) #plot chords of Solution A
    #draw circle
    ax[1].plot(xx0+xp,yy0+yp,color='k');
    ax[1].axis('equal');
    ax[1].set_xlabel('x'); ax[1].set_ylabel('y');
    ax[1].set_title('Midpoints of Solution A');
    #plot midpoints of Solution A
    ax[1].plot(xxA0,yyA0,'r.');
    
    #Solution B
    #draw circle
    fig, ax = plt.subplots(1,2);
    ax[0].plot(xx0+xp,yy0+yp,color='k');
    ax[0].axis('equal');
    ax[0].set_xlabel('x'); ax[0].set_ylabel('y');
    ax[0].set_title('chords of Solution B');
    #plot chords of Solution B
    #need to create a list to plot the chords (probably a better way to do this)
    chordsB=[[(xxB1[i],yyB1[i]),(xxB2[i],yyB2[i])] for i in range(numbLines)];
    lc = mc.LineCollection(chordsB,colors='b');
    ax[0].add_collection(lc) #plot chords of Solution B
    #draw circle
    ax[1].plot(xx0+xp,yy0+yp,color='k');
    ax[1].axis('equal');
    ax[1].set_xlabel('x'); ax[1].set_ylabel('y');
    ax[1].set_title('Midpoints of Solution B');
    #plot midpoints of Solution B
    ax[1].plot(xxB0,yyB0,'b.');
    
    #Solution C
    #draw circle
    fig, ax = plt.subplots(1,2);
    ax[0].plot(xx0+xp,yy0+yp,color='k');
    ax[0].axis('equal');
    ax[0].set_xlabel('x'); ax[0].set_ylabel('y');
    ax[0].set_title('chords of Solution C');
    #plot chords of Solution C
    #need to create a list to plot the chords (probably a better way to do this)
    chordsC=[[(xxC1[i],yyC1[i]),(xxC2[i],yyC2[i])] for i in range(numbLines)];   
    lc = mc.LineCollection(chordsC,colors='g');
    ax[0].add_collection(lc) #plot chords of Solution C
    #draw circle
    ax[1].plot(xx0+xp,yy0+yp,color='k');
    ax[1].axis('equal');
    ax[1].set_xlabel('x'); ax[1].set_ylabel('y');
    ax[1].set_title('Midpoints of Solution C');
    #plot midpoints of Solution C
    ax[1].plot(xxC0,yyC0,'g.');
    ###END Plotting END###
