# Runs a simple Metropolis-Hastings (ie MCMC) algorithm to simulate two 
# jointly distributed random variables with probability density
# p(x,y)=exp(-(x^2+y^2)/s^2)/consNorm, where s>0 and consNorm is a
# normalization constant.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

library(gplots); #for histogram, plotting etc
library(pracma); #for integration etc
library(plot3D); #for 2-D plot etc
library(viridis);#for the purple heatmap colors/palette


rm(list=ls(all=TRUE)); #clear all variables
graphics.off(); #close all figures
cat("\014"); #clear screen

#Simulation window parameters
xMin=-1;xMax=1;
yMin=-1;yMax=1;

numbSim=10**5; #number of random variables simulated
numbSteps=25; #number of steps for the Markov process
numbBins=50; #number of bins for histogram
sigma=2; #standard deviation for normal random steps

#probability density parameters
s=.5; #scale parameter for distribution to be simulated
fun_lambda<-function(x,y){
  return (exp(-(x^2+y^2)/s^2));
  
  
}

#normalization constant
resultsInt=integral2(fun_lambda,xMin,xMax,yMin,yMax);
consNorm=resultsInt$Q;
#un-normalized joint density of variables to be simulated
fun_p<-function(x,y){
  return((fun_lambda(x,y))*(x>=xMin)*(y>=yMin)*(x<=xMax)*(y<=yMax));
}

xRand=runif(numbSim,xMin,xMax); #random initial values
yRand=runif(numbSim,yMin,yMax); #random initial values

pdfCurrent=fun_p(xRand,yRand); #current transition (probability) densities

for (jj in 1:numbSteps){
  zxRand= xRand +sigma*rnorm(numbSim,0,1);#take a (normally distributed) random step        
  zyRand= yRand +sigma*rnorm(numbSim,0,1);#take a (normally distributed) random step        
  #Conditional random step needs to be symmetric in x and y
  #For example: Z|x ~ N(x,1) (or Y=x+N(0,1)) with probability density
  #p(z|x)=e(-(z-x)^2/2)/sqrt(2*pi)    
  pdfProposal=fun_p(zxRand,zyRand); #proposed probability
  
  #acceptance rejection step
  booleAccept=runif(numbSim) < pdfProposal/pdfCurrent;
  #update state of random walk/Marjov chain
  xRand[booleAccept]=zxRand[booleAccept];
  yRand[booleAccept]=zyRand[booleAccept];
  #update transition (probability) densities
  pdfCurrent[booleAccept]=pdfProposal[booleAccept];
}

histXY <- hist2d(data.frame(xRand,yRand),nbins=numbSteps,show=FALSE);
xValues=histXY$x; #mid-points of bins
yValues=histXY$y  #mid-points of bins
areaBin=diff(histXY$x.breaks) %o% diff(histXY$y.breaks); #calculate areas of all bins/rectangles
p_Estimate=(histXY$counts)/numbSim/areaBin; #retrieve frequency count and normalize
meshXY= meshgrid(xValues,yValues); #create x/y matrices for plotting
X=(meshXY$X);Y=(meshXY$Y); 

#analytic solution of (normalized) joint probability density
p_Exact=fun_p(X,Y)/consNorm;

#Plotting
#Plot empirical estimate
persp3D(X,Y,p_Exact,theta=30, phi=50, axes=TRUE,scale=2, box=TRUE, col = viridis(100, option = "C"),
        ticktype="detailed",xlab="x", ylab="y", zlab="p(x,y)", 
        main="p(x,y) Exact Expression");

#Plot exact expression
dev.new();
persp3D(X,Y,p_Estimate,theta=30, phi=50, axes=TRUE,scale=2, box=TRUE, col = viridis(100, option = "C"),
        ticktype="detailed",xlab="x", ylab="y", zlab="p(x,y)", 
        main="p(x,y) Estimate");
