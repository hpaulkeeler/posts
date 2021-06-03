% Simulate a simple random walk 
%
% Author: H. Paul Keeler, 2021.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% https://hpaulkeeler.com/stochastic-processes/

%%%START Parameters START%%%
%Random walk (or Bernoulli process) parameter
p=0.5; %probability of a +1 step

%discrete time parameters
tFirst=0; %first time value
tLast=15; %last time value
numb_t=tLast-tFirst+1; %number of time points
%%%END Paramters END%%%

%create time values
tValues=(tFirst:tLast)'; %time vector

%%%START Create random walk START%%%
xBernoulli=rand(numb_t,1)<p; %Boolean trials ie flip coins
xSteps=2*xBernoulli-1; %convert to -1/+1 steps
xSteps(1)=0; %start at zero
xWalk=cumsum(xSteps);
%%%END Create random walk END%%%

%%%START Plotting START%%%
plot(tValues,xWalk,'.','MarkerSize',50);
xlabel('T');
ylabel('S');
title('Random Walk');
%%%END Plotting END%%%