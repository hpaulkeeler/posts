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
# hard-coded, so changing the number of layers requires additional code.
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

#np.random.seed(42); #set seed for reproducibility of results

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
    numbTrainAll=1000; #number of training data
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

def feedForward(xSingle,W2,W3,W4,b2,b3,b4):
    #run forward pass
    A2 = activate(xSingle,W2,b2); #feedforward x
    A3 = activate(A2,W3,b3); #feedfoward a2
    A4 = activate(A3,W4,b4); #feedfoward a3
    A_Last=A4;
    return A_Last

def getCost(x,y,W2,W3,W4,b2,b3,b4):
    numbTrainAll = np.max(x.shape);
    #originally y, x1 and x2 were defined outside this function
    costAll = np.zeros((numbTrainAll,1));

    for i in range(numbTrainAll):

        #loop through every training point
        x_i = x[:,i].reshape(-1, 1);

        A_Last=feedForward(x_i,W2,W3,W4,b2,b3,b4);
        #find difference between algorithm output and training data
        costAll[i] = np.linalg.norm(y[:,i].reshape(-1, 1) - A_Last,2);

        costTotal = np.linalg.norm(costAll,2)**2;

    return costTotal

#dimensions/widths of neural network
numbWidth1 = 2; #must be 2 for 2-D input data
numbWidth2 = 4;
numbWidth3 = 4;
numbWidth4 = 2; #must be 2 for binary output
numbLayer=4;

#initialize weights and biases
scaleModel = .5;
W2 = scaleModel * np.random.normal(0, 1,(numbWidth2,numbWidth1));
b2 = scaleModel * np.random.uniform(0, 1,(numbWidth2,1));
W3 = scaleModel * np.random.normal(0, 1,(numbWidth3,numbWidth2));
b3 = scaleModel * np.random.uniform(0, 1,(numbWidth3,1));
W4 = scaleModel * np.random.normal(0, 1,(numbWidth4,numbWidth3));
b4 = scaleModel * np.random.uniform(0, 1,(numbWidth4,1));

numbSteps=int(numbSteps)
costHistory = np.zeros((numbSteps,1));
booleTrain = y;
for i in range(numbSteps):
    #forward and back propagation
    indexTrain=np.random.randint(numbTrainAll);
    xTrain = x[:,indexTrain].reshape(-1, 1);

    #run forward pass
    A2 = activate(xTrain,W2,b2); #feedforward x
    A3 = activate(A2,W3,b3);
    A4 = activate(A3,W4,b4);

    #run backward pass (to calculate the gradient) using Hadamard products
    delta4 = A4*(1-A4)*(A4-y[:,indexTrain].reshape(-1, 1));
    delta3 = A3*(1-A3)*np.matmul(np.transpose(W4),delta4);
    delta2 = A2*(1-A2)*np.matmul(np.transpose(W3),delta3);

    #update using steepest descent
    #transpose of xTrains used for W matrices
    W2 = W2 - rateLearn*np.matmul(delta2,np.transpose(xTrain));
    W3 = W3 - rateLearn*np.matmul(delta3,np.transpose(A2));
    W4 = W4 - rateLearn*np.matmul(delta4,np.transpose(A3));
    b2 = b2 - rateLearn*delta2;
    b3 = b3 - rateLearn*delta3;
    b4 = b4 - rateLearn*delta4;

    #update cost
    costCurrent_i = getCost(x,y,W2,W3,W4,b2,b3,b4);
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
    yTestSingle = feedForward(xTestSingle,W2,W3,W4,b2,b3,b4);
    indexTest = np.argmax(yTestSingle, axis=0);
    booleTest[0,k] = ((indexTest==0));
    booleTest[1,k] = ((indexTest==1));

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
