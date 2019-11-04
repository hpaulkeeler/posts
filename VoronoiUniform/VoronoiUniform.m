% This code generates a Voronoi-Poisson tessellation
% A (homogeneous) Poisson point process (PPP) is created on a rectangle.
% Then the Voronoi tesselation is found using the MATLAB function[1], which
% is based on the Qhull project[2] .
% All points (or cells) of the PPP are numbered arbitrarily.
% In each *bounded* Voronoi cell a new point is uniformly placed.
%
% The placement step is done by first dividing each (bounded) Voronoi cell
% (ie an irregular polygon) with, say, m sides into m scalene triangles.
% The i th triangle is then randomly chosen based on the ratio of areas.
% A point is then uniformly placed on the i th triangle (via eq. 1 in [3]).
% The placement step is repeated for all bounded Voronoi cells.
%
% A Voronoi diagram is displayed over the PPP. Points of the underlying PPP
% are marked green and blue if they are located respectively in bounded and
% unbounded Voronoi cells. The uniformly placed points in the bounded
% cells are marked red.
%
% If there are no bounded Voronoi cells, no diagram is created.
%
% Author: H.Paul Keeler, 2019
%
% [1] http://www.mathworks.com.au/help/matlab/ref/voronoin.html
% [2] http://www.qhull.org/
% [2] Osada, R., Funkhouser, T., Chazelle, B. and Dobkin. D.,
% "Shape distributions", ACM Transactions on Graphics, vol 21, issue 4,
% 2002

clearvars; close all; clc;

%Simulation window parameters
xMin=0;
xMax=1;
yMin=0;
yMax=1;
%rectangle dimensions
xDelta=xMax-xMin; %width 
yDelta=yMax-yMin; %height
areaTotal=xDelta*yDelta; %area of simulation window

%Point process parameters
lambda=20; %intensity (ie mean density) of the Poisson process

%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
xx=xDelta*(rand(numbPoints,1))+xMin;%x coordinates of Poisson points
yy=xDelta*(rand(numbPoints,1))+yMin;%y coordinates of Poisson points

xxyy=[xx(:) yy(:)]; %combine x and y coordinates
%Perform Voronoi tesseslation using built-in function
[vertexAll,cellAll]=voronoin(xxyy);
%vertexAll is x/y coordinates of all vertices
numbCells=numbPoints; %number of Voronoi cells (including unbounded)

%initiate arrays
booleBounded=zeros(numbCells,1);
uu=zeros(numbCells,1);
vv=zeros(numbCells,1);

%Loop through for all Voronoi cells
for ii=1:numbCells
    %check for unbounded cells (index 1 corresponds to a point at infinity)
    booleBounded(ii)=~(any((cellAll{ii})==1));
    
    %checks if the Voronoi cell is bounded. if bounded, calculates its area
    %and assigns a single point uniformly in the Voronoi cell.
    
    %%%START-- Randomly place a point in a bounded Voronoi cell --START%%%
    if booleBounded(ii)
        xx0=xx(ii);yy0=yy(ii); %the (Poisson) point of the Voronoi cell
        %x/y values for current cell
        xxCell=vertexAll(cellAll{ii},1);
        yyCell=vertexAll(cellAll{ii},2);
        
        %%% START -- Caclulate areas of triangles -- START%%%
        %calculate area of triangles of bounded cell (ie irregular polygon)
        numbTri=length(xxCell); %number of triangles
        %create some indices for calculating triangle areas
        indexVertex=1:(numbTri+1); %number vertices
        indexVertex(end)=1; %repeat first index (ie returns to the start)
        indexVertex1=indexVertex(1:numbTri); %first vertex index
        indexVertex2=indexVertex(2:numbTri+1);  %second vertex index
        %calculate areas of triangles using shoelace formula
        areaTri=abs((xxCell(indexVertex1)-xx0).*(yyCell(indexVertex2)-yy0)...
            -(xxCell(indexVertex2)-xx0).*(yyCell(indexVertex1)-yy0))/2;
        areaPoly=sum(areaTri); %total area of cell/polygon
        %%%END-- Caclulate areas of triangles -- END%%%
        
        %%%START -- Randomly placing point -- START%%%
        %%% place a point uniformaly in the (bounded) polygon
        %randomly choose the triangle (from the set that forms the polygon)
        cdfTri=cumsum(areaTri)/areaPoly; %create triangle CDF
        indexTri=find(rand(1,1)<=cdfTri,1); %use CDF to choose #
        
        indexVertex1=indexVertex(indexTri); %first vertex index
        indexVertex2=indexVertex(indexTri+1); %second vertex index
        %for all triangles
        xxTri=[xx0, xxCell(indexVertex1),xxCell(indexVertex2)];
        yyTri=[yy0, yyCell(indexVertex1),yyCell(indexVertex2)];
        
        %create two sets of uniform random variables on unit interval
        uniRand1=rand(1,1); uniRand2=rand(1,1);
        
        %point is uniformly placed in the triangle via equation (1)in [2]
        %x coordinate (via eq. 1 in [3])
        uu(ii)=(1-sqrt(uniRand1))*xxTri(1)...
            +sqrt(uniRand1)*(1-uniRand2)*xxTri(2)...
            +sqrt(uniRand1)*uniRand2*xxTri(3);
        %y coordinate (via eq. 1 in [3])
        vv(ii)=(1-sqrt(uniRand1))*yyTri(1)...
            +sqrt(uniRand1)*(1-uniRand2)*yyTri(2)...
            +sqrt(uniRand1)*uniRand2*yyTri(3);
        %%%END -- Randomly placing point -- END%%%
        
    end
    %%% END -- Randomly place a point in a Voronoi cell -- END%%%
end

indexBounded=find(booleBounded==1); %find bounded cells
%remove unbounded cells
uu=uu(indexBounded); 
vv=vv(indexBounded); 
numbBounded=length(indexBounded); %number of bounded cells
percentBound=numbBounded/numbCells; %percent of bounded Voronoi cells

%%%START -- Plotting section -- START%%%
if (numbBounded>0)
    figure; hold on;
    %create voronoi diagram on the point pattern
    voronoi(xx,yy);
    %plot the underlying point pattern
    plot(xx,yy,'b.','MarkerSize',20);        
    %put a red point uniformly in each bounded Voronoi cell
    plot(uu,vv,'r.','MarkerSize',20);
    
    %number the points/cells
    labels=cellstr(num2str((1:numbPoints)'));%labels correspond to their order
    text(xx, yy, labels, 'VerticalAlignment','bottom', ...
        'HorizontalAlignment','right');    
end
%%%END -- Plotting section -- END%%%