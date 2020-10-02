% Simulate a binomial point process on a unit square.
% Author: H. Paul Keeler, 2018.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

numbPoints=10; %number of points

%Simulate binomial point process
xx=rand(numbPoints,1);%x coordinates of Poisson points
yy=rand(numbPoints,1);%y coordinates of Poisson points

%Plotting
scatter(xx,yy);
xlabel('x');ylabel('y');
