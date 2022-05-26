# Consider a collection of (finite) line segments scattered on a
# two-dimensional (finite) window. This code finds the points where the
# segments intersect with a rectangular box with its parallel to the
# Cartesian axes.
#
# The intersection points are found by first deriving the linear equations
# (with form y=mx+c) of the corresponding lines of each segment. Then the
# x and y (interception) values are calculated based on the dimensions of
# the rectangular box.
#
# The segments are then truncuated, so that only segments inside the box
# remain.
#
# The results are also plotted if there are less than 30 segments.
#
# Labelling convention: N, S, E, W for North, South, East, West edges of the
# box, meaning the top, bottom, right, and left sides of the box.
#
# Author: H. Paul Keeler, 2022.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts
# For more details, see the post:
# hpaulkeeler.com/line-segments-intersecting-with-a-rectangle/


import numpy as np  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from matplotlib.patches import Rectangle  # for drawing rectangles

plt.close('all')  # close all figures

np.random.seed(3)  # seed random number generator for reproducing results

np.seterr(divide='ignore', invalid='ignore')  # ignore the divisions by zero

#simulation window parameters
#rectangle dimensions
xDelta = 1  # width
yDelta = 1  # height
x0 = 0  # x centre
y0 = 0  # y centre
#rectangle corners
xMin = x0-xDelta/2  # minimum x value
xMax = x0+xDelta/2  # maximum x value
yMin = y0-yDelta/2  # minimum y value
yMax = y0+yDelta/2  # maximum y value

#box dimensions

dimBox = np.array([xMin, yMin, xDelta, yDelta])

#extended simulation windows parameters
#delta scale
scaleDeltaExt=1.5;
xDeltaExt=xDelta*scaleDeltaExt;
yDeltaExt=yDelta*scaleDeltaExt;
#rectangle corners
xMinExt=x0-xDeltaExt/2;
xMaxExt=x0+xDeltaExt/2;
yMinExt=y0-yDeltaExt/2;
yMaxExt=y0+yDeltaExt/2;
areaTotalExt=xDeltaExt*yDeltaExt; #area of extended rectangle

#extended simulation window dimensions
xLim = np.array([xMinExt, xMaxExt])
yLim = np.array([yMinExt, yMaxExt])

#Simulate Binomial point process on extended window for the segment ends
numbSegs = 30  # number of points
xxSeg = xDeltaExt * \
    np.random.uniform(0, 1, (numbSegs, 2))+xMinExt  # x coordinates
yySeg = yDeltaExt * \
    np.random.uniform(0, 1, (numbSegs, 2))+yMinExt  # y coordinates

###START - Test Case - START###
#x and y coordinates of segment
#xxSeg=(np.array([[-6,-2,-6,2,3],[-3,-2,6,4,6]])/10).transpose();
#yySeg=(np.array([[-4,-6,3,2,6],[-6,4,3,1,7]])/10).transpose();
#numbSegs=len(xxSeg[:,0]);
###END - Test Case - END###

#Label convention: N, E, S, W for North, East, South, West edges of the box

###START - Helper Functions - START###
def funBooleIn(s, sMin, sMax):
    #check if a number s is inside an interval [sMin,sMax]
    return np.logical_and(s >= sMin, s <= sMax)

def funBooleCrossBound(z1, z2, zBound):
    #checks if x or y value of edge crosses vertical or horizontal boundary
    return (np.logical_xor(z1 >= zBound, z2 >= zBound))

#define functions for line parameters
def fun_m(x1, y1, x2, y2):        
    return ((y2-y1)/(x2-x1))  # slope value

def fun_y0(x, y, c):    
    return (y-c*x)  # y intercept value

def fun_x(y, y0, c):
    return (y-y0)/c  # find x value given y, m, c

def fun_y(x, m, c):
    return (m*x+c)  # find y value given x, m, c
### END -- Helper Functions -- END ###

### START -- Sort x and y by x values -- START ###
xxSegTemp = xxSeg.copy()
yySegTemp = yySeg.copy()
#need to swap x values for calculating gradients
booleSwap = (xxSeg[:, 0] > xxSeg[:, 1])  # find where x values need swapping
#swap x values based on x values so smallest x value is first (ie left)
xxSeg[booleSwap, 0] = xxSegTemp[booleSwap, 1]
xxSeg[booleSwap, 1] = xxSegTemp[booleSwap, 0]
#swap y values based on x values
yySeg[booleSwap, 0] = yySegTemp[booleSwap, 1]
yySeg[booleSwap, 1] = yySegTemp[booleSwap, 0]
### END -- Sort by x values --  END ###

### START -- Find segment/line parameters -- START ###
#calculate gradients/slopes (ie m value) for all edges
slopeSeg = fun_m(xxSeg[:, 0], yySeg[:, 0], xxSeg[:, 1], yySeg[:, 1])
#calcualte y intersecpts of all edges
yInterSeg = fun_y0(xxSeg[:, 1], yySeg[:, 1], slopeSeg)

