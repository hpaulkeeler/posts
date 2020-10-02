%Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate an
%exponential distribution, which has the probability density
%p(x)=exp(-x/m^2), where m>0.
%
%Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

clearvars;clc;close all;

numbSim=10^4; %number of random variables simulated
numbSteps=25; %number of steps for the Markov process
numbBins=50; %number of bins for histogram

sigma=1; %standard deviation for normal random steps
m=2; %parameter (ie mean) for distribution to be simulated
fun_p=@(x)((exp(-x/m)/m).*(x>=0));

xRand=rand(numbSim,1); %random initial values
probCurrent=fun_p(xRand); %current transition probabilities

for jj=1:numbSteps
    zRand= xRand +sigma*randn(size(xRand));%take a (normally distributed) random step
    %zRand= xRand +2*sigma*(rand(size(xRand))-0.5);%take a (uniformly distributed) random step    
    probProposal=fun_p(zRand); %proposed probability
    
    %acceptance rejection step
    booleAccept=rand(numbSim,1) < probProposal./probCurrent;
    %update state of random walk/Markov chain
    xRand(booleAccept)=zRand(booleAccept);
    %update transition probabilities
    probCurrent(booleAccept)=probProposal(booleAccept);
    
end

%histogram section: empirical probability density
[pdfEmp,binEdges]=histcounts(xRand,numbBins,'Normalization','pdf');
xValues=(binEdges(2:end)+binEdges(1:end-1))/2; %mid-points of bins

%analytic solution of probability density
pdfExact=fun_p(xValues);

%Plotting
plot(xValues,pdfExact);
hold on;
plot(xValues,pdfEmp,'rx'); 
grid;
xlabel('x'); ylabel('p(x)');