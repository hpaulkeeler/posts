%Simulate a Thomas cluster point process on a rectangle.
%Author: H. Paul Keeler, 2018.

%Simulation window parameters
xMin=-.5;
xMax=.5;
yMin=-.5;
yMax=.5;

%Parameters for the parent and daughter point processes 
lambdaParent=10;%density of parent Poisson point process
lambdaDaughter=100;%mean number of points in each cluster
sigma=0.05;%sigma for normal variables (ie random locations) of daughters

%Extended simulation windows parameters
rExt=6*sigma; %extension parameter -- use factor of deviation
%for rExt, use factor of deviation sigma eg 5 or 6
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

%Generate the (relative) locations in Cartesian coordinates by 
%simulating independent normal variables
xx0=normrnd(0,sigma,numbPoints,1);
yy0=normrnd(0,sigma,numbPoints,1);

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