% Consider a collection of (finite) line segments scattered on a
% two-dimensional (finite) window. This code finds the points where the
% segments intersect with a rectangular box with its parallel to the
% Cartesian axes.
%
% The intersection points are found by first deriving the linear equations
% (with form y=mx+c) of the corresponding lines of each segment. Then the
% x and y (interception) values are calculated based on the dimensions of
% the rectangular box.
%
% The segments are then truncuated, so that only segments inside the box
% remain.
%
% The results are also plotted if there are less than 30 segments.
%
% Labelling convention: N, S, E, W for North, South, East, West edges of the
% box, meaning the top, bottom, right, and left sides of the box.
%
% Author: H. Paul Keeler, 2022.
% Website: hpaulkeeler.com
% Repository: github.com/hpaulkeeler/posts
% For more details, see the post:
% hpaulkeeler.com/line-segments-intersecting-with-a-rectangle/

clearvars; close all; clc;

rng(3); %seed random number generator for reproducing results

%simulation window parameters
%rectangle dimensions
xDelta=1; %width
yDelta=1; %height
x0=0; %x centre
y0=0; %y centre
%rectangle corners
xMin=x0-xDelta/2; %minimum x value
xMax=x0+xDelta/2; %maximum x value
yMin=y0-yDelta/2; %minimum y value
yMax=y0+yDelta/2; %maximum y value

%box dimensions
dimBox=[xMin, yMin, xDelta, yDelta];

%extended simulation windows parameters
%delta scale
scaleDeltaExt=1.5;
xDeltaExt=xDelta*scaleDeltaExt;
yDeltaExt=yDelta*scaleDeltaExt;
%rectangle corners
xMinExt=x0-xDeltaExt/2;
xMaxExt=x0+xDeltaExt/2;
yMinExt=y0-yDeltaExt/2;
yMaxExt=y0+yDeltaExt/2;
areaTotalExt=xDeltaExt*yDeltaExt; %area of extended rectangle

%extended simulation window dimensions
xLim=[xMinExt, xMaxExt];
yLim=[yMinExt, yMaxExt];

%Simulate Binomial point process on extended window for the segment ends
numbSegs=10;%number of segements
xxSeg=xDeltaExt*(rand(2,numbSegs))+xMinExt;%x coordinates
yySeg=yDeltaExt*(rand(2,numbSegs))+yMinExt;%y coordinates

%%%START - Test Case - START%%%
%x and y coordinates of segments
%xxSeg=[-6,-2,-6,2,3;-3,-2,6,4,6]/10;
%yySeg=[-4,-6,3,2,6;-6,4,3,1,7]/10;
%numbSegs=length(xxSeg(1,:));  
%%%END - Test Case - END%%%

%Label convention: N, E, S, W for North, East, South, West edges of the box

%%%START - Helper Functions - START%%%
%check if a number s is inside an interval [sMin,sMax]
funBooleIn=@(s,sMin,sMax)(s>=sMin&s<=sMax);
%checks if x or y value of edge crosses vertical or horizontal boundary
funBooleCrossBound=@(z1,z2,zBound)(xor(z1>=zBound,z2>=zBound));

%define functions for line parameters
fun_m=@(x1,y1,x2,y2)((y2-y1)./(x2-x1)); %slope value
fun_y0=@(x,y,c)(y-c.*x); %y intercept value
fun_x=@(y,y0,c)(y-y0)./c; %find x value given y, m, c
fun_y=@(x,m,c)(m.*x+c); %find y value given x, m, c
%%% END -- Helper Functions -- END %%%

%%% START -- Sort x and y by x values -- START %%%
xxSegTemp=xxSeg;
yySegTemp=yySeg;
%need to swap x values for calculating gradients
booleSwap=(xxSeg(1,:)>xxSeg(2,:));  %find where x values need swapping
%swap x values based on x values so smallest x value is first (ie left)
xxSeg(1,booleSwap)=xxSegTemp(2,booleSwap);
xxSeg(2,booleSwap)=xxSegTemp(1,booleSwap);
%swap y values based on x values
yySeg(1,booleSwap)=yySegTemp(2,booleSwap);
yySeg(2,booleSwap)=yySegTemp(1,booleSwap);
%%% END -- Sort by x values --  END %%%

%%% START -- Find segment/line parameters -- START %%%
%calculate gradients/slopes (ie m value) for all edges
slopeSeg=fun_m(xxSeg(1,:),yySeg(1,:),xxSeg(2,:),yySeg(2,:));
%calcualte y intersecpts of all edges
yInterSeg=fun_y0(xxSeg(2,:),yySeg(2,:),slopeSeg);

