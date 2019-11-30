#Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate two 
#jointly distributed random variuables with probability density
#p(x,y)=exp(-(x^2+y^2)/s^2)/consNorm, where s>0 and consNorm is a
#normalization constant.
#
#Author: H. Paul Keeler, 2019.

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

fun_p<-function(x,y){
  return((fun_lambda(x,y)/consNorm)*(x>=xMin)*(y>=yMin)*(x<=xMax)*(y<=yMax));
}

xRand=runif(numbSim,xMin,xMax); #random initial values
yRand=runif(numbSim,yMin,yMax); #random initial values

probCurrent=fun_p(xRand,yRand); #current transition probabilities

for (jj in 1:numbSteps){
  zxRand= xRand +sigma*rnorm(numbSim,0,1);#take a (normally distributed) random step        
  zyRand= yRand +sigma*rnorm(numbSim,0,1);#take a (normally distributed) random step        
  #Conditional random step needs to be symmetric in x and y
  #For example: Z|x ~ N(x,1) (or Y=x+N(0,1)) with probability density
  #p(z|x)=e(-(z-x)^2/2)/sqrt(2*pi)    
  probProposal=fun_p(zxRand,zyRand); #proposed probability
  
  #acceptance rejection step
  booleAccept=runif(numbSim) < probProposal/probCurrent;
  #update state of random walk/Marjov chain
  xRand[booleAccept]=zxRand[booleAccept];
  yRand[booleAccept]=zyRand[booleAccept];
  #update transition probabilities
  probCurrent[booleAccept]=probProposal[booleAccept];
}

histXY <- hist2d(data.frame(xRand,yRand),nbins=numbSteps,show=FALSE);
xValues=histXY$x; #mid-points of bins
yValues=histXY$y  #mid-points of bins
areaBin=diff(histXY$x.breaks) %o% diff(histXY$y.breaks); #calculate areas of all bins/rectangles
p_Estimate=(histXY$counts)/numbSim/areaBin; #retrieve frequency count and normalize
meshXY= meshgrid(xValues,yValues); #create x/y matrices for plotting
X=(meshXY$X);Y=(meshXY$Y); 

#analytic solution of probability density
p_Exact=(fun_p(X,Y));

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