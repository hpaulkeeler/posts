# Compares two methods for simulating a homogeneous Poisson point process,
# where the idea behind one method is faster than the other. In this code,
# the two methods are labelled A and B.
#
# Method A simulates all the Poisson ensembles randomly by first randomly
# generating all the Poisson random variables in one step. It then randomly
# positions all the points (across all ensembles) in one step. All the
# points are then are then separated accordingly into ensembles.
#
# Method B iterates through a for-loop, and for each iteration, it randomly
# generates a Poisson variable and positions the points for each ensemble.
#
# Method A uses more vectorization than Method B so it should be faster
# than Method B in general.
#
# Author: H. Paul Keeler, 2019.

clearconsole();

using Random;
using Distributions; #for random simulations
using Plots; #for plotting

Random.seed!(1);

###START Parameters START###
numbSim=10^5; #number of simulations

#Point process parameters
lambda=5; #intensity (ie mean density) of Poisson point process

#Simulation window parameters
xMin=0;xMax=1;
yMin=0;yMax=1;
xDelta=xMax-xMin;yDelta=yMax-yMin; #rectangle dimensions
areaTotal=xDelta*yDelta; #area of rectangle
massTotal=areaTotal*lambda;  #total measure/mass of the point process
###END Parameters END###

###START Simulation section START###
###START Method A: Generate *all* ensembles at once START###
@time begin
    xxCellA=Array{Array{Float64}}(undef,numbSim);
    yyCellA=Array{Array{Float64}}(undef,numbSim);

    numbPointsA=rand(Poisson(massTotal),numbSim); #Poisson number of points
    numbPointsCumA=cumsum(numbPointsA);
    numbPointsTotal=numbPointsCumA[end];

    #uniform x/y coordinates of Poisson points
    xxAll=xDelta.*(rand(numbPointsTotal,1)).+xMin;#x coordinates of Poisson points
    yyAll=yDelta.*(rand(numbPointsTotal,1)).+yMin;#y coordinates of Poisson points

    #create some indexing for the array reshaping step
    indexFirst=copy(numbPointsCumA);
    indexFirst[2:end]=indexFirst[1:end-1].+1;
    indexFirst[1]=1;
    indexSecond=copy(numbPointsCumA);
    #reshape point arrays into an array of arrays.
    for ii in 1:numbSim
        xxCellA[ii]=(xxAll[indexFirst[ii]:indexSecond[ii]]);
        yyCellA[ii]=(yyAll[indexFirst[ii]:indexSecond[ii]]);
    end

    #yyCellAllA=[(yyAll[indexFirst[ii]:indexSecond[ii]]) for ii in 1:numbSim]
end;
###END Method A: Generate *all* ensembles at once END###

###START Method B: Generate each ensemble separately START###
@time begin
    xxCellB=Array{Array{Float64}}(undef,numbSim);
    yyCellB=Array{Array{Float64}}(undef,numbSim);
    numbPointsB=zeros(numbSim);
    #loop through for all ensembles
    for ss=1:numbSim
        numbPointsTemp=rand(Poisson(massTotal));#Poisson number of points
        xxCellB[ss]=xDelta.*(rand(numbPointsTemp,1)).+xMin;#x coordinates of Poisson points
        yyCellB[ss]=yDelta.*(rand(numbPointsTemp,1)).+yMin;#y coordinates of Poisson points
        numbPointsB[ss]=numbPointsTemp;
    end
end;
###END Method B: Generate each ensemble separately END###
###END Simulation section   END###

#Graveyard


#A=Array{Array{Float64}}(undef,numbSim);
#B=fill([],numbSim);

#B=[fill.(xxAll[indexFirst:indexSecond],1)];




# # ###START Create point pattern structures START###
# # numbCellA=mat2cell(numbPointsA,ones(numbSim,1)); #cell for number of points
# # numbCellB=mat2cell(numbPointsB,ones(numbSim,1)); #cell for number of points
# # #create vector for describing the window
# # windowSim=[xMin,xMax,yMin,yMax];
# # #structure array for point patterns from Method A
# # ppStructPoissonA=struct('x',xxCellA,'y',yyCellA,...
# #     'n',numbCellA,'window',windowSim);
# # #structure array for point patterns from Method B
# # ppStructPoissonB=struct('x',xxCellB,'y',yyCellB,...
# #     'n',numbCellB,'window',windowSim);
# # ###END Create point pattern structures END###


#indexSim=1:numbSim;
#indexAllA=vcat(fill.(indexSim,numbPointsA)...);
#xxCellAllA[indexAllA]=xxAll;

#indexCum=cumsum(numbPointsA);
#indexStart=;
#B=Array{Array{Float64}}(undef,numbSim);
#C=Array{Any}(Array{Float64},numbSim);
#C=[xxAll[i:2]  for i in indexSim];
#D=Array{Vector{Float64},numbSim};

#xxCell[indexAllA]=xxAll;
#A=fill.(indexSim,numbPointsA);
#B=[fill.(xxAll[numbPointsA[ii]:numbPointsA[ii]+1],numbPointsA[ii]) for ii in 1:numbSim]
