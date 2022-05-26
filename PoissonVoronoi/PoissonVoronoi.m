% This code generates a Voronoi-Poisson tessellation, meaning it generates
% a Poisson point process and then uses it to generate a corresponding 
% Voronoi tesselation. A Voronoi tesselation is also known as a Dirichlet
% tesselation or Voronoi diagram.
% 
% A (homogeneous) Poisson point process (PPP) is created on a rectangle.
% Then the Voronoi tesselation is found using the MATLAB function 
% voronoin[1], which is based on the Qhull project[2] .
%
% All points and Voronoi cells of the PPP are numbered arbitrarily.
%
% Author: H.Paul Keeler, 2019
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% https://hpaulkeeler.com/voronoi-dirichlet-tessellations/
%
% [1] http://www.mathworks.com.au/help/matlab/ref/voronoin.html
% [2] http://www.qhull.org/

clearvars; close all; clc;

%Simulation window parameters
xMin=0;
xMax=1;
yMin=0;
yMax=1;
%rectangle dimensions
xDelta=xMax-xMin; %width 
yDelta=yMax-yMin; %height
areaTotal=xDelta*yDelta; %area of simulation window

%Point process parameters
lambda=10; %intensity (ie mean density) of the Poisson process

%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
xx=xDelta*(rand(numbPoints,1))+xMin;%x coordinates of Poisson points
yy=yDelta*(rand(numbPoints,1))+yMin;%y coordinates of Poisson points

xxyy=[xx(:) yy(:)]; %combine x and y coordinates
%Perform Voronoi tesseslation using built-in function
[vertexAll,cellAll]=voronoin(xxyy); %retrieve vertex information
%above command not necessary for plotting

%%%START -- Plotting section -- START%%%
figure; hold on;
%create voronoi diagram on the point pattern
voronoi(xx,yy);
%plot underlying point pattern (ie a realization of a Poisson point process)
plot(xx,yy,'b.','MarkerSize',20);
%number/label the points/cells
labels=cellstr(num2str((1:numbPoints)'));%labels correspond to their order
text(xx, yy, labels, 'VerticalAlignment','bottom', ...
    'HorizontalAlignment','right');
%%%END -- Plotting section -- END%%%
