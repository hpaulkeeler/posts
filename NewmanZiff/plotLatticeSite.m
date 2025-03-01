% This is a helper function that draws a square lattice with occupied sites
% on a unit torus. Unoccupied sites are grey disks, whereas occupied sites
% are coloured disks. Two or more sites of the same colour indicates them
% belonging to the same component, where their shared colour is that of the
% root site.
%
% WARNING: Do not use for large lattice.

function plotLatticeSite(arrPointer,valueEmpty)


%retrieve other paramters
numbSite=length(arrPointer);   % total number of sites
dimLin=round(sqrt(numbSite));  % linear dimension

if numbSite<1000
    
    z=linspace(0,1,dimLin);
    [xx,yy]=meshgrid(z,z);
    
    %create matrix of random vectors for colours
    %rng(11);
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
    disp('Attempt to draw a lattice with too many sites. Decrease size of lattice.');
end

end
