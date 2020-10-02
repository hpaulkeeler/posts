# Runs a simple Metropolis-Hastings (ie MCMC) algoritm to simulate an
# exponential distribution, which has the probability density
# p(x)=exp(-x/m), where m>0.
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

numbSim=10^4; #number of random variables simulated
numbSteps=25; #number of steps for the Markov process
numbBins=50; #number of bins for histogram

sigma=1; #standard deviation for normal random steps
m=2; #parameter (ie mean) for distribution to be simulated

fun_p<-function(x){
  return((exp(-x/m)/m)*(x>=0)); #intensity function
  
}

xRand=runif(numbSim); #random initial values
probCurrent=fun_p(xRand); #current transition probabilities

for (jj in 1:numbSteps){
  zRand<-xRand +sigma*rnorm(numbSim,0,1);#take a (normally distributed) random step        
  #zRand= xRand +2*sigma*runif(numbSim);#take a (uniformly distributed) random step    
  probProposal=fun_p(zRand); #proposed probability
  
  #acceptance rejection step
  booleAccept=runif(numbSim) < probProposal/probCurrent;
  #update state of random walk/Markov chain
  xRand[booleAccept]=zRand[booleAccept];
  #update transition probabilities
  probCurrent[booleAccept]=probProposal[booleAccept];
}
#histogram section: empirical probability density
histX<-hist(xRand,breaks=numbBins,plot=FALSE);    
binEdges=histX$breaks; #retrieve bin edges
pdfEmp=histX$density; #retrieve probability density
xValues=histX$mids; ##retrieve mid-points of bins

#analytic solution of probability density
pdfExact=fun_p(xValues);

#Plotting
plot(xValues,pdfExact,xlab='x',ylab='p(x)',type="l", col='blue');
points(xValues,pdfEmp,pch=4, col='red');
grid;
