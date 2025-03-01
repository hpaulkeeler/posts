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
        print('Attempt to draw a lattice with too many sites. Decrease size of lattice.')
    #end if-statement
