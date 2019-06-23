% Simulate a Cox point process on a disk. 
% This Cox point process is formed by first simulating a uniform Poisson 
% line process. On each line (or segment) an independent Poisson point 
% process is then simulated.
% Author: H. Paul Keeler, 2019.

close all; clearvars; clc;

%%%START Parameters START%%%
%Cox (ie Poisson line-point) process parameters
lambda=2; %intensity (ie mean density) of the Poisson *line* process
mu=3; %intensity (ie mean density) of the Poisson *point* process

%Simulation disk dimensions
xx0=0; yy0=0; %center of disk
r=1; %disk radius
massLine=2*pi*r*lambda; %total measure/mass of the line process
%%%END Parameters END%%%

%%%START Simulate a Poisson line process on a disk START%%%
%Simulate Poisson point process
numbLines=poissrnd(massLine);%Poisson number of lines
theta=2*pi*rand(numbLines,1); %choose angular component uniformly
p=r*rand(numbLines,1); %choose radial component uniformly
q=sqrt(r.^2-p.^2); %distance to circle edge (alonge line)

%calculate trig values
sin_theta=sin(theta);
cos_theta=cos(theta);

%calculate segment endpoints of Poisson line process
xx1=xx0+p.*cos_theta+q.*sin_theta;
yy1=yy0+p.*sin_theta-q.*cos_theta;
xx2=xx0+p.*cos_theta-q.*sin_theta;
yy2=yy0+p.*sin_theta+q.*cos_theta;
%%%END Simulate a Poisson line process on a disk END%%%

%%%START Simulate a Poisson point processes on each line START%%%
lengthLine=2*q; %length of each segment
massPoint=mu*lengthLine;%mass on each line
numbLinePoints=poissrnd(massPoint); %Poisson number of points on each line
numbLinePointsTotal=sum(numbLinePoints);
uu=2*rand(numbLinePointsTotal,1)-1; %uniform variables on (-1,1)

%replicate values to simulate points all in one step
xx0_all=repelem(xx0,numbLinePointsTotal);
yy0_all=repelem(yy0,numbLinePointsTotal);
p_all=repelem(p,numbLinePoints);
q_all=repelem(q,numbLinePoints);
sin_theta_all=repelem(sin_theta,numbLinePoints);
cos_theta_all=repelem(cos_theta,numbLinePoints);

%position points on Poisson lines/segments
xxPP_all=xx0_all+p_all.*cos_theta_all+q_all.*uu.*sin_theta_all;
yyPP_all=yy0_all+p_all.*sin_theta_all-q_all.*uu.*cos_theta_all;
%%% END Simulate a Poisson point processes on each line %%%END

%%% START Plotting %%%START
%plot circle
t=linspace(0,2*pi,200);
xp=r*cos(t); yp=r*sin(t);
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');

%plot segments of Poisson line process
plot([xx1';xx2'],[yy1';yy2'],'b'); 
%plot Poisson points on line process
plot(xxPP_all,yyPP_all,'r.','MarkerSize',10); 
%%%END Plotting END%%%
