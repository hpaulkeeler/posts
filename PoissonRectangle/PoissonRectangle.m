% Simulate a Poisson point process on a rectangle.
% Author: H. Paul Keeler, 2018.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% hpaulkeeler.com/poisson-point-process-simulation/

%Simulation window parameters
xMin=0;
xMax=1;
yMin=0;
yMax=1;
%rectangle dimensions
xDelta=xMax-xMin;
yDelta=yMax-yMin; 
areaTotal=xDelta*yDelta; %area of rectangle
 
%Point process parameters
lambda=100; %intensity (ie mean density) of the Poisson process
 
%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
xx=xDelta*(rand(numbPoints,1))+xMin;%x coordinates of binomial points
yy=yDelta*(rand(numbPoints,1))+yMin;%y coordinates of binomial points
 
%Plotting
scatter(xx,yy);
xlabel('x');ylabel('y');
