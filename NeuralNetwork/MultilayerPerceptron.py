# This code runs a simple feedforward neural network.
#
# The neural network is a multi-layer perceptron designed for a simple
# binary classification. The classification is determining whether a
# two-dimensional (Cartesian) point is located inside some given region or
# not.
#
# For the simple binary examples used here, the code seems to work for
# sufficiently large number of optimization steps, typically in the 10s and
# 100s of thousands.
#
# This neural network only has 4 layers (so 2 hidden layers). The
# trainning procedure, meaning the forward and backward passes, are
# hard-coded. This means changing the number of layers requires additional
# information on the neural network architecture.
#
# It uses the sigmoid function; see the activate function.
#
# NOTE: This code is for illustration and educational purposes only. Use a
# industry-level library for real problems.
#
# For more details, see the post:
#
# https://hpaulkeeler.com/creating-a-simple-feedforward-neural-network-without-libraries/
#
# Author: H. Paul Keeler, 2019.
# Website: hpaulkeeler.com
# Repository: github.com/hpaulkeeler/posts

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # For plotting
#from FunctionsExamples import checkFlowerInside, checkVoronoiInside

plt.close('all');  # close all figures

choiceData=1; #choose 1, 2 or 3

numbSteps = 1e5; #number of steps for the (gradient) optimization method
rateLearn = 0.05; #hyperparameter
numbTest = 1000; #number of points for testing the fitted model
boolePlot = True;

%np.random.seed(42); #set seed for reproducibility of results

#helper functions for generating problems
def checkFlowerInside(x1,x2):
    # This function creates a simple binary classification problem.
    # A single point (x1,x2) is either inside a flower petal or not, where the
    # flower (or rose) is defined in polar coordinates by the equation:
    #
    # rho(theta) =cos(k*theta)), where k is a positive integer.

    orderFlower = 2;
    thetaFlower = np.arctan2(x2,x1);
    rhoFlower = np.sqrt(x1**2+x2**2);
    # check if point (x1,x2) is inside the rose
    booleFlowerInside = np.abs(np.cos(orderFlower*thetaFlower)) <= rhoFlower;
    return booleFlowerInside

def checkVoronoiInside(x1,x2):
    # This function creates a simple binary classification problem.
    # A single point (x1,x2) is either inside a chosen Voronoi cell or not,
    # where the Voronoi cells are defined deterministically below.
    numbPoints = len(x1);
    # generat some deterministic seeds for the Voronoi cells
    numbSeed = 6;
    indexCellChosen = 4; #arbitrary chosen cells from first up to this number

    t = np.arange(numbSeed)+1;
    # a deterministic points located on the square [-1,+1]x[-1,+1]
    xSeed1 = np.sin(27*t*np.pi*np.cos(t**2*np.pi+.4)+1.4);
    xSeed2 = np.sin(4.7*t*np.pi*np.sin(t**3*np.pi+.7)+.3);
    xSeed = np.stack((xSeed1,xSeed2),axis=0);

    # find which Voroinoi cells each point (x1,x2) belongs to
    indexVoronoi = np.zeros(numbPoints);
    for i in range(numbPoints):
        x_i = np.stack((x1[i],x2[i]),axis=0).reshape(-1, 1); #retrieve single point
        diff_x = xSeed-x_i;
        distSquared_x = diff_x[0,:]**2+diff_x[1,:]**2; #relative distance squared
        indexVoronoiTemp = np.argmin(distSquared_x); #find closest seed
        indexVoronoi[i] = indexVoronoiTemp;

    # see if points are inside the Voronoi cell number indexCellSingle
    booleVoronoiInside = (indexVoronoi==indexCellChosen);
    return booleVoronoiInside


