% Simulate a (homogeneous) Poisson stochastic process.
%
% Author: H. Paul Keeler, 2021.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
%

%rng(2);  %set random seed

%%%START Paramters START%%%
%Poisson stochastic process parameters
lambda=6;

%time parameters
tFirst=0; %first time value
tLast=1; %last time value
numb_t=10^3; %number of time points

numbPaths=1; %number of sample paths (ie realizations)
%%%END Paramters END%%%

%%%START Create Poisson stochastic processes START%%%
tLength=tLast-tFirst; %length of segment
numbPoiss=poissrnd(lambda*tLength);
tPoissJump=tFirst+tLength*rand(numbPoiss,1);

tPoissJump=sort(tPoissJump);
%process values
xPoiss0=0:numbPoiss;
xPoiss=xPoiss0(2:end);

tPoissJump0=[tFirst;tPoissJump]; %append last value
tPoissJump1=[tPoissJump;tLast]; %append last value

%%%END Create Poisson stochastic processes END%%%

%%%START Plotting START%%%
figure;
%draw jumps of Poisson process
plot(tPoissJump0,xPoiss0, 'b.','MarkerSize',16);
grid;
title("Poisson stochastic process");
xlabel("T");
ylabel("S");
hold on;

%draw additional blue lines
tFistTemp=tFirst;
tLastTemp=tPoissJump(1);
for jj=1:numbPoiss+1
    tTemp=[tFistTemp, tLastTemp];
    xTemp=[xPoiss0(jj),xPoiss0(jj)];
    plot(tTemp,xTemp,'b-');
    
    %don't update on the last loop
    if jj<numbPoiss+1
        tFistTemp=tLastTemp;
        tLastTemp=tPoissJump1(jj+1);
    end
end

%%draw points of discontinuity
%%plot(tPoissJump,xPoiss-1, 'bo','MarkerSize',10);
%draw Poisson point process corresponding to jumps
plot(tPoissJump,0, 'r.','MarkerSize',16);
%%%END Plotting END%%%
