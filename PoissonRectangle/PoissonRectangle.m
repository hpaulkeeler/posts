%Simulate a Poisson point process on a rectangle
%Author: H. Paul Keeler, 2018.

%Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; %rectangle dimensions
areaTotal=xDelta*yDelta; %area of rectangle
 
%Point process parameters
lambda=100; %intensity (ie mean density) of the Poisson process
 
%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
xx=xDelta*(rand(numbPoints,1))+xMin;%x coordinates of Poisson points
yy=xDelta*(rand(numbPoints,1))+yMin;%y coordinates of Poisson points
 
%Plotting
scatter(xx,yy);
xlabel('x');ylabel('y');
