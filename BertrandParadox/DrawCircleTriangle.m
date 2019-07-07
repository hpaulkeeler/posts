% Illustrates the Betrand paradox with a triangle in circle.
% See, for example, the Wikipedia article:
% https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
% Author: H. Paul Keeler, 2019.

close all; clearvars; clc;


r=1; %circle radius
x0=0; y0=0; %centre of circle

%points for circle
t=linspace(0,2*pi,200);
xp=r*cos(t); yp=r*sin(t);

%angles of triangle corners
thetaTri1=2*pi*rand(1);
thetaTri2=thetaTri1+2*pi/3;
thetaTri3=thetaTri1-2*pi/3;
%points for equalateral triangle
xTri1=x0+r*cos(thetaTri1);y1=x0+r*sin(thetaTri1);
xTri2=x0+r*cos(thetaTri2);y2=x0+r*sin(thetaTri2);
xTri3=x0+r*cos(thetaTri3);y3=x0+r*sin(thetaTri3);

%angles of chords 
thetaChord1=2*pi*rand(1);
thetaChord2=2*pi*rand(1);
%points chord
xChord1=x0+r*cos(thetaChord1);yChord1=x0+r*sin(thetaChord1);
xChord2=x0+r*cos(thetaChord2);yChord2=x0+r*sin(thetaChord2);

%Plotting
%draw circle
plot(x0+xp,y0+yp,'k','LineWidth',2);hold on;
axis square; 
axis tight;
xticks([]);yticks([]);

%draw triangle
plot([xTri1,xTri2],[y1,y2],'k','LineWidth',2);
plot([xTri2,xTri3],[y2,y3],'k','LineWidth',2);
plot([xTri3,xTri1],[y3,y1],'k','LineWidth',2);

%draw chord
plot([xChord1,xChord2],[yChord1,yChord2],'r','LineWidth',2);
    