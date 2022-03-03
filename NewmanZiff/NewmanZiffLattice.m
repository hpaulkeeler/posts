% Simulates a site percolation model on a square lattice embedded in a 
% torus by using an algorithm proposed in a paper by Newman and Ziff[1].
% The algorithm can also be used for bond percolation, but this code is for
% site percolation.
%
% There are essentially three steps to the algorithm:
% 1) For every site in the model, find/define the nearest neighbours.
% 2) Draw a single sample uniformly from all site permutations.
% 3) Perform union-find (using root finding) method to find the big component
%
% This algorithm can be used to estimate statistics for a fixed number, say
% n, of occupied sites. But typically such a (discrete) percolation model is
% studied in relation to a parameter such as the probability, say p, of an
% occupied site. It is not implemented in this code, but this leads to an
% additional step:
% 4) Collect some statistic for every fixed number of occupied sites. This
% statistic, say Q_n, is a conditional statistic, being conditioned on the 
% number of occupied sites. To find the statistic as a function of the 
% probability p, the aforementioned (conditional) statistics are then 
% averaged (or convolved) with respect to the binomial probability. This 
% statistic, say Q(p), is given by equation (2) in the paper[1].
%
% Information on this algorithm can also be found in the book by
% Newman [Section 16.5, 2].
%
% Resources on the internet include:
% https://pypercolate.readthedocs.io/en/stable/newman-ziff.html
%
% https://networkx.org/documentation/stable/_modules/networkx/utils/union_find.html
%
% References:
% [1] 2001, Newman and Ziff, "Fast Monte Carlo algorithm for site or bond percolation"
% [2] 2010, Newman, "Networks - An Introduction"
% [3] 1997, Knuth, "The Art of Computer Programming - Volume 1 - Fundamental Algorithms"
% [4] 2009, Cormen, Leiserson, Rivest, and Stein, "Introduction to algorithms"

clearvars; close all; clc;

dimLin = 10;  % linear dimension ie number of sites in one dimension
numbSite = dimLin*dimLin;  % total number of sites

%Step 1
matNeigh=funBoundaries(dimLin); %find/define nearest neighbours

%Step 2 (only source of randomness)
%indexOrder=funRandPermute(numbSite); %sample random site permutation
% Recommended to use the built-in MATLAB function randperm
indexOrder=randperm(numbSite);

%TEMP START - a test permutation for 3 x 3 lattice
%indexOrder=[4, 5, 8, 0, 2, 6, 3, 1, 7];
%indexOrder=indexOrder+1;
%dimLin=3
%numbSite=9
%TEMP END

%Step 3
%percolation step ie finding clusters (or unions) for each configurations
[numbBig,~] = funPercolate(matNeigh, dimLin, indexOrder);

disp("The percolation magic is finished.");

%%% START Define functions START %%%
function [numbBig, arrPointer] = funPercolate(matNeigh, dimLin, indexOrder)
%This is the main function of the percolation simulation. It performs the
%(weighted) union-find method to find the big component for each set of
%occupied sites.

numbSite=dimLin*dimLin; % total number of sites

numbBig = 0; %number of sites in the big component
valueEmpty = -numbSite-1; %negative number to indicate unconnected sites
% initialize array of (graph-theortic) pointers
arrPointer=ones(1,numbSite)*valueEmpty;

%loop through sites of the sampled site permutation
for i=1:numbSite
    r1 = indexOrder(i);
    s1 = indexOrder(i);
    arrPointer(s1) = -1;
    
    %loop through the 4 neigbour sites of s1
    for j=1:4
        s2 = matNeigh(s1,j);
        if (arrPointer(s2) ~= valueEmpty)
            
            %find root of neighbour site using recursive method
            %[arrPointer,r2] = funFindRootRec(arrPointer,s2);
            %find root of neighbour site using non-recursive method
            [arrPointer,r2] = funFindRootHalf(arrPointer,s2);
            
            if (r2 ~= r1)
                if (arrPointer(r1) > arrPointer(r2))
                    arrPointer(r2) = arrPointer(r2) + arrPointer(r1);
                    arrPointer(r1) = r2;
                    r1 = r2;
                else
                    arrPointer(r1) = arrPointer(r1) + arrPointer(r2);
                    arrPointer(r2) = r1;
                end
                if ((-arrPointer(r1)) > numbBig)
                    %update size of the biggest component
                    numbBig = -arrPointer(r1);
                end
            end
        end
    end
    %prints out number of occupied sites and biggest component
    %fprintf('%d, %d\n',i+1,numbBig); 
    
end

end

function matNeigh=funBoundaries(dimLin)
% This function defines neighbour sites for each site in the square
% lattice on a torus. For other percolation models, this function
% needs to be changed accordingly to reflect the nearest neighbours.

numbSite=dimLin*dimLin; %total number of sites
matNeigh=zeros(numbSite,4); % initialize matrix for neighbours

