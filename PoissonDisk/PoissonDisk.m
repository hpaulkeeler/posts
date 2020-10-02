% Simulate a Poisson point process on a disk.
% Author: H. Paul Keeler, 2018.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

%Simulation window parameters
r=1; %radius of disk
xx0=0; yy0=0; %centre of disk
areaTotal=pi*r^2; %area of disk
 
%Point process parameters
lambda=100; %intensity (ie mean density) of the Poisson process
 
%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
theta=2*pi*(rand(numbPoints,1)); %angular coordinates
rho=r*sqrt(rand(numbPoints,1)); %radial coordinates

%Convert from polar to Cartesian coordinates
[xx,yy]=pol2cart(theta,rho); %x/y coordinates of Poisson points

%Shift centre of disk to (xx0,yy0)
xx=xx+xx0;
yy=yy+yy0;
 
%Plotting
scatter(xx,yy);
xlabel('x');ylabel('y');
axis square;
