%Simulate a Poisson point process on a rectangle.
%Then thin the Poisson point process according to a (spatially *dependent*) 
%p-thinning 
%Author: H. Paul Keeler, 2019.

close all;

%Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; %rectangle dimensions
areaTotal=xDelta*yDelta; %area of rectangle
 
%Point process parameters
lambda=100; %intensity (ie mean density) of the Poisson process

%Thinning probability parameters
sigma=0.5; %scale parameter for thinning probability function
%define thinning probability function
fun_p=@(s,x,y)(exp(-(x.^2+y.^2)/s^2)); 

%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
xx=xDelta*(rand(numbPoints,1))+xMin;%x coordinates of Poisson points
yy=xDelta*(rand(numbPoints,1))+yMin;%y coordinates of Poisson points

%calculate spatially-dependent thinning probabilities
p=fun_p(sigma,xx,yy); 

%Generate Bernoulli variables (ie coin flips) for thinning
booleThinned=rand(numbPoints,1)<p; %points to be thinned
booleRetained=~booleThinned; %points to be retained

%x/y locations of thinned points
xxThinned=xx(booleThinned); yyThinned=yy(booleThinned);
%x/y locations of retained points
xxRetained=xx(booleRetained); yyRetained=yy(booleRetained);

%Plotting
plot(xxRetained,yyRetained,'bo'); %plot retained points
hold on; plot(xxThinned,yyThinned,'ro'); %plot thinned points
xlabel('x');ylabel('y');
