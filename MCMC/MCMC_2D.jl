# Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate two 
# jointly distributed random variuables with probability density
# p(x,y)=exp(-(x^4+x*y+y^2)/s^2)/consNorm, where s>0 and consNorm is a
# normalization constant.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

#Note: Need the .+ for adding a scalar to an array
#Also need . for sqrt, exp, cos, sin etc and assinging scalars to arrays

using Distributions #for random simulations
using PyPlot #for plotting
using StatsBase #for histograms etc
using Random
using LinearAlgebra
using HCubature #for numerical integration
#using LaTeXStrings #for LateX in labels/titles etc
PyPlot.close("all");  # close all PyPlot figures

#set random seed for reproducibility
#Random.seed!(1234)

# Simulation window parameters
xMin = -1;
xMax = 1;
yMin = -1;
yMax = 1;

numbSim = 10 ^ 5;  # number of random variables simulated
numbSteps = 25;  # number of steps for the Markov process
numbBins = 50;  # number of bins for histogram
sigma = 2;  # standard deviation for normal random steps

# probability density parameters
s = .5;  # scale parameter for distribution to be simulated

function fun_lambda(x,y)
    return (exp.(-(x.^4+x.*y+y.^2)./s^2));
end

#normalization constant -- UNDER CONSTRUCTION
consNorm,errorCub=hcubature(x -> fun_lambda(x[1],x[2]), [xMin, yMin], [xMax, yMax]);
#un-normalized joint density of variables to be simulated
function fun_p(x,y)
    return((fun_lambda(x,y)).*(x.>=xMin).*(y.>=yMin).*(x.<=xMax).*(y.<=yMax));
end
xRand=(xMax-xMin).*rand(numbSim).+xMin; #random initial values
yRand=(yMax-yMin).*rand(numbSim).+yMin; #random initial values

pdfCurrent=fun_p(xRand,yRand); #current transition (probability) densities
for jj=1:numbSteps
    zxRand= xRand.+sigma.*rand(Normal(),numbSim);#take a (normally distributed) random step
    zyRand= yRand.+sigma.*rand(Normal(),numbSim);#take a (normally distributed) random step

    # Conditional random step needs to be symmetric in x and y
    # For example: Z|x ~ N(x,1) (or Y=x+N(0,1)) with probability density
    # p(z|x)=e(-(z-x)^2/2)/sqrt(2*pi)
    pdfProposal = fun_p(zxRand, zyRand);  # proposed probability

    # acceptance rejection step
    booleAccept=rand(numbSim) .< pdfProposal./pdfCurrent;
    # update state of random walk/Marjov chain
    xRand[booleAccept] = zxRand[booleAccept];
    yRand[booleAccept] = zyRand[booleAccept];
    # update transition (probability) densities
    pdfCurrent[booleAccept] = pdfProposal[booleAccept];
end

#histogram section: empirical probability density
histXY=fit(Histogram, (xRand,yRand),nbins=numbBins); #find histogram data
histXY=normalize(histXY,mode=:pdf); #normalize histogram
binEdges=histXY.edges; #retrieve bin edges
xValues=(binEdges[1][2:end]+binEdges[1][1:end-1])./2; #mid-points of bins
yValues=(binEdges[2][2:end]+binEdges[2][1:end-1])./2; #mid-points of bins
p_Estimate=(histXY.weights)
#create a meshgrid
X=[xValues[ii] for ii=1:length(xValues), jj=1:length(yValues)];
Y=[yValues[jj] for ii=1:length(xValues), jj=1:length(yValues)];

#analytic solution of (normalized) joint probability density
p_Exact = fun_p(X, Y)./consNorm;

# Plotting
# Plot empirical estimate
fig1 = PyPlot.figure();
PyPlot.rc("text", usetex=true);
PyPlot.rc("font", family="serif");
surf(X, Y, p_Estimate, cmap=PyPlot.cm.plasma);
PyPlot.xlabel("x");
PyPlot.ylabel("y");
PyPlot.title("p(x,y) Estimate");

# Plot exact expression
fig2 = PyPlot.figure();
PyPlot.rc("text", usetex=true);
PyPlot.rc("font", family="serif")
surf(X, Y, p_Exact, cmap=PyPlot.cm.plasma);
PyPlot.xlabel("x");
PyPlot.ylabel("y");
PyPlot.title("p(x,y) Exact Expression");

#println("The program has completed.")