#generating or retrieving the training data
if (choiceData==1):
    ### simple example
    #recommended minimum number of optimization steps: numbSteps = 1e5
    x1 = 2*np.array([0.1,0.3,0.1,0.6,0.4,0.6,0.5,0.9,0.4,0.7])-1;
    x2 = 2*np.array([0.1,0.4,0.5,0.9,0.2,0.3,0.6,0.2,0.4,0.6])-1;
    numbTrainAll = 10; #number of training data
    #output (binary) data
    y = np.array([[1,1,1,1,1,0,0,0,0,0],[0,0,0,0,0,1,1,1,1,1]]);

    x=np.stack((x1,x2),axis=0);

if (choiceData==2):
    ### voronoi example
    #recommended minimum number of optimization steps: numbSteps = 1e5
    numbTrainAll = 1000; #number of training data
    x=2*np.random.uniform(0, 1,(2,numbTrainAll))-1;
    x1 = x[0,:];
    x2 = x[1,:];
    booleInsideVoroni=checkVoronoiInside(x1,x2);
    # output (binary) data
    y=np.stack((booleInsideVoroni,~booleInsideVoroni),axis=0);

if (choiceData==3):
    ### rose/flower example
    #recommended minimum number of optimization steps: numbSteps = 2e5
    numbTrainAll=100; #number of training data
    x=2*np.random.uniform(0, 1,(2,numbTrainAll))-1;
    x1 = x[0,:];
    x2 = x[1,:];
    booleInsideFlower=checkFlowerInside(x1,x2);
    #output (binary) data
    y=np.stack((booleInsideFlower,~booleInsideFlower),axis=0);

#helper functions for training and running the neural network
def activate(x,W,b):
    z=np.matmul(W,x)+b;
    #evaluate sigmoid (ie logistic) function
    y = 1/(1+np.exp(-z));

    #evaluate ReLU (rectified linear unit)
    #y = np.max(0,z);
    return y

def feedForward(xSingle,arrayW,array_b,numbLayer):
    #run forward pass
    A_now=xSingle;
    for j in np.arange(1,numbLayer):
        A_next=activate(A_now,arrayW[j-1],array_b[j-1]);
        A_now=A_next;
    A_Last=A_next;

    return A_Last;


def getCost(x,y,arrayW,array_b,numbLayer):
    numbTrainAll = np.max(x.shape);
    #originally y, x1 and x2 were defined outside this function
    costAll = np.zeros((numbTrainAll,1));

    for i in range(numbTrainAll):
        #loop through every training point
        x_i = x[:,i].reshape(-1, 1);

        A_Last=feedForward(x_i,arrayW,array_b,numbLayer);
        #find difference between algorithm output and training data
        costAll[i] = np.linalg.norm(y[:,i].reshape(-1, 1) - A_Last,2);

        costTotal = np.linalg.norm(costAll,2)**2;

    return costTotal

#dimensions/widths of neural network
numbWidth1 = 2; #must be 2 for 2-D input data
numbWidth2 = 4;
numbWidth3 = 4;
numbWidth4 = 2; #must be 2 for binary output
numbWidthAll=np.array([numbWidth1,numbWidth2,numbWidth3,numbWidth4]);
numbLayer=len(numbWidthAll);

#initialize weights and biases
scaleModel = .5;
W2 = scaleModel * np.random.normal(0, 1,(numbWidth2,numbWidth1));
b2 = scaleModel * np.random.uniform(0, 1,(numbWidth2,1));
W3 = scaleModel * np.random.normal(0, 1,(numbWidth3,numbWidth2));
b3 = scaleModel * np.random.uniform(0, 1,(numbWidth3,1));
W4 = scaleModel * np.random.normal(0, 1,(numbWidth4,numbWidth3));
b4 = scaleModel * np.random.uniform(0, 1,(numbWidth4,1));

#create lists of matrices
#w matrices
arrayW=[];
arrayW.append(W2);
arrayW.append(W3);
arrayW.append(W4);
#b vectors
array_b=[];
array_b.append(b2);
array_b.append(b3);
array_b.append(b4);
#activation matrices
arrayA=[];
for j in range(numbLayer):
    arrayA.append(np.zeros(numbWidthAll[j]).reshape(-1, 1).T);
