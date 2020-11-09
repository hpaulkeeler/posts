% Simulates a homogeneous Poisson point process on a circle.
% This code positions the points uniformly around a circle, which can be
% achieved by either using polar coordinates or normal random variables.
% Author: H. Paul Keeler, 2020.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% hpaulkeeler.com/simulating-a-poisson-point-process-on-a-circle/

r=1; %radius of circle

%centre of circle
xx0=0;
yy0=0;

%Point process parameters
lambda=10; %intensity (ie mean density) of the Poisson process

lengthTotal=2*pi*r; %circumference of circle

%Simulate Poisson point process
numbPoints=poissrnd(lengthTotal*lambda);%Poisson number of points

%%METHOD 1 for positioning points: Use polar coodinates
%theta=2*pi*(rand(numbPoints,1)); %angular coordinates
%rho=r; %radial coordinates

%%Convert from polar to Cartesian coordinates
%[xx,yy]=pol2cart(theta,rho); %x/y coordinates of Poisson points

%METHOD 2 for positioning points: Use normal random variables
xxRand=normrnd(0,1,numbPoints,2); %generate two sets of normal variables
normRand=vecnorm(xxRand,2,2); %Euclidean norms (across each row)
xxRandBall=xxRand./normRand; %rescale by Euclidean norms
xxRandBall=r*xxRandBall; %rescale for non-unit sphere
%retrieve x and y coordinates
xx=xxRandBall(:,1);
yy=xxRandBall(:,2);

%Shift centre of circle to (xx0,yy0)
xx=xx+xx0;
yy=yy+yy0;

%Plotting
scatter(xx,yy,'b');
xlabel('x');ylabel('y');
axis square;