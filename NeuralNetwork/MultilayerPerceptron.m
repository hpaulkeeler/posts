% This code runs a simple feedforward neural network inspired.
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
% This neural network only has 4 layers (meaning 2 hidden layers).
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
booleTrain = logical(y);

%dimensions/widths of neural network
numbWidth1 = 2; %must be 2 for 2-D input data
numbWidth2 = 4;
numbWidth3 = 4;
numbWidth4 = 2; %must be 2 for binary output
numbWidthAll=[numbWidth1,numbWidth2,numbWidth3,numbWidth4];
numbLayer=length(numbWidthAll);

%initialize weights and biases
scaleModel = .5;
W2 = scaleModel * randn(numbWidth2,numbWidth1);
b2 = scaleModel * rand(numbWidth2,1);
W3 = scaleModel * randn(numbWidth3,numbWidth2);
b3 = scaleModel * rand(numbWidth3,1);
W4 = scaleModel * randn(numbWidth4,numbWidth3);
b4 = scaleModel * rand(numbWidth4,1);

%create arrays of matrices
%w matrices
arrayW{1}=W2;
arrayW{2}=W3;
arrayW{3}=W4;
%b vectors
array_b{1}=b2;
array_b{2}=b3;
array_b{3}=b4;
%activation matrices
arrayA=mat2cell(zeros(sum(numbWidthAll),1),numbWidthAll);
%delta (gradient) vectors
array_delta=mat2cell(zeros(sum(numbWidthAll(2:end)),1),numbWidthAll(2:end));

costHistory = zeros(numbSteps,1); %record the cost for each step
for i = 1:numbSteps
    %forward and back propagation
    indexTrain=randi(numbTrainAll);
    xTrain = x(:,indexTrain);

    %run forward pass
    arrayA{1}=xTrain; %treat input as the A1 matrix
    for j=2:numbLayer
        arrayA{j}=activate(arrayA{j-1},arrayW{j-1},array_b{j-1});
    end

    %run backward pass (to calculate the gradient) using Hadamard products
    A_temp=arrayA{numbLayer};
    array_delta{numbLayer-1}=A_temp.*(1-A_temp).*(A_temp-y(:,indexTrain));
    for j=numbLayer-1:-1:2
        A_temp=arrayA{j};
        delta_temp=array_delta{j};
        W_temp=arrayW{j};
        array_delta{j-1}= A_temp.*(1-A_temp).*(transpose(W_temp)*delta_temp);
    end

    %update using steepest descent
    %transpose of xTrains used for W matrices
    for j=1:numbLayer-1
        A_temp=arrayA{j};
        delta_temp=array_delta{j};
        arrayW{j}=arrayW{j} - rateLearn*delta_temp*transpose(A_temp);
        array_b{j}=array_b{j} - rateLearn*delta_temp;
    end

    %update cost
    costCurrent_i = getCost(x,y,arrayW,array_b,numbLayer);
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
    yTestSingle = feedForward(xTestSingle,arrayW,array_b,numbLayer);
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
function A_Last= feedForward(xSingle,arrayW,array_b,numbLayer)
%run forward pass
A_now=xSingle;
for j=2:numbLayer
    A_next=activate(A_now,arrayW{j-1},array_b{j-1});
    A_now=A_next;
end
A_Last=A_next;
end

function costTotal = getCost(x,y,arrayW,array_b,numbLayer)
numbTrainAll = max(size(x));
%originally y, x1 and x2 were defined outside this function
costAll = zeros(numbTrainAll,1);

for i = 1:numbTrainAll
    %loop through every training point
    x_i = x(:,i);

    A_Last=feedForward(x_i,arrayW,array_b,numbLayer);
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
    x_i = [x1(i);x2(i)]; %retrieve single point
    diff_x = xSeed-x_i;
    distSquared_x = diff_x(1,:).^2+diff_x(2,:).^2; %relative distance squared
    [~,indexVoronoiTemp] = min(distSquared_x); %find closest seed
    indexVoronoi(i) = indexVoronoiTemp;
end

% see if points are inside the Voronoi cell number indexCellSingle
booleVoronoiInside = (indexVoronoi==indexCellChosen);
end
