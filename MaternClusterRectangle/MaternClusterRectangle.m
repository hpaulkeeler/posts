% Simulate a Matern cluster point process on a rectangle.
% Author: H. Paul Keeler, 2018.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% hpaulkeeler.com/simulating-a-matern-cluster-point-process/

%Simulation window parameters
xMin=-.5;
xMax=.5;
yMin=-.5;
yMax=.5;

%Parameters for the parent and daughter point processes 
lambdaParent=10;%density of parent Poisson point process
lambdaDaughter=100;%mean number of points in each cluster
radiusCluster=0.1;%radius of cluster disk (for daughter points)

%Extended simulation windows parameters
rExt=radiusCluster; %extension parameter -- use cluster radius
xMinExt=xMin-rExt;
xMaxExt=xMax+rExt;
yMinExt=yMin-rExt;
yMaxExt=yMax+rExt;
%rectangle dimensions
xDeltaExt=xMaxExt-xMinExt;
yDeltaExt=yMaxExt-yMinExt;
areaTotalExt=xDeltaExt*yDeltaExt; %area of extended rectangle

%Simulate Poisson point process for the parents
numbPointsParent=poissrnd(areaTotalExt*lambdaParent,1,1);%Poisson number 
%x and y coordinates of Poisson points for the parent
xxParent=xMinExt+xDeltaExt*rand(numbPointsParent,1);
yyParent=yMinExt+yDeltaExt*rand(numbPointsParent,1);

%Simulate Poisson point process for the daughters (ie final poiint process)
numbPointsDaughter=poissrnd(lambdaDaughter,numbPointsParent,1); 
numbPoints=sum(numbPointsDaughter); %total number of points

%Generate the (relative) locations in polar coordinates by 
%simulating independent variables.
theta=2*pi*rand(numbPoints,1); %angular coordinates 
rho=radiusCluster*sqrt(rand(numbPoints,1)); %radial coordinates 

%Convert from polar to Cartesian coordinates
[xx0,yy0]=pol2cart(theta,rho);

%replicate parent points (ie centres of disks/clusters) 
xx=repelem(xxParent,numbPointsDaughter);
yy=repelem(yyParent,numbPointsDaughter);
%translate points (ie parents points are the centres of cluster disks)
xx=xx(:)+xx0;
yy=yy(:)+yy0;

%thin points if outside the simulation window
booleInside=((xx>=xMin)&(xx<=xMax)&(yy>=yMin)&(yy<=yMax));
%retain points inside simulation window
xx=xx(booleInside); 
yy=yy(booleInside); 

%Plotting
scatter(xx,yy);
shg;