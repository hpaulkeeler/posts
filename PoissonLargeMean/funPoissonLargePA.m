% This code generates Poisson variates (or simulates Poisson variables).
% using a method designed for large (>30) Poisson parameter values.
%
% The generation method is Algorithm PA, a type of rejection method, from 
% the paper:
%
% 1979 - Atkinson - "The Computer Generation of Poisson Random Variables"
%
% WARNING: This code is for illustration purposes only.
%
% In practice, you should *always* use the buil-in MATLAB function
% poissrnd, which (for large Poisson parameter) uses Algorithm PG in the
% paper:
%
% 1974 - Ahrens, Dieter - "Computer methods for sampling from gamma, beta,
% poisson and bionomial distributions".
%
% That method is also suggested by Knuth in Volume 2 of his classic
% series "The Art of Computer Programming".
%
% INPUT:
% mu is a Poisson parameter (or mean) such that mu>=0.
% OUTPUT:
% result_k is a Poisson variate (that is, an instance of a Poisson random
% variable), which is a non-negative integer.
%
% The generation method is the Rejection method (PA) from the paper:
%
% 1979 - Atkinson - "The Computer Generation of Poisson Random Variables"
%
% Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

function result_n=funPoissonLargePA(mu)
%precalculate some Poisson-parameter-dependent numbers
c = 0.767 - 3.36/mu;
beta = pi/sqrt(3.0*mu);
alpha = beta*mu;
k = log(c) - mu - log(beta);
log_mu=log(mu);

result_n=-1; %initialize the Poisson random variable (or variate)
while (result_n<0)
    U = rand(); %generate first uniform variable
    x = (alpha - log((1.0 - U)/U))/beta;


    if (x <-.5)
        continue
    else
        V = rand(); %generate second uniform variable
        n = floor(x+.5);
        y = alpha - beta*x;
        %logfac_n=getLogFac(n);
        %above can be replaced with MATLAB's function: 
        logfac_n=gammaln(n+1);

        %two sides of an inequality condition
        lhs = y + log(V/(1.0 + exp(y))^2);
        rhs = k + n*log_mu- logfac_n; % NOTE: uses log factorial n

        if (lhs <= rhs)
            result_n=n;
            return;
        else
            continue;
        end
    end
end

end