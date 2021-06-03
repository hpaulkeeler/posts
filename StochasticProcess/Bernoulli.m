% Simulate a Bernoulli (stochastic) process
%
% Author: H. Paul Keeler, 2021.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% https://hpaulkeeler.com/stochastic-processes/

%%%START Parameters START%%%
%Bernoulli process parameter
p=0.5; %probability of a 1

%discrete time parameters
tFirst=1; %first time value
tLast=10; %last time value
numb_t=tLast-tFirst+1; %number of time points
%%%END Paramters END%%%

%create time values
tValues=(tFirst:tLast)'; %time vector

%%%START Create Bernoulli processes START%%%
xBernoulli=rand(numb_t,1)<p; %Boolean trials ie flip coins
%%%END Create Bernoulli processes END%%%

%%%START Plotting START%%%
plot(tValues,xBernoulli,'.','MarkerSize',50);
xlabel('T');
ylabel('S');
title('Bernoulli process');
ylim([-.1,1.2]); %set y-axis limits
%%%END Plotting END%%%