%find the segments that intersect with the box edges/boundaries
%x values for north and south box edges
xSegN=fun_x(yMax,yInterSeg,slopeSeg);
xSegS=fun_x(yMin,yInterSeg,slopeSeg);
%y values for east and west box edges
ySegE=fun_y(xMax,slopeSeg,yInterSeg);
ySegW=fun_y(xMin,slopeSeg,yInterSeg);
%%% END -- Find segment/line parameters -- END %%%

%%%START - Various indicators such as segments crossing edges - START%%%
%indicator fuctions that are outside box (infinitely extended) boundaries
booleN=yySeg>yMax; %segment ends above the north box edge
booleS=yySeg<yMin; %segment ends below the south box edge
booleE=xxSeg>xMax; %segment ends right of the east box edge
booleW=xxSeg<xMin; %segment ends left of the westbox edge

%segment ends that lie ubside the box
booleIn=(~booleE)&(~booleW)&(~booleN)&(~booleS);
%segment ends that lie outside the box
booleOut=~booleIn;
%find segment *both* ends lie  outside the box
booleOutBoth=and(booleOut(1,:),booleOut(2,:));

%segments crossing north box edge
booleCrossBoxN=funBooleCrossBound(yySeg(1,:),yySeg(2,:),yMax)...
    &funBooleIn(xSegN,xMin,xMax);
%segments crossing south box edge
booleCrossBoxS=funBooleCrossBound(yySeg(1,:),yySeg(2,:),yMin)...
    &funBooleIn(xSegS,xMin,xMax);
%segments crossing east box edge
booleCrossBoxE=funBooleCrossBound(xxSeg(1,:),xxSeg(2,:),xMax)...
    &funBooleIn(ySegE,yMin,yMax);
%segments crossing west box edge
booleCrossBoxW=funBooleCrossBound(xxSeg(1,:),xxSeg(2,:),xMin)...
    &funBooleIn(ySegW,yMin,yMax);

%find non-intersecting (with box) segments
booleNoCrossBox=((~booleCrossBoxN)&(~booleCrossBoxS)...
    &(~booleCrossBoxE)&(~booleCrossBoxW));

%keep edges interior and intersecting segments
booleKeep=~(booleNoCrossBox&booleOutBoth);
%%%END - Various indicators such as segments crossing edges - END%%%

%%%START - Replace old segment ends with new ones - START%%%
%find new edge end values for intersecting edges
%north box edge
xxSegTruncN=xSegN(booleCrossBoxN);
yySegTruncN=yMax*ones(size(xxSegTruncN));
%south box edge
xxSegTruncS=xSegS(booleCrossBoxS);
yySegTruncS=yMin*ones(size(xxSegTruncS));
%east box edge
xxSegTruncE=ySegE(booleCrossBoxE);
yySegTruncE=xMax*ones(size(xxSegTruncE));
%west box edge
xxSegTruncW=ySegW(booleCrossBoxW);
yySegTruncW=xMin*ones(size(xxSegTruncW));

%new x and y values
xxSegTrunc=xxSeg;
yySegTrunc=yySeg;

%intersecting segment ends that need replacing
%Note: the function repmat is used as booleCrossBox refers to segments,
%not segement ends, meaning two dimensional arrays are needed
booleReplaceN=booleN&booleOut&repmat(booleCrossBoxN,2,1); %north
booleReplaceS=booleS&booleOut&repmat(booleCrossBoxS,2,1); %south
booleReplaceE=booleE&booleOut&repmat(booleCrossBoxE,2,1); %east
booleReplaceW=booleW&booleOut&repmat(booleCrossBoxW,2,1); %west

%replament step
%north edge
xxSegTrunc(booleReplaceN)=xxSegTruncN;
yySegTrunc(booleReplaceN)=yySegTruncN;
%south edge
xxSegTrunc(booleReplaceS)=xxSegTruncS;
yySegTrunc(booleReplaceS)=yySegTruncS;
%east edge
xxSegTrunc(booleReplaceW)=yySegTruncW;
yySegTrunc(booleReplaceW)=xxSegTruncW;
%est edge
xxSegTrunc(booleReplaceE)=yySegTruncE;
yySegTrunc(booleReplaceE)=xxSegTruncE;

%remove segments that do not intersect with box or lie outside the box
xxSegBoxed=[xxSegTrunc(1,booleKeep);xxSegTrunc(2,booleKeep)];
yySegBoxed=[yySegTrunc(1,booleKeep);yySegTrunc(2,booleKeep)];
numbSegsBoxed=sum(booleKeep); %number of kept lines
%%%END - Replace old segment ends with new ones  END%%%

