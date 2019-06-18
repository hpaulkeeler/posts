% Illustrate the three solutions of the Betrand paradox on a disk.
% The three solutions are labelled A, B and C, which correspond to
% solutions 1, 2 and 3 in, for example, the Wikipedia article:
% https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
% Author: H. Paul Keeler, 2019.

close all; clearvars; clc;

%%%START Parameters START%%%
%Simulation disk dimensions
xx0=0; yy0=0; %center of disk
r=1; %disk radius
numbLines=200;%number of lines
%%%END Parameters END%%%

%%%START Simulate three solutions on a disk START%%%
%Solution A
thetaA1=2*pi*rand(numbLines,1); %choose angular component uniformly
thetaA2=2*pi*rand(numbLines,1); %choose angular component uniformly

%calculate segment endpoints
xxA1=xx0+r*cos(thetaA1);
yyA1=yy0+r*sin(thetaA1);
xxA2=xx0+r*cos(thetaA2);
yyA2=yy0+r*sin(thetaA2);
%calculate midpoints of segments
xxA0=(xxA1+xxA2)/2; yyA0=(yyA1+yyA2)/2;

%Solution B
thetaB=2*pi*rand(numbLines,1); %choose angular component uniformly
pB=r*rand(numbLines,1); %choose radial component uniformly
qB=sqrt(r.^2-pB.^2); %distance to circle edge (alonge line)

%calculate trig values
sin_thetaB=sin(thetaB);
cos_thetaB=cos(thetaB);

%calculate segment endpoints
xxB1=xx0+pB.*cos_thetaB+qB.*sin_thetaB;
yyB1=yy0+pB.*sin_thetaB-qB.*cos_thetaB;
xxB2=xx0+pB.*cos_thetaB-qB.*sin_thetaB;
yyB2=yy0+pB.*sin_thetaB+qB.*cos_thetaB;
%calculate midpoints of segments
xxB0=(xxB1+xxB2)/2; yyB0=(yyB1+yyB2)/2;

%Solution C
%choose a point uniformly in the disk
thetaC=2*pi*rand(numbLines,1); %choose angular component uniformly
pC=r*sqrt(rand(numbLines,1)); %choose radial component
qC=sqrt(r.^2-pC.^2); %distance to circle edge (alonge line)

%calculate trig values
sin_thetaC=sin(thetaC);
cos_thetaC=cos(thetaC);

%calculate segment endpoints
xxC1=xx0+pC.*cos_thetaC+qC.*sin_thetaC;
yyC1=yy0+pC.*sin_thetaC-qC.*cos_thetaC;
xxC2=xx0+pC.*cos_thetaC-qC.*sin_thetaC;
yyC2=yy0+pC.*sin_thetaC+qC.*cos_thetaC;
%calculate midpoints of segments
xxC0=(xxC1+xxC2)/2; yyC0=(yyC1+yyC2)/2;
%%%END Simulate three solutions on a disk END%%%

%create points for circle
t=linspace(0,2*pi,200);
xp=r*cos(t); yp=r*sin(t);

%%% START Plotting %%%START
%Solution A
figure;
subplot(1,2,1);
%draw circle
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');
title('Segments of Solution A');
%plot segments of Solution A
plot([xxA1';xxA2'],[yyA1';yyA2'],'r');
subplot(1,2,2);
%draw circle
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');
title('Midpoints of Solution A');
%plot midpoints of Solution A
plot(xxA0,yyA0,'r.','MarkerSize',10);

%Solution B
figure;
subplot(1,2,1);
%draw circle
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');
title('Segments of Solution B');
%plot segments of Solution B
plot([xxB1';xxB2'],[yyB1';yyB2'],'b');
subplot(1,2,2);
%draw circle
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');
title('Midpoints of Solution B');
%plot midpoints of Solution B
plot(xxB0,yyB0,'b.','MarkerSize',10);

%Solution C
figure;
subplot(1,2,1);
%draw circle
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');
title('Segments of Solution C');
%plot segments of Solution C
plot([xxC1';xxC2'],[yyC1';yyC2'],'g');
subplot(1,2,2);
%draw circle
plot(xx0+xp,yy0+yp,'k');
axis square; hold on;
xlabel('x'); ylabel('y');
title('Midpoints of Solution C');
%plot midpoints of Solution C
plot(xxC0,yyC0,'g.','MarkerSize',10);
%%%END Plotting END%%%
