# Simulates a site percolation model on a square lattice embedded in a torus 
# by using an algorithm proposed in a paper by Newman and Ziff[1]. The 
# algorithm can also be used for bond percolation, but this code is for site 
# percolation. 
#
# There are essentially three steps to the algorithm:
# 1) For every site in the model, find/define the nearest neighbours.
# 2) Draw a single sample uniformly from all site permutations.
# 3) Perform union-find (using root finding) method to find the big component
#
# This algorithm can be used to estimate statistics for a fixed number, say n, 
# of occupied sites. But typically such a (discrete) percolation model is 
# studied in relation to a parameter such as the probability, say p, of an 
# occupied site. It is not implemented in this code, but this leads to an 
# additional step:
# 4) Collect some statistic for every fixed number of occupied sites. This
# statistic, say Q_n, is a conditional statistic, being conditioned on the 
# number of occupied sites. To find the statistic as a function of the 
# probability p, the aforementioned (conditional) statistics are then averaged 
# (or convolved) with respect to the binomial probability. This 
# statistic, say Q(p), is given by equation (2) in the paper[1].
#
# Information on this algorithm can also be found in the book by
# Newman [Section 16.5, 2].
#
# Resources on the internet include:
# https://pypercolate.readthedocs.io/en/stable/newman-ziff.html
#
# https://networkx.org/documentation/stable/_modules/networkx/utils/union_find.html
#
# References:
# [1] 2001, Newman and Ziff, "Fast Monte Carlo algorithm for site or bond percolation"
# [2] 2010, Newman, "Networks - An Introduction"
# [3] 1997, Knuth, "The Art of Computer Programming - Volume 1 - Fundamental Algorithms"
# [4] 2009, Cormen, Leiserson, Rivest, and Stein, "Introduction to algorithms"

import numpy as np  # NumPy package for arrays, random number generation, etc

dimLin = 4  # linear dimension ie number of sites in one dimension
numbSite = dimLin*dimLin  # total number of sites
valueEmpty = -numbSite-1  # a negative number to indicate unconnected sites

### START Define functions START ###

def funBoundaries(dimLin):
    # This function defines neighbour sites for each site in the square
    # lattice on a torus. For other percolation models, this function needs
    # to be changed accordingly to reflect the nearest neighbours.

    numbSite = dimLin*dimLin  # total number of sites
    # initialize matrix for neighbours
    matNeigh = np.zeros((numbSite, 4), dtype=int)

    for i in range(numbSite):
        matNeigh[i][0] = (i+1) % numbSite  # east (or right) neighbour site
        # west (or left) neighbour site
        matNeigh[i][1] = (i+numbSite-1) % numbSite
        # south (or bottom) neighbour site
        matNeigh[i][2] = (i+dimLin) % numbSite
        # north (or top) neighbour site
        matNeigh[i][3] = (i+numbSite-dimLin) % numbSite

        if (i % dimLin == 0):
            #if site is on the west (or left) boundary
            matNeigh[i][1] = i+dimLin-1  # wrap around to other side
        #end if-statement

        if ((i+1) % dimLin == 0):
            #if site is on the east (or right) boundary
            matNeigh[i][0] = i-dimLin+1  # wrap around to other side
        #end if-statement

    #end for-loop

    return matNeigh


def funRandPermute(numbSite):
    # This function generates a random permutation. It performs the
    # Durstenfield version of Fisher-Yates shuffle.  See Algorithm P
    # in "Art of Scientific Programming -- Volume 1" by Knuth.
    # Also see:
    # https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
    #
    # Recommended to use the built-in numpy function numpy.random.permutation

    #initialize order array
    indexOrder = np.arange(numbSite)
    
    for i in range(numbSite):
        j = np.random.randint(i, numbSite)  # random integer j st i<=j<numbSite       
        
        #swap numbers at i and j
        indexTemp = indexOrder[i]
        indexOrder[i] = indexOrder[j]
        indexOrder[j] = indexTemp
        
    return indexOrder


