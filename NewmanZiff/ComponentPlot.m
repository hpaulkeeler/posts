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
plotLatticeSite(arrPointer,valueEmpty);