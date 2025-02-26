% Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

%helper function for plotting histogram of possibly Poisson data
function [meanEmp,varEmp,pmfEmp]=funPlotPoissonEmpPDF(X)

meanEmp=mean(X); %empirical mean of X
varEmp=var(X);

%do histogram to get empirical probability mass function
binEdges=(min(X):max(X+1))-0.5;
pmfEmp=histcounts(X,binEdges,'Normalization','pdf');

nValues=min(X):max((X)); % histogram range
%analytic solution of probability mass function
pmfExact=poisspdf(nValues,meanEmp);

%plotting
figure;
plot(nValues,pmfExact,'s');
hold on;
plot(nValues,pmfEmp,'+');
xlabel('n');ylabel('P(N=n)');
title('Probability mass functions');
legend('Exact','Empirical');

end