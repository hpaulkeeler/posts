% This file plots a site percolation model of a bounded square lattice on 
% a torus. Unoccupied sites are grey disks, whereas occupied sites are 
% coloured disks. Two or more sites of the same colour indicates them 
% belonging to the same component, where their shared colour is that of the 
% root site. For the colouring, the plotting function sets the seed of 
% MATLAB's pseudo-random number generator. 
%
% The main input variable is the array arrPointer, which encodes
% information of the occupied and occupied sites, as well as the root sites 
% of componenets formed from the adjacent sites being occupied. The other 
% input parameter is valueEmpty, which indicates that a site is unoccupied. 
% Note that valueEmpty needs to be greater than the (negative) length of 
% the array arrPointer.

% The way that the array arrPointer stores encodes percolation information 
% was originally used in the C code presented in the appendix of the 
% paper[1] by Newman Ziff. More specfically, in the Appendix of the paper, 
% you'll find this explanation:
%
% "The array arrPointer serves triple duty: for nonroot occupied sites it 
% contains the label for the site’s parent in the tree (the ‘‘pointer’’); 
% root sites are recognized by a negative value of arrPointer, and that 
% value is equal to minus the size of the cluster; for unoccupied sites 
% arrPointer takes the value valueEmpty."
%
% Note: In the code here, I have changed the variables names in the origina 
% C code from ptr and EMPTY to arrPointer and valueEmpty, respectively.
%
% Author: H.Paul Keeler, 2022
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
%
% References:
% [1] 2001, Newman and Ziff, "Fast Monte Carlo algorithm for site or bond 
% percolation"

clearvars;
clc;
close all;

%%%TEST - A test permutation for 4 x 4 lattice %%%TEST
%arrPointer=[-4,1,-17,-17,1,-17,11,-17,-17,11,-3,-17,1,-17,-17,-17];
%
%%%TEST - A test permutation for 5 x 5 lattice %%%TEST
arrPointer=[-26,-1,-26,5,-3,-26,-26,-26,5,-26,-26,-26,-26,-26,-26,...
    -26,-26,-1,-26,-26,-1,-26,-26,-26,-26];

numbSite=length(arrPointer);   % total number of sites
valueEmpty = -numbSite-1; % negative number to indicate unconnected sites

%plot lattice of occupied and unoccupied sites
plotLatticeSite(arrPointer,valueEmpty)

function plotLatticeSite(arrPointer,valueEmpty)
%This is a helper function that draws a square lattice with occupied sites
% on a unit torus. Unoccupied sites are grey disks, whereas occupied sites
% are coloured disks. Two or more sites of the same colour indicates them
% belonging to the same component, where their shared colour is that of the
% root site.
%
% WARNING: Do not use for large lattice.

%retrieve other paramters
numbSite=length(arrPointer);   % total number of sites
dimLin=round(sqrt(numbSite));  % linear dimension

if numbSite<1000
    
    z=linspace(0,1,dimLin);
    [xx,yy]=meshgrid(z,z);
    
    %create matrix of random vectors for colours
    rng(11);
    colorAll=rand(numbSite,3); %each color is a different vector
    rng('default'); %reset pseudo-random number generator
    
    %size of markers
    sizeMarkerBig=round(200/dimLin); %occupied sites
    sizeMarkerSmall=round(sizeMarkerBig/1.5); %unoccupied sites
    
    %create figure and draw bonds in black of lattice on the unit square
    figure;
    hold on;
    plot(xx,yy,'k-'); %vertical lines
    plot(xx',yy','k-') %horizontal lines
    axis square; %square plot
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    %turn site-coordinate matrices into vectors
    xx=xx(:);
    yy=yy(:);
    
    %draw unnoccupied sites
    plot(xx,yy,'.','MarkerSize', sizeMarkerSmall, 'Color',[.5 .5 .5]);
    
    %number the points/cells
    %labels=cellstr(num2str((1:numbSite)'));%labels correspond to their order
    %text(xx(:)', yy(:)', labels, 'VerticalAlignment','bottom', ...
    %    'HorizontalAlignment','right');
    
    
    %find occupied sites (ie numbers > EMPTY)
    booleOccupied=arrPointer>valueEmpty;
    %find roots of all clusters (ie negative numbers > EMPTY)
    indexRoot=find(booleOccupied&(arrPointer<0));
    
    %loop through all the roots
    for rr=indexRoot
        %for each root, find the connected sites
        indexSiteRoot=find(arrPointer==rr);
        %append root
        indexCompTemp=[rr,indexSiteRoot];
        
        %choose corresponding root colour
        colorTemp=colorAll(rr,:);
        
        %plot the sites for each root and the root in the root colour
        plot(xx(indexCompTemp),yy(indexCompTemp),'.',...
            'MarkerSize', sizeMarkerBig, 'Color',colorTemp);
        
    end
    
else
    disp('Attempt to draw a latice with too many sites. Decrease size of lattice.');
end

end
