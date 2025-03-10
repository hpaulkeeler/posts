% This code runs a simple feedforward neural network.
%
% The neural network is a multi-layer perceptron designed for a simple
% binary classification. The classification is determining whether a
% two-dimensional (Cartesian) point is located inside some given region or
% not.
%
% For the simple binary examples used here, the code seems to work for
% sufficiently large number of optimization steps, typically in the 10s and
% 100s of thousands.
%
% This neural network only has 4 layers (so 2 hidden layers). The
% trainning procedure, meaning the forward and backward passes, are
% hard-coded, so changing the number of layers requires additional code.
%
% It uses the sigmoid function; see the activate function.
%
% NOTE: This code is for illustration and educational purposes only. Use a
% industry-level library for real problems.
%
% For more details, see the post:
%
% https://hpaulkeeler.com/creating-a-simple-feedforward-neural-network-without-libraries/
%
% Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

clearvars; clc; close all;

choiceData=1; %choose 1, 2 or 3

numbSteps = 1e5; %number of steps for the (gradient) optimization method
rateLearn = 0.05; %hyperparameter
numbTest = 1000; %number of points for testing the fitted model
boolePlot=true;

%rng(42); %set seed for reproducibility of results

%generating or retrieving the training data
switch choiceData
    case 1
        %%% simple example
        %recommended minimum number of optimization steps: numbSteps = 1e5
        x1 = 2*[0.1,0.3,0.1,0.6,0.4,0.6,0.5,0.9,0.4,0.7]-1;
        x2 = 2*[0.1,0.4,0.5,0.9,0.2,0.3,0.6,0.2,0.4,0.6]-1;
        numbTrainAll = 10; %number of training data
        %output (binary) data
        y = [ones(1,5) zeros(1,5); zeros(1,5) ones(1,5)];
    case 2
        %%% voronoi example
        %recommended minimum number of optimization steps: numbSteps = 1e5
        numbTrainAll = 1000; %number of training data
        x1 = 2*rand(1,numbTrainAll)-1;
        x2=2*rand(1,numbTrainAll)-1;
        booleInsideVoroni=checkVoronoiInside(x1,x2);
        % output (binary) data
        y=[booleInsideVoroni;~booleInsideVoroni];
    case 3
        %%% rose/flower example
        %recommended minimum number of optimization steps: numbSteps = 2e5
        numbTrainAll=1000; %number of training data
        x1=2*rand(1,numbTrainAll)-1;
        x2=2*rand(1,numbTrainAll)-1;
        booleInsideFlower=checkFlowerInside(x1,x2);
        %output (binary) data
        y=[booleInsideFlower;~booleInsideFlower];

end
x=[x1;x2];

%dimensions/widths of neural network
numbWidth1 = 2; %must be 2 for 2-D input data
numbWidth2 = 4;
numbWidth3 = 4;
numbWidth4 = 2; %must be 2 for binary output
numbLayer=4;

%initialize weights and biases
scaleModel = .5;
W2 = scaleModel * randn(numbWidth2,numbWidth1);
b2 = scaleModel * rand(numbWidth2,1);
W3 = scaleModel * randn(numbWidth3,numbWidth2);
b3 = scaleModel * rand(numbWidth3,1);
W4 = scaleModel * randn(numbWidth4,numbWidth3);
b4 = scaleModel * rand(numbWidth4,1);

costHistory = zeros(numbSteps,1);
booleTrain = logical(y);
for i = 1:numbSteps
    %forward and back propagation
    indexTrain=randi(numbTrainAll);
    xTrain = x(:,indexTrain);

    %run forward pass
    A2 = activate(xTrain,W2,b2); %feedforward x
    A3 = activate(A2,W3,b3);
    A4 = activate(A3,W4,b4);

    %run backward pass (to calculate the gradient) using Hadamard products
    delta4 = A4.*(1-A4).*(A4-y(:,indexTrain));
    delta3 = A3.*(1-A3).*(transpose(W4)*delta4);
    delta2 = A2.*(1-A2).*(transpose(W3)*delta3);

    %update using steepest descent
    %transpose of xTrains used for W matrices
    W2 = W2 - rateLearn*delta2*transpose(xTrain);
    W3 = W3 - rateLearn*delta3*transpose(A2);
    W4 = W4 - rateLearn*delta4*transpose(A3);
    b2 = b2 - rateLearn*delta2;
    b3 = b3 - rateLearn*delta3;
    b4 = b4 - rateLearn*delta4;

    %update cost
    costCurrent_i = getCost(x,y,W2,W3,W4,b2,b3,b4);
    costHistory(i) = costCurrent_i;
end

