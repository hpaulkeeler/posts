% This code takes a single realization of a (homogeneous) Poisson point 
% process on a rectangle and opies or tiles it, wrapping around the 
% original rectangle. 
% 
% It can also tile a random Poisson point process, meaning each tile will 
% have a different realization
%
% Author: H. Paul Keeler, 2022.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts

clearvars; close all; clc;

numbSimS=1; %number of street simulations
seedRandS=5; %random seed for reproducing results (-1 to use computer seed)
boolePlot=1; %set to 1 to plot street layout, 0 for no plot

choiceTile=1; %1 tile a single realization; 2 tile the random point process
numbWrap=1; %number tiles tiles are wrapped around centre tile

%Poisson point process parameter
lambdaS=5; %intensity (ie mean density) of the Poisson point process

%Simulation window parameters
xDelta=1; %width
yDelta=1; %height
x0=0; %x centre
y0=0; %y centre
xMin=x0-xDelta/2; %minimum x value
xMax=x0+xDelta/2; %maximum x value
yMin=y0-yDelta/2; %minimum y value
yMax=y0+yDelta/2; %maximum y value
areaTotal=xDelta*yDelta; %area of (inner) simulation window

%plotting parameters
%simulation window dimensions
dimBox=[xMin, yMin, xDelta, yDelta];
%axis limits
xAxisLim=[xMin, xMax]*1.2;
yAxisLim=[yMin, yMax]*1.2;

if seedRandS==-1
    %retrieves random seed used by computer
    seedRandS=rng().Seed;
else
    %sets random seed
    rng(seedRandS);
end

%tiling parameters
numbSide=(2*numbWrap+1); %width of tiling (ie number of tiles across)
numbTile=numbSide^2; %total number of tiles

for ss=1:numbSimS
    %loop through each simulation
    
    %%%START - Simulate Poisson point process - START%%%
    if choiceTile==1
        %tile realization
        numbPointsSingle=poissrnd(areaTotal*lambdaS);
        %Poisson number of points (repeated numbTile times)
        numbPoints=repmat(numbPointsSingle,numbTile,1);
        numbPointsTotal=sum(numbPoints); % number of points in all the tiles
        %x/y coordinates of a realization of Poisson process
        xxSingle=xDelta*(rand(numbPointsSingle,1))+xMin;
        yySingle=yDelta*(rand(numbPointsSingle,1))+yMin;
        %repeat realization numbTile times
        xx=repmat(xxSingle,numbTile,1);
        yy=repmat(yySingle,numbTile,1);
        
    elseif choiceTile==2
        %tile point process
        %numbTile number of Poisson number of points
        numbPoints=poissrnd(areaTotal*lambdaS,numbTile,1);
        numbPointsTotal=sum(numbPoints); % number of points in all the tiles
        %x/y coordinates of copies of a Poisson process
        xx=xDelta*(rand(numbPointsTotal,1))+xMin;
        yy=yDelta*(rand(numbPointsTotal,1))+yMin;
    else
        %Test case - KEEP FOR Python code
        xxSingle=[-.3;-.4;0;.2;.1;.2]/2;
        yySingle=[.4;.3;.1;.1;.3;.4];
        numbPointsSingle=numel(xxSingle);
        numbPoints=repmat(numbPointsSingle,numbTile,1);
        numbPointsTotal=sum(numbPoints); % number of points in all the tiles
                %repeat realization numbTile times
        xx=repmat(xxSingle(:),numbTile,1);
        yy=repmat(yySingle(:),numbTile,1);
    end
        
    % convert to cell arrays, where each cell is a tile
    xxTiledCell=mat2cell(xx,numbPoints);
    yyTiledCell=mat2cell(yy,numbPoints);
    %%%END - Simulate Poisson point process - END%%%
    
    %%%START - Tile point process by shifting x/y values - START%%%
    xShift=xDelta*(-numbWrap:numbWrap); %all possible x value shifts
    yShift=yDelta*(-numbWrap:numbWrap); %all possible y value shifts
    
    % update plotting boole variable (ie no plot with two many points)
    boolePlotSim=boolePlot&&(numbPointsTotal<100*numbTile);
    % create figure
    if boolePlotSim&&(ss==numbSimS)
        figure;
        hold on;
    end
    
    countTile=1; %initialize tile count
    for ii=1:numbSide
        %loop through each x shift (corresponding to horizontal tiling)
        
        for jj=1:numbSide
            %loop through each y shift (corresponding to vertical tiling)
            
            %shift x and y values
            xxTiledCell{countTile}=xxTiledCell{countTile}+xShift(ii);
            yyTiledCell{countTile}=yyTiledCell{countTile}+yShift(jj);
            
            if boolePlotSim&&(ss==numbSimS)
                %plot each tile
                xxPlot=xxTiledCell{countTile};
                yyPlot=yyTiledCell{countTile};
                colorTemp=rand(1,3); %each color is a different vector
                plot(xxPlot,yyPlot,'.','MarkerSize',16,'Color',colorTemp);
                %update box/tile dimensions
                dimBoxTemp=[xMin+xShift(ii), yMin+yShift(jj), xDelta, yDelta];
                %draw box in black
                rectangle('Position',dimBoxTemp,'EdgeColor','k');
                
                %if last tile, adjust plot settings
                if countTile==numbTile
                    xlim([-numbSide*xDelta, numbSide*xDelta]/2);
                    ylim([-numbSide*xDelta, numbSide*xDelta]/2);
                    %remove ticks on x and y axes
                    xticks([]);
                    yticks([]);
                    set(gca,'xcolor','none','ycolor','none'); %remove axis lines
                end
            end
            countTile=countTile+1;
        end
    end
    
    %turn coordinate cell arrays into 1-D vectors
    xxTiled=cell2mat(xxTiledCell);
    yyTiled=cell2mat(yyTiledCell);
    %%%END - Tile point process by shifting x/y values - END%%%    
end