def funFindRootRec(arrPointer, indexPoint):
    #This function performs a root-finding method based
    #on recursion. This method is called path compressing.
    #Newman and Ziff presented this code in the appendix of
    #their paper[1]. The method is standard in the computer science literature.
    # For example, see Chapter 21 in book[4] by Cormen, Leiserson, Rivest, and
    # Stein.

    if (arrPointer[indexPoint] < 0):
        #no changes are made, and the inputs are returned
        return arrPointer, indexPoint
    #end if-statement
    
    #call function again (ie recursively)
    _, arrPointer[indexPoint] = funFindRootRec(
        arrPointer, arrPointer[indexPoint])

    return arrPointer, arrPointer[indexPoint]


def funFindRootHalf(arrPointer, indexPoint):
    # This function performs a (graph) root-finding method
    # that doesn't use recursion. This method is called path halving.
    # Newman and Ziff presented this code in the appendix of their
    # paper[1]. The method is standard in the computer science literature. For
    # example, see Chapter 21 in book[4] by Cormen, Leiserson, Rivest, and
    # Stein.

    r = s = indexPoint
    while (arrPointer[r] >= 0):
        arrPointer[s] = arrPointer[r]
        s = r
        r = arrPointer[r]
    #end while-loop
    return arrPointer, r


def funPercolate(matNeigh, numbSite, indexOrder):
    #This is the main function of the percolation simulation. It performs the
    #(weighted) union-find method to find the big component for each set of
    #occupied sites.

    numbBig = 0  # number of sites in the big component
    valueEmpty = -numbSite-1  # negative number to indicate unconnected sites
    # initialize  array of (graph-theortic) pointers
    arrPointer = np.ones(numbSite, dtype=int)*valueEmpty

    #loop through sites of the sampled site permutation
    for i in range(numbSite):
        r1 = s1 = indexOrder[i]
        arrPointer[s1] = -1
        
        #loop through the 4 neigbour sites of s1
        for j in range(4):
            s2 = matNeigh[s1][j]
            if (arrPointer[s2] != valueEmpty):
                #find root of neighbour site using recursive method
                arrPointer, r2 = funFindRootRec(arrPointer, s2)
                #find root of neighbour site using non-recursive method
                #arrPointer, r2 = funFindRootHalf(arrPointer,s2)
                                
                if (r2 != r1):                    
                    if (arrPointer[r1] > arrPointer[r2]):
                        arrPointer[r2] = arrPointer[r2] + arrPointer[r1]
                        arrPointer[r1] = r2
                        r1 = r2
                    else:
                        arrPointer[r1] = arrPointer[r1] + arrPointer[r2]
                        arrPointer[r2] = r1
                    #end if-statement                    
                    if ((-arrPointer[r1]) > numbBig):
                        #update size of the biggest component
                        numbBig = -arrPointer[r1]
                    #end if-statement
                #end if-statement
            #end if-statement
        #end for-loop

        #comment out to make faster
        #prints out number of occupied sites and biggest component
        #print(str(i + 1) + ", " + str(numbBig) + "\n")
        
    #end for-loop

    return numbBig, arrPointer
### END Define functions END ###

#Step 1
matNeigh = funBoundaries(dimLin)  # find/define nearest neighbours

#Step 2 (only source of randomness)
#indexOrder = funRandPermute(numbSite)  # sample random site permutation
# Recommended to use the built-in numpy function numpy.random.permutation
indexOrder = np.random.permutation(numbSite)

# TEMP START - a test permutation for 3 x 3 lattice
# indexOrder = np.array([4, 5, 8, 0, 2, 6, 3, 1, 7])
# dimLin=3
# numbSite=9
# TEMP END

#Step 3
#percolation step ie finding clusters (or unions) for each configurations
numbBig = funPercolate(matNeigh, numbSite, indexOrder)

print("The percolation magic is finished.\n")
