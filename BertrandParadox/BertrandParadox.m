% Illustrate the three solutions of the Bertrand paradox on a disk.
% The paradox asks what is the probability of a random chord in a 
% circle being greater than a side of equilateral triangle inscribed in
% the circle. Traditionally this problem has three different solutions.
% The three solutions are labelled A, B and C, which correspond to
% solutions 1, 2 and 3 in, for example, the Wikipedia article:
% https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
% The empirical estimates are also done for the probability of the chord 
% length being greater than the side of the triangle. 
% The results are not plotted if the number of lines is equal to or 
% greater than a thousand (ie numbLines<1000 for plotting).
% Author: H. Paul Keeler, 2019.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% hpaulkeeler.com/the-bertrand-paradox/

close all; clearvars; clc;

%%%START Parameters START%%%
%Simulation disk dimensions
xx0=0; yy0=0; %center of disk
r=1; %disk radius
numbLines=10^5;%number of lines
%%%END Parameters END%%%

%%%START Simulate three solutions on a disk START%%%
%Solution A
thetaA1=2*pi*rand(numbLines,1); %choose angular component uniformly
thetaA2=2*pi*rand(numbLines,1); %choose angular component uniformly

%calculate chord endpoints
xxA1=xx0+r*cos(thetaA1);
yyA1=yy0+r*sin(thetaA1);
xxA2=xx0+r*cos(thetaA2);
yyA2=yy0+r*sin(thetaA2);
%calculate midpoints of chords
xxA0=(xxA1+xxA2)/2; yyA0=(yyA1+yyA2)/2;

%Solution B
thetaB=2*pi*rand(numbLines,1); %choose angular component uniformly
pB=r*rand(numbLines,1); %choose radial component uniformly
qB=sqrt(r.^2-pB.^2); %distance to circle edge (along line)

%calculate trig values
sin_thetaB=sin(thetaB);
cos_thetaB=cos(thetaB);

%calculate chord endpoints
xxB1=xx0+pB.*cos_thetaB+qB.*sin_thetaB;
yyB1=yy0+pB.*sin_thetaB-qB.*cos_thetaB;
xxB2=xx0+pB.*cos_thetaB-qB.*sin_thetaB;
yyB2=yy0+pB.*sin_thetaB+qB.*cos_thetaB;
%calculate midpoints of chords
xxB0=(xxB1+xxB2)/2; yyB0=(yyB1+yyB2)/2;

%Solution C
%choose a point uniformly in the disk
thetaC=2*pi*rand(numbLines,1); %choose angular component uniformly
pC=r*sqrt(rand(numbLines,1)); %choose radial component
qC=sqrt(r.^2-pC.^2); %distance to circle edge (alonge line)

%calculate trig values
sin_thetaC=sin(thetaC);
cos_thetaC=cos(thetaC);

%calculate chord endpoints
xxC1=xx0+pC.*cos_thetaC+qC.*sin_thetaC;
yyC1=yy0+pC.*sin_thetaC-qC.*cos_thetaC;
xxC2=xx0+pC.*cos_thetaC-qC.*sin_thetaC;
yyC2=yy0+pC.*sin_thetaC+qC.*cos_thetaC;
%calculate midpoints of chords
xxC0=(xxC1+xxC2)/2; yyC0=(yyC1+yyC2)/2;
%%%END Simulate three solutions on a disk END%%%

%%%START Do some statistics on chord lengths START%%%
lengthSide=r*sqrt(3); %length of triangle side
%chord lengths
lengthA=hypot(xxA1-xxA2,yyB1-yyB2); %Method A
lengthB=hypot(xxB1-xxB2,yyB1-yyB2); %Method B
lengthC=hypot(xxC1-xxC2,yyC1-yyC2); %Method C

%estimated probability of chord being longer than triangle side
probEstA=mean(lengthA>lengthSide) %Method A
probEstB=mean(lengthB>lengthSide) %Method B
probEstC=mean(lengthC>lengthSide) %Method C
%%%END Do some statistics on chord lengths END%%%

%Plot if there are less than a thousand lines.
if numbLines<1000     
    %create points for circle
    t=linspace(0,2*pi,200);
    xp=r*cos(t); yp=r*sin(t);
    
    %%% START Plotting START %%%
    %Solution A
    figure;
    subplot(1,2,1);
    %draw circle
    plot(xx0+xp,yy0+yp,'k');
    axis square; hold on;
    xlabel('x'); ylabel('y');
    title('Chords of Solution A');
    %plot chords of Solution A
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
    title('Chords of Solution B');
    %plot chords of Solution B
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
    title('Chords of Solution C');
    %plot chords of Solution C
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
end
