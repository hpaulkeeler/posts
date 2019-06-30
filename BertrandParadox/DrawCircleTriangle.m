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
theta1=2*pi*rand(1);
theta2=theta1+2*pi/3;
theta3=theta1-2*pi/3;
%points for equalateral triangle
x1=x0+r*cos(theta1);y1=x0+r*sin(theta1);
x2=x0+r*cos(theta2);y2=x0+r*sin(theta2);
x3=x0+r*cos(theta3);y3=x0+r*sin(theta3);

%Plotting
%draw circle
plot(x0+xp,y0+yp,'k','LineWidth',2);hold on;
axis square; 
axis tight;
xticks([]);yticks([]);

%draw triangle
plot([x1,x2],[y1,y2],'b','LineWidth',2);
plot([x2,x3],[y2,y3],'b','LineWidth',2);
plot([x3,x1],[y3,y1],'b','LineWidth',2);

    