#Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate an
#exponential distribution, which has the probability density
#p(x)=exp(-x/m^2), where m>0.
#
#Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays

#clearconsole(); #for clearing Julia REPL console

using Distributions #for random simulations
using PyPlot #for plotting
using StatsBase #for histograms etc
using Random
using LinearAlgebra
PyPlot.close("all");  # close all PyPlot figures

#set random seed for reproducibility
#Random.seed!(1234)

numbSim=10^4; #number of random variables simulated
numbSteps=25; #number of steps for the Markov process
numbBins=50; #number of bins for histogram

sigma=1; #standard deviation for normal random steps
m=2; #parameter (ie mean) for distribution to be simulated

function fun_p(x)
    return ((exp.(-x./m)./m).*(x.>0));
end

xRand=rand(numbSim); #random intial values
pdfCurrent=fun_p(xRand); #current transition (probability) densities

for jj=1:numbSteps
    zRand= xRand.+sigma.*rand(Normal(),numbSim);#take a (normally distributed) random step
    #zRand= xRand +2*sigma*(rand(size(xRand))-0.5);#take a (uniformly distributed) random step
    pdfProposal=fun_p(zRand); #proposed probability

    #acceptance rejection step
    booleAccept=rand(numbSim) .< pdfProposal./pdfCurrent;
    #update state of random walk/Markov chain
    xRand[booleAccept]=zRand[booleAccept];
    #update transition (probability) densities
    pdfCurrent[booleAccept]=pdfProposal[booleAccept];

end

#histogram section: empirical probability density
histX=fit(Histogram, xRand,nbins=numbBins); #find histogram data
histX=normalize(histX,mode=:pdf); #normalize histogram
binEdges=histX.edges; #retrieve bin edges
xValues=(binEdges[1][2:end]+binEdges[1][1:end-1])./2; #mid-points of bins
pdfEmp=(histX.weights)
#analytic solution of probability density
pdfExact=fun_p(xValues);

# Plotting
PyPlot.plot(xValues, pdfExact)
PyPlot.scatter(xValues, pdfEmp, marker="x", c="r");
PyPlot.grid(true);
PyPlot.xlabel("x");
PyPlot.ylabel("p(x)");
PyPlot.show();
