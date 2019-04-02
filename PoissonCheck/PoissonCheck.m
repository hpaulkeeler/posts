%Simulate and check an inhomogeneous Poisson point process on a rectangle
%This is done by first simulating a homogeneous Poisson process, which is 
%then thinned according to a (spatially *dependent*) p-thinning.
%The intensity function is
%lambda(x,y)=80*exp(-(x^2+y^2)/s^2)+100*exp(-(x^2+y^2)/s^2), where s>0.
%The simulations are then checked by examining the statistics of the number 
%of points and the locations of points (using histograms)
%Author: H. Paul Keeler, 2019.

close all; %close all plots

%Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; %rectangle dimensions
areaTotal=xDelta*yDelta; %area of rectangle

numbSim=10^4; %number of simulations
numbBins=30; %number of bins for histogram

%Point process parameters
s=.5; %scale parameter
%intensity function
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
numbPointsRetained=zeros(numbSim,1); %vector to record number of points
xxCell=cell(numbSim,1); yyCell=cell(numbSim,1);
%%% START -- Simulation section -- START %%%
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
%%% END -- Simulation section -- END %%%

%Plotting simulation
plot(xxRetained,yyRetained,'bo'); %plot retained points
xlabel('x');ylabel('y');

%%%START -- Checking number of points -- START%%%
%total mean measure (average number of points)
LambdaNumerical=integral2(fun_lambda,xMin,xMax,yMin,yMax);
%Test: as numbSim increases, numbPointsMean converges to LambdaNumerical
numbPointsMean=mean(numbPointsRetained)
%Test: as numbSim increases, numbPointsVar converges to LambdaNumerical
numbPointsVar=var(numbPointsRetained)

%histogram section: empirical probability mass function
binEdges=(min(numbPointsRetained):max((numbPointsRetained)+1))-0.5;
pdfEmp=histcounts(numbPointsRetained,binEdges,'Normalization','pdf');

nValues=min(numbPointsRetained):max((numbPointsRetained));
%analytic solution of probability density
pdfExact=poisspdf(nValues,LambdaNumerical);

%Plotting
figure;
plot(nValues,pdfExact,'s');
hold on;
plot(nValues,pdfEmp,'+');
xlabel('n');ylabel('P(N=n)');
legend('Exact','Empirical');
%%%END -- Checking number of points -- END%%%

%%%START -- Checking locations -- START%%%
%2-D Histogram section
xxVectorAll=cell2mat(xxCell); yyVectorAll=cell2mat(yyCell);
xyAll=[xxVectorAll,yyVectorAll];
[p_Estimate,xxEdges,yyEdges]=histcounts2(xxVectorAll,yyVectorAll,numbBins,'Normalization','pdf');
xxValues=(xxEdges(2:end)+xxEdges(1:end-1))/2;
yyValues=(yyEdges(2:end)+yyEdges(1:end-1))/2;
[X, Y]=meshgrid(xxValues,yyValues);

%analytic solution of probability density
p_Exact=fun_p(X,Y);

%Plot empirical estimate
figure;
subplot(2,1,1);
surf(X,Y,p_Estimate); colormap spring;
xlabel("x"); ylabel("y");
title('Estimate of \lambda(x) normalized');

%Plot exact expression
subplot(2,1,2);
surf(X,Y,p_Exact);  colormap spring;
xlabel("x"); ylabel("y");
title('\lambda(x) normalized');

%%%END -- Checking locations -- END%%%