%generating test data
xTest1 = 2*rand(1,numbTest)-1;
xTest2 = 2*rand(1,numbTest)-1;
xTest = [xTest1;xTest2];
booleTest = (false(2,numbTest));

%testing every point
for k=1:numbTest
    xTestSingle = xTest(:,k);
    %apply fitted model
    yTestSingle = feedForward(xTestSingle,W2,W3,W4,b2,b3,b4);
    [~,indexTest] = max(yTestSingle);

    booleTest(1,k) = (indexTest==1);
    booleTest(2,k) = (indexTest==2);
end

if boolePlot

    %plot history of cost
    figure;
    semilogy(1:numbSteps,costHistory);
    xlabel('Number of optimization steps');
    ylabel('Value of cost function');
    title('History of the cost function')

    %plot training data
    figure;
    tiledlayout(1,2);
    nexttile;
    hold on;
    plot(x1(booleTrain(1,:)),x2(booleTrain(1,:)),'rs');
    plot(x1(booleTrain(2,:)),x2(booleTrain(2,:)),'b+');
    xlabel('x');
    ylabel('y');
    title('Training data');
    axis([-1,1,-1,1]);
    axis square;

    %plot test data

    nexttile;
    hold on;
    plot(xTest1(booleTest(1,:)),xTest2(booleTest(1,:)),'rd');
    plot(xTest1(booleTest(2,:)),xTest2(booleTest(2,:)),'bx');
    xlabel('x');
    ylabel('y');
    title('Testing data');
    axis([-1,1,-1,1]);
    axis square;

end


%helper functions for training and running the neural network

function costTotal = getCost(x,y,W2,W3,W4,b2,b3,b4)
numbTrainAll = max(size(x));
%originally y, x1 and x2 were defined outside this function
costAll = zeros(numbTrainAll,1);

for i = 1:numbTrainAll
    %loop through every training point
    x_i = x(:,i);

    A_Last=feedForward(x_i,W2,W3,W4,b2,b3,b4);
    %find difference between algorithm output and training data
    costAll(i) = norm(y(:,i) - A_Last,2);
end
costTotal = norm(costAll,2)^2;
end

function y = activate(x,W,b)
z=(W*x+b);
%evaluate sigmoid (ie logistic) function
y = 1./(1+exp(-z));

%evaluate ReLU (rectified linear unit)
%y = max(0,z);
end

function A_Last= feedForward(xSingle,W2,W3,W4,b2,b3,b4)
%run forward pass
A2 = activate(xSingle,W2,b2); %feedforward x
A3 = activate(A2,W3,b3); %feedfoward a2
A4 = activate(A3,W4,b4); %feedfoward a3

A_Last=A4;
end


%helper functions for generating problems

function booleFlowerInside=checkFlowerInside(x1,x2)
% This function creates a simple binary classification problem.
% A single point (x1,x2) is either inside a flower petal or not, where the
% flower (or rose) is defined in polar coordinates by the equation:
%
% rho(theta) =cos(k*theta)), where k is a positive integer.

orderFlower = 2;
[thetaFlower, rhoFlower] = cart2pol(x1(:)',x2(:)');
% check if point (x1,x2) is inside the rose
booleFlowerInside = abs(cos(orderFlower*thetaFlower)) <= rhoFlower;

end

function booleVoronoiInside=checkVoronoiInside(x1,x2)
% This function creates a simple binary classification problem.
% A single point (x1,x2) is either inside a chosen Voronoi cell or not,
% where the Voronoi cells are defined deterministically below.

numbPoints = length(x1);
% generat some deterministic seeds for the Voronoi cells
numbSeed = 6;
indexCellChosen = 4; %arbitrary chosen cells from first up to this number

t = 1:numbSeed;
% a deterministic points located on the square [-1,+1]x[-1,+1]
xSeed1 = sin(27*t.*pi.*cos(t.^2*pi+.4)+1.4);
xSeed2 = sin(4.7*t.*pi.*sin(t.^3*pi+.7)+.3);
xSeed = [xSeed1;xSeed2];

% find which Voroinoi cells each point (x1,x2) belongs to
indexVoronoi = zeros(1,numbPoints);
for i = 1:numbPoints
    x_i = [x1(i); x2(i)]; %retrieve single point
    diff_x = xSeed-x_i;
    distSquared_x = diff_x(1,:).^2+diff_x(2,:).^2; %relative distance squared
    [~,indexVoronoiTemp] = min(distSquared_x); %find closest seed
    indexVoronoi(i) = indexVoronoiTemp;
end

% see if points are inside the Voronoi cell number indexCellSingle
booleVoronoiInside = (indexVoronoi==indexCellChosen);
end