#find the segments that intersect with the box edges/boundaries
#x values for north and south box edges
xSegN = fun_x(yMax, yInterSeg, slopeSeg)
xSegS = fun_x(yMin, yInterSeg, slopeSeg)
#y values for east and west box edges
ySegE = fun_y(xMax, slopeSeg, yInterSeg)
ySegW = fun_y(xMin, slopeSeg, yInterSeg)
### END -- Find segment/line parameters -- END ###

###START - Various indicators such as segments crossing edges - START###
#indicator fuctions that are outside box (infinitely extended) boundaries
booleN = yySeg > yMax  # segment ends above the north box edge
booleS = yySeg < yMin  # segment ends below the south box edge
booleE = xxSeg > xMax  # segment ends right of the east box edge
booleW = xxSeg < xMin  # segment ends left of the westbox edge

#segment ends that lie ubside the box
booleIn = (~booleE) & (~booleW) & (~booleN) & (~booleS)
#segment ends that lie outside the box
booleOut = ~booleIn
#find segment *both* ends lie  outside the box
booleOutBoth = np.logical_and(booleOut[:, 0], booleOut[:, 1])

#segments crossing north box edge
booleCrossBoxN = funBooleCrossBound(yySeg[:, 0], yySeg[:, 1], yMax) \
    & funBooleIn(xSegN, xMin, xMax)
#segments crossing south box edge
booleCrossBoxS = funBooleCrossBound(yySeg[:, 0], yySeg[:, 1], yMin) \
    & funBooleIn(xSegS, xMin, xMax)
#segments crossing east box edge
booleCrossBoxE = funBooleCrossBound(xxSeg[:, 0], xxSeg[:, 1], xMax) \
    & funBooleIn(ySegE, yMin, yMax)
#segments crossing west box edge
booleCrossBoxW = funBooleCrossBound(xxSeg[:, 0], xxSeg[:, 1], xMin) \
    & funBooleIn(ySegW, yMin, yMax)

#find non-intersecting (with box) segments
booleNoCrossBox = ((~booleCrossBoxN) & (~booleCrossBoxS)
                   & (~booleCrossBoxE) & (~booleCrossBoxW))
#keep edges interior and intersecting segments
booleKeep = ~(booleNoCrossBox & booleOutBoth)
###END - Various indicators such as segments crossing edges - END###

###START - Replace old segment ends with new ones - START###
#find new edge end values for intersecting edges
#north box edge
xxSegTruncN = xSegN[booleCrossBoxN]
yySegTruncN = yMax*np.ones(np.shape(xxSegTruncN))
#south box edge
xxSegTruncS = xSegS[booleCrossBoxS]
yySegTruncS = yMin*np.ones(np.shape(xxSegTruncS))
#east box edge
xxSegTruncE = ySegE[booleCrossBoxE]
yySegTruncE = xMax*np.ones(np.shape(xxSegTruncE))
#west box edge
xxSegTruncW = ySegW[booleCrossBoxW]
yySegTruncW = xMin*np.ones(np.shape(xxSegTruncW))

#new x and y values
xxSegTrunc = xxSeg.copy()
yySegTrunc = yySeg.copy()

#intersecting segment ends that need replacing
#Note: the fuction np.tile is used as booleCrossBox refers to segments, not
#segement ends, meaning two dimensional arrays are needed
booleReplaceN = booleN & booleOut \
    & np.tile(np.atleast_2d(booleCrossBoxN).T, (1, 2))  # north
booleReplaceS = booleS & booleOut \
    & np.tile(np.atleast_2d(booleCrossBoxS).T, (1, 2))  # south
booleReplaceE = booleE & booleOut \
    & np.tile(np.atleast_2d(booleCrossBoxE).T, (1, 2))  # east
booleReplaceW = booleW & booleOut \
    & np.tile(np.atleast_2d(booleCrossBoxW).T, (1, 2))  # west

#replament step
#north edge
xxSegTrunc[booleReplaceN] = xxSegTruncN
yySegTrunc[booleReplaceN] = yySegTruncN
#south edge
xxSegTrunc[booleReplaceS] = xxSegTruncS
yySegTrunc[booleReplaceS] = yySegTruncS
#east edge
xxSegTrunc[booleReplaceW] = yySegTruncW
yySegTrunc[booleReplaceW] = xxSegTruncW
#est edge
xxSegTrunc[booleReplaceE] = yySegTruncE
yySegTrunc[booleReplaceE] = xxSegTruncE

#remove segments that do not intersect with box or lie outside the box
xxSegBoxed = np.vstack((xxSegTrunc[booleKeep, 0], xxSegTrunc[booleKeep, 1])).T
yySegBoxed = np.vstack((yySegTrunc[booleKeep, 0], yySegTrunc[booleKeep, 1])).T
numbSegsBoxed = sum(booleKeep)  # number of kept lines
###END - Replace old segment ends with new ones  END###

