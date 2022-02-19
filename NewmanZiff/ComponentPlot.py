# This file plots a site percolation model of a bounded square lattice on 
# a torus. Unoccupied sites are grey disks, whereas occupied sites are 
# coloured disks. Two or more sites of the same colour indicates them 
# belonging to the same component, where their shared colour is that of the 
# root site. For the coluring, the plotting function sets the seed of 
# NumPy's pseudo-random number generator. 
#
# The main input variable is the array arrPointer, which encodes
# information of the occupied and occupied sites, as well as the root sites 
# of componenets formed from the adjacent sites being occupied. The other 
# input parameter is valueEmpty, which indicates that a site is unoccupied. 
# Note that valueEmpty needs to be greater than the (negative) length of 
# the array arrPointer.

# The way that the array arrPointer stores encodes percolation information 
# was originally used in the C code presented in the appendix of the 
# paper[1] by Newman Ziff. More specfically, in the Appendix of the paper, 
# you'll find this explanation:
#
# "The array arrPointer serves triple duty: for nonroot occupied sites it 
# contains the label for the site’s parent in the tree (the ‘‘pointer’’); 
# root sites are recognized by a negative value of arrPointer, and that 
# value is equal to minus the size of the cluster; for unoccupied sites 
# arrPointer takes the value valueEmpty."
#
# Note: In the code here, I have changed the variables names in the origina 
# C code from ptr and EMPTY to arrPointer and valueEmpty, respectively.
#
# Author: H.Paul Keeler, 2022
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
#
# References:
# [1] 2001, Newman and Ziff, "Fast Monte Carlo algorithm for site or bond 
# percolation"

#import relevant libraries
import numpy as np  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt

#plt.close('all');  # close all figures

###TEST - A test permutation for 4 x 4 lattice ###TEST
#arrPointer=np.array([-4,1,-17,-17,1,-17,11,-17,-17,11,-3,-17,1,-17,-17,-17])\
#    .astype(int);
#
###TEST - A test permutation for 5 x 5 lattice ###TEST
arrPointer = np.array([-26, -1, -26, 5, -3, -26, -26, -26, 5, -26, -26, -26, -26, -26, -26,
                       -26, -26, -1, -26, -26, -1, -26, -26, -26, -26]).astype(int)

#retrieve other paramters
numbSite = len(arrPointer)  # total number of sites
valueEmpty = -numbSite-1  # negative number to indicate unconnected sites

def funLatticeSite(arrPointer, valueEmpty):
    #This is a helper function that draws a square lattice with occupied sites
    # on a unit square. Unoccupied sites are grey disks, whereas occupied sites
    # are coloured disk. Two or more sites of the same colour indicates them
    # belonging to the same component, where their shared colour is that of the
    # root site.
    #
    # WARNING: Do not use for large lattice.

    #retrieve other paramters
    numbSite = len(arrPointer)   # total number of sites
    dimLin = np.round(np.sqrt(numbSite)).astype(int)  # linear dimension

    if numbSite < 1000:

        z = np.linspace(0, 1, dimLin)
        xx, yy = np.meshgrid(z, z)

        #create matrix of random vectors for colours
        np.random.seed(42)  # set random seed
        # each color is a different vector
        colorAll = np.random.uniform(0, 1, (numbSite, 3))
        #colorAll=np.random.uniform(0,1,(3,numbSite)).transpose();
        #transpose above is generate the same order of random variables as MATLAB
        np.random.seed()  # reset pseudo-random number generator

        #size of markers
        sizeMarkerBig = np.round(600/dimLin).astype(int)  # (occupied sites)
        sizeMarkerSmall = np.round(
            sizeMarkerBig/1.5).astype(int)  # (unoccupied sites)

        #create figure and draw bonds in black of lattice on the unit square
        #fig, ax = plt.subplots();
        plt.plot(xx, yy, 'k-')  # vertical lines
        plt.plot(xx.transpose(), yy.transpose(), 'k-')  # horizontal lines
        plt.axis('equal')  # square plot
        plt.axis('off')

        #turn site-coordinate matrices into vectors
        xx = xx.flatten()
        yy = yy.flatten()

        #draw unnoccupied sites
        plt.scatter(xx, yy, s=sizeMarkerSmall, edgecolor='none', facecolor=[.7, .7, .7, 1],
                    alpha=1)

        #number the points/cells
        #for ii in range(numbSite):
        #    plt.text(xx[ii], yy[ii], ii)

        #find occupied sites (ie numbers > valueEmpty)
        booleOccupied = arrPointer > valueEmpty
        #find roots of all clusters (ie negative numbers > valueEmpty)
        indexAll = np.arange(arrPointer.size)  # all indices
        indexRoot = indexAll[booleOccupied & (arrPointer < 0)]+1

        #loop through all the roots
        for rr in indexRoot:
            #for each root, find the connected sites
            indexSiteRoot = indexAll[(arrPointer) == (rr)]

            #append root
            indexCompTemp = np.append(rr-1, indexSiteRoot)
            #the minus one is because Python indexing starts at 0

            #choose corresponding root colour
            colorTemp = np.append(colorAll[rr-1, ], 1)
            #the minus one is because Python indexing starts at 0

            #plot the sites for each root and the root in the root colour
            plt.scatter(xx[indexCompTemp], yy[indexCompTemp],
                        s=sizeMarkerBig, edgecolor='none', facecolor=colorTemp)

        #end for-loop

    else:
        print('Attempt to draw a latice with too many sites. Decrease size of lattice.')
    #end if-statement

#plot lattice of occupied and unoccupied sites
funLatticeSite(arrPointer, valueEmpty)
