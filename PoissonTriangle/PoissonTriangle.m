% Simulate a Poisson point process on a triangle.
% Author: H. Paul Keeler, 2018.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

%Simulation window parameters -- points A,B,C of a triangle
xA=0;xB=1;xC=1; %x values of three points
yA=0;yB=0;yC=1; %y values of three points

%Point process parameters
lambda=100; %intensity (ie mean density) of the Poisson process

%calculate sides of triangle
a=sqrt((xA-xB)^2+(yA-yB)^2);
b=sqrt((xB-xC)^2+(yB-yC)^2);
c=sqrt((xC-xA)^2+(yC-yA)^2);
s=(a+b+c)/2; %calculate semi-perimeter

%Use Herron's formula - or use polyarea - to calculate the area of triangle
areaTotal=(1/4)*sqrt( (a+(b+c))*(c-(a-b))*(c+(a-b))*(a+(b-c))); 

%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
U=(rand(numbPoints,1));%uniform random variables
V=(rand(numbPoints,1));%uniform random variables

%places points uniformly on triangle
xx=sqrt(U)*xA+sqrt(U).*(1-V)*xB+sqrt(U).*V*xC;%x coordinates of points
yy=sqrt(U)*yA+sqrt(U).*(1-V)*yB+sqrt(U).*V*yC;%y coordinates of points

%Plotting
scatter(xx,yy);
xlabel('x');ylabel('y');