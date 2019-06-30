% Compares two methods for simulating a homogeneous Poisson point process,
% where the idea behind one method is faster than the other. In this code, 
% the two methods are labelled A and B.
%
% Method A simulates all the Poisson ensembles randomly by first randomly
% generating all the Poisson random variables in one step. It then randomly
% positions all the points (across all ensembles) in one step. All the
% points are then are then separated accordingly into ensembles.
%
% Method B iterates through a for-loop, and for each iteration, it randomly
% generates a Poisson variable and positions the points for each ensemble.
%
% Method A uses more vectorization than Method B so it should be faster 
% than Method B in general.
%
% Author: H. Paul Keeler, 2019.

%%%START Parameters START%%%
numbSim=10^6; %number of simulations

%Point process parameters
lambda=20; %intensity (ie mean density) of Poisson point process

%Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; %rectangle dimensions
areaTotal=xDelta*yDelta; %area of rectangle
massTotal=areaTotal*lambda;  %total measure/mass of the point process
%%%END Parameters END%%%

%%%START Simulation section START%%%
%%%START Method A: Generate *all* ensembles at once START%%%
tic;
numbPointsA=poissrnd(massTotal,numbSim,1);%Poisson number of points
numbPointsTotal=sum(numbPointsA);
%uniform x/y coordinates of Poisson points
xxAll=xDelta*(rand(numbPointsTotal,1))+xMin;%x coordinates of Poisson points
yyAll=yDelta*(rand(numbPointsTotal,1))+yMin;%y coordinates of Poisson points

%convert Poisson point processes into cells
xxCellA=mat2cell(xxAll,numbPointsA);
yyCellA=mat2cell(yyAll,numbPointsA);
toc;
%%%END Method A: Generate *all* ensembles at once END%%%

%%%START Method B: Generate each ensemble separately START%%%
tic;
xxCellB=cell(numbSim,1);yyCellB=cell(numbSim,1);
numbPointsB=zeros(numbSim,1);
%loop through for all ensembles
for ss=1:numbSim
    numbPointsTemp=poissrnd(massTotal);%Poisson number of points
    xxCellB{ss}=xDelta*(rand(numbPointsTemp,1))+xMin;%x coordinates of Poisson points
    yyCellB{ss}=yDelta*(rand(numbPointsTemp,1))+yMin;%y coordinates of Poisson points
    numbPointsB(ss)=numbPointsTemp;
end
toc;
%%%END Method B: Generate each ensemble separately END%%%
%%%END Simulation section   END%%%

% %%%START Create point pattern structures START%%%
% numbCellA=mat2cell(numbPointsA,ones(numbSim,1)); %cell for number of points
% numbCellB=mat2cell(numbPointsB,ones(numbSim,1)); %cell for number of points
% %create vector for describing the window
% windowSim=[xMin,xMax,yMin,yMax];
% %structure array for point patterns from Method A
% ppStructPoissonA=struct('x',xxCellA,'y',yyCellA,...
%     'n',numbCellA,'window',windowSim);
% %structure array for point patterns from Method B
% ppStructPoissonB=struct('x',xxCellB,'y',yyCellB,...
%     'n',numbCellB,'window',windowSim);
% %%%END Create point pattern structures END%%%