#delta (gradient) vectors
array_delta=[];
for j in range(numbLayer-1):
    array_delta.append(np.zeros(numbWidthAll[j+1]).reshape(-1, 1).T);

numbSteps=int(numbSteps)
costHistory = np.zeros((numbSteps,1));
booleTrain = y;
for i in range(numbSteps):
    #forward and back propagation
    indexTrain=np.random.randint(numbTrainAll);
    xTrain = x[:,indexTrain].reshape(-1, 1);

    #run forward pass
    arrayA[0]=xTrain; #treat input as the A1 matrix
    for j in (range(numbLayer-1)):
        arrayA[j+1]=activate(arrayA[j],arrayW[j],array_b[j]);

    #run backward pass (to calculate the gradient) using Hadamard products
    A_temp=arrayA[-1];
    array_delta[-1]=A_temp*(1-A_temp)*(A_temp-y[:,indexTrain].reshape(-1, 1));
    for j in np.arange(numbLayer-2,0,-1):
        A_temp=arrayA[j];
        delta_temp=array_delta[j];
        W_temp=arrayW[j];
        array_delta[j-1]= A_temp*(1-A_temp)*np.matmul(np.transpose(W_temp),delta_temp);


    #update using steepest descent
    #transpose of xTrains used for W matrices
    for j in range(numbLayer-1):
        A_temp=arrayA[j];
        delta_temp=array_delta[j];
        arrayW[j]=arrayW[j] - rateLearn*np.matmul(delta_temp,np.transpose(A_temp));
        array_b[j]=array_b[j] - rateLearn*delta_temp;


    #update cost
    costCurrent_i = getCost(x,y,arrayW,array_b,numbLayer);
    costHistory[i] = costCurrent_i;

#generating test data
xTest = 2*np.random.uniform(0,1,(2,numbTest))-1;
xTest1 = xTest[0,:];
xTest2 = xTest[1,:];

booleTest = np.zeros((2,numbTest));

#testing every point
for k in range(numbTest):
    xTestSingle = xTest[:,k].reshape(-1, 1);
    #apply fitted model
    yTestSingle = feedForward(xTestSingle,arrayW,array_b,numbLayer);
    indexTest = np.argmax(yTestSingle, axis=0);
    booleTest[0,k] = ((indexTest==0)[0]);
    booleTest[1,k] = ((indexTest==1)[0]);

if boolePlot:
    #plot history of cost
    plt.figure();
    plt.semilogy(np.arange(numbSteps)+1,costHistory);
    plt.xlabel('Number of optimization steps');
    plt.ylabel('Value of cost function');
    plt.title('History of the cost function')

    #plot training data
    fig, ax = plt.subplots(1, 2);
    ax[0].plot(x1[np.where(booleTrain[0,:])],x2[np.where(booleTrain[0,:])],\
        'rs', markerfacecolor='none');
    ax[0].plot(x1[np.where(booleTrain[1,:])],x2[np.where(booleTrain[1,:])],\
        'b+');
    ax[0].set_xlabel('x');
    ax[0].set_ylabel('y');
    ax[0].set_title('Training data');
    ax[0].set_xlim([-1, 1])
    ax[0].set_ylim([-1, 1])
    ax[0].axis('equal');

    #plot test data
    ax[1].plot(xTest1[np.where(booleTest[0,:])],xTest2[np.where(booleTest[0,:])],\
        'rd', markerfacecolor='none');
    ax[1].plot(xTest1[np.where(booleTest[1,:])],xTest2[np.where(booleTest[1,:])],\
        'bx');
    ax[1].set_xlabel('x');
    ax[1].set_ylabel('y');
    ax[1].set_title('Testing data');
    ax[1].set_xlim([-1, 1])
    ax[1].set_ylim([-1, 1])
    ax[1].axis('equal');
