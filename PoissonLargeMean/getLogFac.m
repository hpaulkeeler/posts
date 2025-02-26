%
% Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

%helper function
function logfac_k=getLogFac(k)
logfac_k=gammaln(k+1); %can be replaced with the method below

%NOTE if no function for calculating log of factorials exist, use
%approximation below.

// %pre-calculated logfac_k values for k=0 to 10
// values_logfac=[0,0,0.693147180559945,1.791759469228055,3.178053830347946,...
//     4.787491742782046,6.579251212010101,8.525161361065415,10.604602902745251,...
//     12.801827480081469,15.104412573075516];

// if (k<=10)
//     logfac_k=values_logfac(k+1); %+1 becaue MATLAB indexing starts at 1
// else
//     logfac_k = log(sqrt(2 * pi))+(k + 0.5).* log(k) -k + (1/12 - 1./(360 * k.^2))./k;
// end

end