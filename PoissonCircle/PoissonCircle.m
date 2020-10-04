% Simulate a Poisson point process on a circle.
% Author: H. Paul Keeler, 2020.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

r=1; %radius of circle

%centre of circle
xx0=0; 
yy0=0; 
 
%Point process parameters
lambda=10; %intensity (ie mean density) of the Poisson process

lengthTotal=2*pi*r; %circumference of circle

%Simulate Poisson point process
numbPoints=poissrnd(lengthTotal*lambda);%Poisson number of points
theta=2*pi*(rand(numbPoints,1)); %angular coordinates
rho=r; %radial coordinates

%Convert from polar to Cartesian coordinates
[xx,yy]=pol2cart(theta,rho); %x/y coordinates of Poisson points

%Shift centre of circle to (xx0,yy0)
xx=xx+xx0;
yy=yy+yy0;
 
%Plotting
scatter(xx,yy,'b');
xlabel('x');ylabel('y');
axis square;