###START - Plotting - START###
#random matrices for line colours
colorMat = np.random.rand(3, numbSegs).T
colorMatBoxed = colorMat[booleKeep, :]
labelSegAll=list(np.arange(numbSegs));
labelSegBoxed=list(np.arange(numbSegs)[booleKeep]);

for kk in range(3):
    if kk==0:
        #plot original segments
            xxPlotTemp=xxSeg;
            yyPlotTemp=yySeg;
            colorMatTemp=colorMat;
            labelSegTemp=labelSegAll;        
    elif kk==1:
        #plot truncated (intersecting) segments or lie completely outside the box
            xxPlotTemp=xxSegTrunc;
            yyPlotTemp=yySegTrunc;
            colorMatTemp=colorMat;
            labelSegTemp=labelSegAll;
    
    elif kk==2:
            #plot final segments that intersect with or lie inside the box
            xxPlotTemp=xxSegBoxed;
            yyPlotTemp=yySegBoxed;
            colorMatTemp=colorMatBoxed;
            labelSegTemp=labelSegBoxed;
    #end if-statement
    
    #plot original segments
    plt.figure();
    fig, ax = plt.subplots()  # use subplots for multiple plots in one window
    numbSegTemp=len(xxPlotTemp[:,0]);

    for ii in range(numbSegTemp):
        #loop through each segment and plot
        plt.plot(xxPlotTemp[ii], yyPlotTemp[ii], color=colorMatTemp[ii])
    #end for-loop
    
    #draw rectangle
    ax.add_patch(Rectangle((xMin, yMin), xDelta, yDelta, fc='none', ec='k', lw=2))
    plt.xlim((xLim))
    plt.ylim((yLim))
    #remove ticks on x and y axes
    plt.axis('off')
    #plot segment ends
    plt.plot(xxPlotTemp.T, yyPlotTemp.T, 'k.', markersize=8)
    
    #label segements for small number of segements
    if numbSegTemp < 30:
        xxTextTemp = np.mean(xxPlotTemp, axis=1)
        yyTextTemp = np.mean(yyPlotTemp, axis=1)
        #number the points/cells
        for ii, labelSeg_ii in enumerate(labelSegTemp):
            plt.text(xxTextTemp[ii]+xDelta/50, yyTextTemp[ii]+yDelta/50, labelSeg_ii)
        #end for-loop
    #end if-statement
#end for-loop
###END - Plotting - END###




# #plot original segments
# plt.figure();
# fig, ax = plt.subplots()  # use subplots for multiple plots in one window
# for ii in range(numbSegs):
#     #loop through each segment and plot
#     plt.plot(xxSeg[ii], yySeg[ii], color=colorMat[ii])
# #draw rectangle
# ax.add_patch(Rectangle((xMin, yMin), xDelta, yDelta, fc='none', ec='k', lw=2))
# plt.xlim((xLim*1.5))
# plt.ylim((yLim*1.5))
# #remove ticks on x and y axes
# plt.axis('off')

# #label segements for small number of segements
# if numbSegs < 5:
#     xxPlot = np.mean(xxSeg, axis=1)
#     yyPlot = np.mean(yySeg, axis=1)
#     #number the points/cells
#     for ii in range(numbSegs):
#         plt.text(xxPlot[ii]+xDelta/50, yyPlot[ii]+yDelta/50, ii)

# #plot final segments that intersect with or lie inside the box
# plt.figure();
# fig, ax = plt.subplots()  # use subplots for multiple plots in one window
# for ii in range(numbSegs):
#     #loop through each segment and plot
#     plt.plot(xxSegTrunc[ii], yySegTrunc[ii], color=colorMat[ii])
# #draw rectangle
# ax.add_patch(Rectangle((xMin, yMin), xDelta, yDelta, fc='none', ec='k', lw=2))
# plt.xlim((xLim*1.5))
# plt.ylim((yLim*1.5))
# #remove ticks on x and y axes
# plt.axis('off')
# #plot (truncated) segment ends
# plt.plot(xxSegTrunc.T, yySegTrunc.T, 'k.', markersize=8)

# #plot final segments that intersect with or lie inside the box
# plt.figure();
# fig, ax = plt.subplots()  # use subplots for multiple plots in one window
# for ii in range(numbSegsBoxed):
#     #loop through each segment and plot
#     plt.plot(xxSegBoxed[ii], yySegBoxed[ii], color=colorMatBoxed[ii])
# #draw rectangle
# ax.add_patch(Rectangle((xMin, yMin), xDelta, yDelta, fc='none', ec='k', lw=2))
# plt.xlim((xLim*1.5))
# plt.ylim((yLim*1.5))
# #remove ticks on x and y axes
# plt.axis('off')
# #plot (truncated) segment ends
# plt.plot(xxSegBoxed.T, yySegBoxed.T, 'k.', markersize=8)
