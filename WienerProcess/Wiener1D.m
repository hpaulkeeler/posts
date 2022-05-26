% Simulate a 1-D Wiener (or Brownian motion) process
%
% Author: H. Paul Keeler, 2021.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% 

close all; clearvars; clc;

%%%START Paramters START%%%
%Brownian/Wiener process parameters
mu=0; %drift coefficient; mu=0 for a standard Brownian/Winer process
sigma=1; %standard deviation; sigma=1 for a standard Brownian/Winer process

%time parameters
tFirst=0; %first time value
tLast=1; %last time value
numb_t=10^3; %number of time points

numbPaths=2; %number of sample paths (ie realizations)
%%%END Paramters END%%%

%create time values
tValues=(linspace(tFirst,tLast,numb_t))'; %time vector
tDelta=tValues(2)-tValues(1); %step size

%%%START Create Brownian/Wiener processes START%%%
%First Brownian/Wiener process
xWienerSteps=mu*tDelta+sigma*sqrt(tDelta)...
    .*randn([numb_t,numbPaths]); %normally distributed steps
xWiener=cumsum(xWienerSteps); %find Wiener/Brownian process values
xWiener=xWiener-xWiener(1,:); %set initial value to zero 
%%%END Create Brownian/Wiener processes END%%%

%%%START Plotting START%%%
figure;
plot(tValues,xWiener);
grid;
title("Wiener (or Brownian motion) process");
xlabel("t");
%%%END Plotting END%%%
