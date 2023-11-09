% Simulate a Poisson point process on the surface of a sphere.
% The Code can be modified to simulate the point  process *inside* the 
% sphere; see the post
% hpaulkeeler.com/simulating-a-poisson-point-process-on-a-sphere/
% Author: H. Paul Keeler, 2020.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% hpaulkeeler.com/simulating-a-poisson-point-process-on-a-sphere/

%Simulation window parameters
r=1; %radius of sphere
%centre of sphere
xx0=0; 
yy0=0; 
zz0=0;

%Point process parameters
lambda=10; %intensity (ie mean density) of the Poisson process

measureTotal=4*pi*r^2; %area of sphere
%use this line instead to uniformly place points *inside* the sphere
%measureTotal=4/3*pi*r^3; %volume of sphere

%Simulate Poisson point process
numbPoints=poissrnd(measureTotal*lambda);%Poisson number of points

% %METHOD 1 for positioning points: Use spherical coodinates
% phi=2*pi*(rand(numbPoints,1)); %azimuth angles
% V=2*rand(numbPoints,1)-1; %uniform asin(theta), where theta is the polar angle
% 
% %radial variables
% rho=ones(numbPoints,1);
% %use this line instead to uniformly place points *inside* the sphere
% %rho=r*(rand(numbPoints,1)).^(1/3); 
% 
% %calculate Cartesian coordinates
% xx=rho.*sqrt(1-V.^2).*cos(phi);
% yy=rho.*sqrt(1-V.^2).*sin(phi);
% zz=rho.*V;

%METHOD 2 for positioning points: Use normal random variables
xxRand=normrnd(0,1,numbPoints,3); %generate three sets of normal variables
normRand=vecnorm(xxRand,2,2); %Euclidean norms (across each row)
xxRandBall=xxRand./normRand; %rescale by Euclidean norms
xxRandBall=r*xxRandBall; %rescale for non-unit sphere
%retrieve x and y coordinates
xx=xxRandBall(:,1);
yy=xxRandBall(:,2);
zz=xxRandBall(:,3);

%Shift centre of sphere to (xx0,yy0,zz0)
xx=xx+xx0;
yy=yy+yy0;
zz=zz+zz0;
 
%Plotting
markerSize=300;
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
%Shift centre of sphere to (xx0,yy0,zz0)
xMesh=xMesh+xx0;
yMesh=yMesh+yy0;
zMesh=zMesh+zz0;
%do a surface plot with a clear faces 
surface(xMesh,yMesh,zMesh,'FaceColor', 'none');
