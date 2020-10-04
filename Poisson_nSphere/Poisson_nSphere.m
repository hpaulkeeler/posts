% Simulate a Poisson point process on the surface of an n-dimensional
% ball (that is, a (n-1)-dimensional sphere).
% Author: H. Paul Keeler, 2020.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

close all; clearvars

numbDim=2; %number of dimensions of embedding (regular sphere numbDim=3)

r=1; %radius of sphere

%Point process parameters
lambda=5; %intensity (ie mean density) of the Poisson process

%surface area of d-dimensional ball
areaTotal=2*pi^(numbDim/2)*r^(numbDim-1)/gamma(numbDim/2);

measureTotal=areaTotal*lambda; %total measure

%Simulate Poisson point process
numbPoints=poissrnd(measureTotal);%Poisson number of points

xxRand=normrnd(0,1,numbPoints,numbDim);
normRand=vecnorm(xxRand,2,2); %Euclidean norms (across each row)
xxRandBall=xxRand./normRand; %rescale by Euclidean norms
xxRandBall=r*xxRandBall; %rescale for non-unit sphere

%Plotting
if numbDim==2
    %disk
    xx=xxRandBall(:,1);
    yy=xxRandBall(:,2);
    markerSize=20;
    plot(xx,yy,'b.','MarkerSize',markerSize);
    xlabel('x');
    ylabel('y');
    axis square;
end

if numbDim==3
    %sphere
    xx=xxRandBall(:,1);
    yy=xxRandBall(:,2);
    zz=xxRandBall(:,3);
    markerSize=200;
    scatter3(xx,yy,zz,markerSize,'b.');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    axis square;
    hold on;
    
    %create mesh to plot the outline of a sphere
    numbMesh=20;
    [thetaMesh, phiMesh] = meshgrid(linspace(0, pi, numbMesh), linspace(0, 2*pi, numbMesh));
    %convert to Cartesian coordinates
    [xMesh,yMesh,zMesh] = sph2cart(thetaMesh, phiMesh, r);
    %do a surface plot with a clear faces
    surface(xMesh,yMesh,zMesh,'FaceColor', 'none');
end
