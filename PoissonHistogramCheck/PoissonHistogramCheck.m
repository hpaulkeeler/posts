%Simulate and check an inhomogeneous Poisson point process on a rectangle
%This is done by first simulating a homogeneous Poisson process, which is then
%thinned according to a (spatially *dependent*) p-thinning.
%Author: H. Paul Keeler, 2019.

close all;

%Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; %rectangle dimensions
areaTotal=xDelta*yDelta; %area of rectangle

s=.5; %scale parameter

%Point process parameters
fun_lambda=@(x,y)(80*exp(-((x+0.5).^2+(y+0.5).^2)/s^2)+100*exp(-((x-0.5).^2+(y-0.5).^2)/s^2));%intensity function

%%%START -- find maximum lambda -- START %%%
%For an intensity function lambda, given by function fun_lambda,
%finds the maximum of lambda in a rectangular region given by
%[xMin,xMax,yMin,yMax].
funNeg=@(x)(-fun_lambda(x(1),x(2))); %negative of lambda
%initial value(ie centre)
xy0=[(xMin+xMax)/2,(yMin+yMax)/2];%initial value(ie centre)
%Set up optimization step
options=optimoptions('fmincon','Display','off');
%Find largest lambda value
[~,lambdaNegMin]=fmincon(funNeg,xy0,[],[],[],[],...
    [xMin,yMin],[xMax,yMax],'',options);
lambdaMax=-lambdaNegMin;
%%%END -- find maximum lambda -- END%%%

%define thinning probability function
fun_p=@(x,y)(fun_lambda(x,y)/lambdaMax);

%for collecting statistics -- set numbSim=1 for one simulation
numbSim=10^4; %number of simulations
numbPointsRetained=zeros(numbSim,1); %vector to record number of points
xxCell=cell(numbSim,1); yyCell=cell(numbSim,1);
for ii=1:numbSim
%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambdaMax);%Poisson number of points
xx=xDelta*(rand(numbPoints,1))+xMin;%x coordinates of Poisson points
yy=xDelta*(rand(numbPoints,1))+yMin;%y coordinates of Poisson points

%calculate spatially-dependent thinning probabilities
p=fun_p(xx,yy);

%Generate Bernoulli variables (ie coin flips) for thinning
booleRetained=rand(numbPoints,1)<p; %points to be thinned

%x/y locations of retained points
xxRetained=xx(booleRetained); yyRetained=yy(booleRetained);

numbPointsRetained(ii)=length(xxRetained); %number of points
xxCell(ii)={xxRetained}; yyCell(ii)={yyRetained};
end

%Plotting
plot(xxRetained,yyRetained,'bo'); %plot retained points
xlabel('x');ylabel('y');

%total mean measure (average number of points)
LambdaNumerical=integral2(fun_lambda,xMin,xMax,yMin,yMax);
%Test: as numbSim increases, LambdaEmpirical converges to LambdaNumerical
LambdaEmpirical=mean(numbPointsRetained);

xxVectorAll=cell2mat(xxCell); yyVectorAll=cell2mat(yyCell);
xyAll=[xxVectorAll,yyVectorAll];
[p_Estimate,xxEdges,yyEdges]=histcounts2(xxVectorAll,yyVectorAll,40,'Normalization','pdf');
xxValues=(xxEdges(2:end)+xxEdges(1:end-1))/2;
yyValues=(yyEdges(2:end)+yyEdges(1:end-1))/2;
[X, Y]=meshgrid(xxValues,yyValues);
figure;
surf(X,Y,p_Estimate); colormap spring;
title('Estimate of \lambda(x) normalized'); 

p_Exact=fun_p(X,Y);
figure;
surf(X,Y,p_Exact);  colormap spring;
title('\lambda(x) normalized'); 
