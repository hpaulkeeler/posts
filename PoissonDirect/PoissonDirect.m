% Author: H. Paul Keeler, 2019.
% hpaulkeeler.com/
% github.com/hpaulkeeler

mu=5; %Poisson parameter
numbSim=10^2; %number of simulations

muVector=mu*ones(numbSim,1);

%generate many Poisson variables
randPoissonLoop=arrayfun(@funPoissonLoop,muVector);
randPoissonRecursive=arrayfun(@funPoissonRecursive,muVector);

%calculate sample mean
meanPoissonLoop=mean(randPoissonLoop)
meanPoissonRecursive=mean(randPoissonRecursive)

%calculate sample variance
varPoissonLoop=var(randPoissonLoop)
varPoissonRecursive=var(randPoissonRecursive)

%%% START - Function definitions %%%

%Use while loop to generate Poisson variates
function N=funPoissonLoop(mu)
T=0; %initialize sum of exponential variables as zero
n=-1;%initialize counting variable as negative one

while (T<1)
    E=-(1/mu)*log(rand(1));%generate exponential random variable
    T=T+E; %update sum of exponential variables
    n=n+1; %update number of exponential variables
end
N=n;
end

%Use recursion to generate Poisson variates
function N=funPoissonRecursive(mu)
T=0; %initialize sum of exponential variables as zero
n=-1; %initialize counting variable as negative one

%run (recursive) exponential function step function
[~,N]=funStepExp(mu,T,n);

    function [T,N]=funStepExp(nu,S,m)
        if S<1
            %run if sum of exponential variables is not high enough
            
            %generate exponential random variable
            E=(-log(rand(1)))/nu;
            S=S+E; %update sum of exponential variables
            m=m+1; %update nunber of exponential variables
            
            %recursively call function again
            [T,N]=funStepExp(nu,S,m);
        else
            T=S;
            N=m;
        end
    end
end
%%% END - Function definitions %%%