%%%START - Plotting - START%%%
%random matrices for line colours
colorMat=rand(numbSegs,3);
colorMatBoxed=colorMat(booleKeep,:);
%segment labels correspond to their order
labelSegAll=cellstr(num2str((1:numbSegs)'));
labelSegBoxed=cellstr(num2str(find(booleKeep)'));

%loop through  three plots
for kk=1:3       
    switch kk
        case 1
            %plot original segments
            xxPlotTemp=xxSeg;
            yyPlotTemp=yySeg;
            colorMatTemp=colorMat;
            labelSegTemp=labelSegAll;
        case 2
            %plot truncated (intersecting) segments or lie completely outside the box
            xxPlotTemp=xxSegTrunc;
            yyPlotTemp=yySegTrunc;
            colorMatTemp=colorMat;
            labelSegTemp=labelSegAll;
        case 3
            %plot final segments that intersect with or lie inside the box
            xxPlotTemp=xxSegBoxed;
            yyPlotTemp=yySegBoxed;
            colorMatTemp=colorMatBoxed;
            labelSegTemp=labelSegBoxed;
    end
    figure; hold on;
    numbSegTemp=length(xxPlotTemp(1,:));
    for ii=1:numbSegTemp
        %loop through each segment and plot
        plot(xxPlotTemp(:,ii),yyPlotTemp(:,ii),'color',colorMatTemp(ii,:));
    end
    %draw rectangle
    rectangle('Position',dimBox,'EdgeColor','k', 'LineWidth',1.5);
    xlim(xLim);
    ylim(yLim);
    %remove ticks on x and y axes
    xticks([]);
    yticks([]);
    set(gca,'xcolor','none','ycolor','none'); %remove axis lines
    %plot segment ends
    plot(xxPlotTemp,yyPlotTemp,'k.','MarkerSize',16);

    %label segements for small number of segements
    if numbSegTemp<30
        xxTextTemp=mean(xxPlotTemp);
        yyTextTemp=mean(yyPlotTemp);
        %number the points/cells
        labels=cellstr(num2str((1:numbSegTemp)'));%labels correspond to their order
        text(xxTextTemp, yyTextTemp, labels, 'VerticalAlignment','bottom', ...
            'HorizontalAlignment','right');
    end
    
end

%
%
% %plot original segments
% figure; hold on;
% for ii=1:numbSegs
%     %loop through each segment and plot
%     plot(xxSeg(:,ii),yySeg(:,ii),'color',colorMat(ii,:));
% end
% %draw rectangle
% rectangle('Position',dimBox,'EdgeColor','k', 'LineWidth',1.5);
% xlim(xLim*1.5);
% ylim(yLim*1.5);
% %remove ticks on x and y axes
% xticks([]);
% yticks([]);
% set(gca,'xcolor','none','ycolor','none'); %remove axis lines
%
% %label segements for small number of segements
% if numbSegs<5
%     xxPlot=mean(xxSeg);
%     yyPlot=mean(yySeg);
%     %number the points/cells
%     labels=cellstr(num2str((1:numbSegs)'));%labels correspond to their order
%     text(xxPlot, yyPlot, labels, 'VerticalAlignment','bottom', ...
%         'HorizontalAlignment','right');
% end
%
% %plot truncated (intersecting) segments or lie completely outside the box
% figure; hold on;
% for ii=1:numbSegs
%     %loop through each segment and plot
%     plot(xxSegTrunc(:,ii),yySegTrunc(:,ii),'color',colorMat(ii,:));
% end
% rectangle('Position',dimBox,'EdgeColor','k', 'LineWidth',1.5);
% xlim(xLim*1.5);
% ylim(yLim*1.5);
% %remove ticks on x and y axes
% xticks([]);
% yticks([]);
% set(gca,'xcolor','none','ycolor','none'); %remove axis lines
% %plot (truncated) segment ends
% plot(xxSegTrunc,yySegTrunc,'k.','MarkerSize',16);
%
% %plot final segments that intersect with or lie inside the box
% figure; hold on;
% for ii=1:numbSegsBoxed
%     %loop through each segment and plot
%     plot(xxSegBoxed(:,ii),yySegBoxed(:,ii),'color',colorMatBoxed(ii,:));
% end
% rectangle('Position',dimBox,'EdgeColor','k', 'LineWidth',1.5);
% xlim(xLim*1.5);
% ylim(yLim*1.5);
% %remove ticks on x and y axes
% xticks([]);
% yticks([]);
% set(gca,'xcolor','none','ycolor','none'); %remove axis lines
% %plot (truncated) segment ends
% plot(xxSegBoxed,yySegBoxed,'k.','MarkerSize',16);
%%%END - Plotting - END%%%

%GRAVE YARD

%indexCrossBoxW=funIndexCrossBound(vx(1,:),vx(2,:),xMin);
%indexCrossS=xor(vy(1,:)>yMin,vy(2,:)>yMin);
%indexCrossBoxS=indexCrossS&funIndexCross(xSegN,xMin,xMax);
%indexCrossS=funIndexCross(xSegS,xMin,xMax);


%figure; hold on;
%north
%lineNorth=[xMin, yMax; xMax, yMax];
%plot(lineNorth(:,1),lineNorth(:,2),'r');
%east
%lineEast=[xMax, yMin; xMax, yMax];
%plot(lineEast(:,1),lineEast(:,2),'g');
%south
%lineSouth=[xMin, yMin; xMax, yMin];
%plot(lineNorth(:,1),lineNorth(:,2),'b');
%west
%lineWest=[xMin, yMin; xMin, yMax];
%plot(lineWest(:,1),lineWest(:,2),'m');

%
% %define line intersection functions
% %https://blogs.mathworks.com/loren/2011/09/08/intersecting-lines-part-2/
% A = @(lineA,lineB) [lineA(1,:) - lineA(2,:); lineB(2,:) - lineB(1,:)]';
% pq = @(lineA,lineB) linsolve(A(lineA,lineB),(lineB(2,:) - lineA(2,:))');
% isIntersect = @(lineA,lineB) all(all(pq(lineA,lineB)*[1 -1]+[0 1;0 1]>=0));
%
% booleCross=false(numbEdge,4);
%
% for ii=1:numbEdge
%     edgeTemp_x=vx(:,ii);
%     edgeTemp_y=vy(:,ii);
%     lineTemp=[edgeTemp_x(:),edgeTemp_y(:)];
%
%     booleCross(ii,1)=isIntersect(lineTemp,lineNorth);
%     booleCross(ii,2)=isIntersect(lineTemp,lineEast);
%     booleCross(ii,3)=isIntersect(lineTemp,lineSouth);
%     booleCross(ii,4)=isIntersect(lineTemp,lineWest);
%
%
% end
%
%
% figure; hold on;
% voronoi(xx,yy);
% plot(xx,yy,'k.');
% rectangle('Position',dimRect,'EdgeColor','k');
%
% colorFour='rbgm';
% for jj=1:4
%     vxB=vx(:,booleCross(:,jj));
%     vyB=vy(:,booleCross(:,jj));
%     plot(vxB,vyB, 'Color',colorFour(jj));
% end
%
% xlim([xMin, xMax]*1.5);
% ylim([xMin, yMax]*1.5);
%
%yInterceptSeg=vyOrdered(2,:)-slopeSeg.*vxOrdered(2,:);%slopeSeg=(vyOrdered(2,:)-vyOrdered(1,:))./(vxOrdered(2,:)-vxOrdered(1,:));

%xSegN=(yMax-yInterceptSeg)./slopeSeg;

% % replace segments ends (outside of box) with their box intersections
% vxBoxed1=vxOrder;
% vyBoxed1=vyOrder;
%
% indexReplaceW=indexOut(1,:)&indexCrossBoxW; %edges crossing the west box
% vxBoxed1(1,indexReplaceW)=vxW; %replace left edge with west box edge value
% vyBoxed1(1,indexReplaceW)=vyW; %replace left edge with west box edge value
%
% indexReplaceE=indexOut(2,:)&indexCrossBoxE; %edges crossing the west box
% vxBoxed1(2,indexReplaceE)=vxE; %replace right edge with east box edge value
% vyBoxed1(2,indexReplaceE)=vyE; %replace right edge with east box edge value
%

% %plot the intersections of edges and box edges
% plot(vxN,vyN,'b.', 'MarkerSize',9); %north box edge
% plot(vxS,vyS,'g.', 'MarkerSize',9); %south box edge
%
% plot(vxE,vyE,'r.', 'MarkerSize',9); %east box edge
% plot(vxW,vyW,'c.', 'MarkerSize',9); %west box edge



% %N, E, S, W for North,East, South, West
% indexN=vy<yMax;
% indexE=vx>xMin;
% indexS=vy>yMin;
% indexW=vx<xMax;
% indexIn=indexN&indexE&indexS&indexW; %inside box
% indexOut=~indexIn;
%
% plot(vx(indexIn),vy(indexIn), 'k.','MarkerSize', 9);
% xlim(xLim*1.5);
% ylim(yLim*1.5);


%
%  for ii=2:2
%      %x values for north and south edges
%      xSegNS=fun_x(yLim(ii),yInterSeg,slopeSeg);
%      indexCrossBoxNS=funBooleCrossBound(yySeg(1,:),yySeg(2,:),yLim(ii))...
%      &funBooleIn(xSegNS,xMin,xMax);
%      vxNS=xSegNS(indexCrossBoxNS);
%      vyNS=yLim(ii)*ones(size(vxNS));
%
%
%  end
%booleOut=~(funBooleIn(vxOrder,xMin,xMax)&funBooleIn(vyOrder,yMin,yMax));
