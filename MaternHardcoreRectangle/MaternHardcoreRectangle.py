#Simulate Matern hard-core point processes (Type I/II) on a rectangle.
#Author: H. Paul Keeler, 2019.

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # For plotting

plt.close('all');  # close all figures

numbSim=10**3; #number of simulations

# Simulation window parameters
xMin = -.5;
xMax = .5;
yMin = -.5;
yMax = .5;

#Parameters for the parent and daughter point processes
lambdaPoisson=10;#density of underlying Poisson point process
radiusCore=0.1;#radius of hard core

#Extended simulation windows parameters
rExt=radiusCore; #extension parameter -- use core radius
xMinExt=xMin-rExt;
xMaxExt=xMax+rExt;
yMinExt=yMin-rExt;
yMaxExt=yMax+rExt;
#rectangle dimensions
xDeltaExt=xMaxExt-xMinExt;
yDeltaExt=yMaxExt-yMinExt;
areaTotalExt=xDeltaExt*yDeltaExt; #area of extended rectangle

###START Simulations START####
#initialize arrays for collecting statistics
numbPointsAll=np.zeros(numbSim); #number of Poisson points
numbPointsAll_I=np.zeros(numbSim); #number of Matern I points
numbPointsAll_II=np.zeros(numbSim); #number of Matern II points
#loop through for each simulation
for ss in range(numbSim):
    
    #Simulate Poisson point process for the parents
    numbPointsExt= np.random.poisson(areaTotalExt*lambdaPoisson);#Poisson number
    #x and y coordinates of Poisson points for the parent
    xxPoissonExt=xMinExt+xDeltaExt*np.random.rand(numbPointsExt);
    yyPoissonExt=yMinExt+yDeltaExt*np.random.rand(numbPointsExt);
    
    #thin points if outside the simulation window
    booleWindow=((xxPoissonExt>=xMin)&(xxPoissonExt<=xMax)&(yyPoissonExt>=yMin)&(yyPoissonExt<=yMax));
    indexWindow=np.arange(numbPointsExt)[booleWindow];
    #retain points inside simulation window
    xxPoisson=xxPoissonExt[booleWindow];
    yyPoisson=yyPoissonExt[booleWindow];
    
    numbPoints=len(xxPoisson); #number of Poisson points in window
    #create random marks for ages
    markAge=np.random.rand(numbPointsExt);
    
    ###START Removing/thinning points START###
    booleRemoveI=np.zeros(numbPoints, dtype=bool);#Index for removing points -- Matern I
    booleKeepII=np.zeros(numbPoints,dtype=bool);#Index for keeping points -- Matern II
    for ii in range(numbPoints):
        distTemp=np.hypot(xxPoisson[ii]-xxPoissonExt,yyPoisson[ii]-yyPoissonExt);  #distances to other points        
        booleInDisk=(distTemp<radiusCore)&(distTemp>0); #check if inside disk
        
        #Matern I
        booleRemoveI[ii]=any(booleInDisk);
        
        #Matern II
        #keep the younger points
        if len(markAge[booleInDisk])==0:
            booleKeepII[ii]=True;
            #Note: if markAge(booleInDisk) is empty, keepBooleII[ii]=True.
        else:
            booleKeepII[ii]=all(markAge[indexWindow[ii]]<markAge[booleInDisk]);
            
            
    ###END Removing/thinning points END###
    
    #Remove/keep points to generate Matern hard-core processes
    #Matérn I
    booleKeepI=~(booleRemoveI);
    xxMaternI=xxPoisson[booleKeepI];
    yyMaternI=yyPoisson[booleKeepI];
    
    #Matérn II
    xxMaternII=xxPoisson[booleKeepII];
    yyMaternII=yyPoisson[booleKeepII];
    
    #Update statistics
    numbPointsAll[ss]=numbPoints;
    numbPointsAll_I[ss]=len(xxMaternI);
    numbPointsAll_II[ss]=len(xxMaternII);

###END Simulations END####

##Plotting
markerSize=12; #marker size for the Poisson points
plt.plot(xxPoisson,yyPoisson, 'ko',markerfacecolor="None",markersize=markerSize);
plt.plot(xxMaternI,yyMaternI, 'rx',markersize=markerSize/2);
plt.plot(xxMaternI,yyMaternI, 'b+',markersize=markerSize);
plt.legend(('Underlying Poisson','Matern I','Matern II'));

#Compare statistics
diskArea=np.pi*radiusCore**2; #area of disk
areaWindow=(xMax-xMin)*(yMax-yMin); #area of simulation window

#underlying Poisson point process
lambdaExact=lambdaPoisson
print("lambdaExact = ",lambdaExact)
lambdaEmp=np.mean(numbPointsAll/areaWindow)
print("lambdaEmp = ",lambdaEmp)

#Matern I
lambdaExactI=lambdaPoisson*np.exp(-lambdaPoisson*diskArea) #exact
print("lambdaExactI = ",lambdaExactI)
lambdaEmpI=np.mean(numbPointsAll_I/areaWindow) #empirical
print("lambdaEmpI = ",lambdaEmpI)

#Matern II
lambdaExactII=1/(diskArea)*(1-np.exp(-lambdaPoisson*diskArea))
print("lambdaExactII = ",lambdaExactII)
lambdaEmpII=np.mean(numbPointsAll_II/areaWindow)
print("lambdaEmpII = ",lambdaEmpII)


