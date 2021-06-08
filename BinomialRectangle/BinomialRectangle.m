% Simulate a binomial point process on a rectangle.
% Author: H. Paul Keeler, 2018.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

numbPoints=30; %number of points

%Simulation window parameters
xMin=0;
xMax=1;
yMin=0;
yMax=1;
%rectangle dimensions
xDelta=xMax-xMin;
yDelta=yMax-yMin; 

%Simulate binomial point process
xx=xDelta*rand(numbPoints,1)+xMin;%x coordinates of uniform points
yy=yDelta*rand(numbPoints,1)+yMin;%y coordinates of uniform points

%Plotting
scatter(xx,yy);
xlabel('x');ylabel('y');