for i=0:numbSite-1
    j=i+1; %j corresponds to MATLAB indexing
    
    matNeigh(j,1) = mod(i,numbSite)+1; %east (or right) neighbor site
    matNeigh(j,2) = mod((i+numbSite-1),numbSite); %west (or left) neighbor site
    matNeigh(j,3) = mod((i+dimLin),numbSite); %south (or bottom) neighbour site
    matNeigh(j,4) = mod((i+numbSite-dimLin),numbSite); %north (or top) neighbour site
    
    if (mod(i,dimLin)==0)
        %if site is on the west (or left) boundary
        matNeigh(j,2) = i+dimLin-1; %wrap around to other side
    end
    if (mod((i+1),dimLin)==0)
        %if site is on the east (or right) boundary
        matNeigh(j,1) = i-dimLin+1; %wrap around to other side
    end
    %disp(nn(j,:));
end

matNeigh=matNeigh+1; %add one to all indices (to agree with MATLAB indexing)
end


function indexOrder=funRandPermute(numbSite)
% This function generates a random permutation. It performs the
% Durstenfield version of the Fisher-Yates shuffle.  See Algorithm P
% in "Art of Scientific Programming -- Volume 1" by Knuth.
% Also see:
% https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
%
% Recommended to use the built-in MATLAB function randperm

% initialize order array
indexOrder = 1:numbSite;
for i=1:numbSite
    j = randi([i,numbSite]); %random integer j st i<=j<N
    
    %swap numbers at i and j
    indexTemp = indexOrder(i);
    indexOrder(i) = indexOrder(j);
    indexOrder(j) = indexTemp;
end

% %TEMP!!!
% % An inefficient way to generate the same random permutation in MATLAB and
% % Python
% rng(6);
% [~,indexOrder]=sort(rand(1,numbSite));
% %TEMP!!!

end


function [arrPointer,indexPoint]=funFindRootRec(arrPointer,indexPoint)
% WARNING: This method can be slow for large systems (ie large numbSite),
% due to the recursion. Use the non-recursive function funFindRootHalf
% instead.
%
% This function performs a root-finding method based
% on recursion. This method is called path compressing.
% Newman and Ziff presented this code in the appendix of
% their paper[1], but the method is standard in the literature.

if (arrPointer(indexPoint) < 0)
    %no changes are made, and the inputs are returned
    return;
end

%call function again (ie recursively)
[~,arrPointer(indexPoint)] = funFindRootRec(arrPointer,arrPointer(indexPoint));
indexPoint= arrPointer(indexPoint);
end


function [arrPointer,r]=funFindRootHalf(arrPointer,indexPoint)
% This function performs a (graph) root-finding method
% that doesn't use recursion. This method is called path halving.
% Newman and Ziff presented this code in the appendix of their
% paper[1], but the method is standard in the literature.

r = indexPoint;
s = indexPoint;

while (arrPointer(r) >= 0)
    arrPointer(s) = arrPointer(r);
    s = r;
    r = arrPointer(r);
end

end
%%% END Define functions END %%%


%%%%%%%%%%%%%%%%%%%%%%% CODE GRAVEYARD %%%%%%%%%%%%%%%%%%%%%%


%     if booleVideo
%         %frame = getframe(gcf);
%         dimLin=sqrt(numbSite);
%         plotLatticeSite(dimLin,indexOrder,arrPointer,valueEmpty);
%         drawnow; %draw now so figures are the same size
%         pause(1); %need a pause so figures are the same size
%         frameStruc(i) = getframe(gcf); %store in structure
%
%         close; %close figure
%     end

%     %disp(arrPointer);
%     %x=1:numbSite;
%     arrPointerPlot=zeros(dimLin,dimLin);
%     booleOccupied=arrPointer>valueEmpty;
%     arrPointerPlot(booleOccupied)=-arrPointer(booleOccupied);
%
%
%     %indexComp=find(arrPointer>0);
%
%     indexRoot=find(booleOccupied&(arrPointer<0));
%
%     if length(indexRoot)>3
%         arrPointer=arrPointer
%         indexOrder=indexOrder
%     indexRoot=indexRoot
%     for rr=indexRoot
%         indexCompTemp=[find(arrPointer==rr),rr]
%     end
%
%     %arrPointerPlot(booleComp)=arrPointer(booleComp);
%     %arrPointerPlot(booleRoot)=arrPointer(booleRoot);
%
%     arrPointerPlot=reshape(arrPointer,dimLin,dimLin);
%
%     disp(arrPointerPlot);
%     end


% %set up video if lattice is small enough
% if (numbSite<100)&&booleVideo
%     videoObject=VideoWriter(titleVideo);
%     videoObject.FrameRate = 1/2; %frame rate
%     open(videoObject);
%     frameStruc(1:numbSite) = struct('cdata',[], 'colormap',[]);
% else
%     booleVideo=0;
% end

