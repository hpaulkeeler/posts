% This code runs a Poisson variable generating function and then performs a
% chi-squared test to see whethe the function generated sufficently Poisson
% values.
%
% Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

close all; clearvars; clc;

mu=30; %Poisson parameter (ie its mean)
boolePlotResults=1;

numbSim=10^6; %number of samples/simulations

%sample using given Poisson function
X=zeros(1,numbSim);
for ss=1:numbSim
    X(ss)=funPoissonLargePTRS(mu);
end

%plot results
if boolePlotResults
    funPlotPoissonEmpPDF(X);
end

meanX=mean(X); %unbiased mean
varX=var(X); %unbiased variance
ratioMeanVarX=meanX/varX; %a Poisson distribution implies value of one
disp("The mean of X is " + num2str(meanX) + ".");
disp("The variance X is " + num2str(varX) + ".");

%do histogram to get empirical probability mass function
binsX=min(X):max(X);
countsObserved=histcounts(X,'BinMethod','integers');
countsExpected=poisspdf(binsX,meanX); %use sample mean
%rescale so countsExpected and countsObserved have the same total sum
countsExpected=countsExpected/sum(countsExpected)*sum(countsObserved);

%perform chi-squared test
booleChiSquaredTest= chi2gof(binsX,'Ctrs',binsX,...
    'Frequency',countsObserved, ...
    'Expected',countsExpected,...
    'NParams',1);
disp("The null hypothesis is that the data came from a Poisson distribution with mean of X.");
if booleChiSquaredTest
    disp("The chi-squared test rejected the null hypothesis.");
    disp("It's likely that the data came from different distributions.")
else
    disp('The chi-squared test did not reject the null hypothesis.');
    disp("Perhaps the data came from the same distribution.");
end