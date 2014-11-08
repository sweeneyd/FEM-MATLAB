%% GINPUT()-BASED FEM FOR HEAT TRANSFER IN A 1D BAR ======================
% This code solves for the temperature distribution through a bar of 
% length 20 and nodes/sources defined using the  ginput() function. The
% governing equation is  s(x) + k * d^2(f)/dx^2 = 0.

% ==== CONSTANTS ====
% k  == thermal diffusivity
% q0 == heat flux from the left side of the bar
% fL == temperature defined on the right side of the bar
% x  == array containing the x-values of each node
% NE == number of elements 
% h  == array containing the length of each element

% ==== MATRICIES ====
% D  == Diffusion matrix
% M  == Mass matrix
% f  == 1D matrix of temperature values at each element
% s  == Source matrix
% c  == boundary conditions

% Developed by Dan Sweeney (26 September 2014)
% Last updated: 5 November 2014
% ========================================================================

clear; clc;
%% User Input Handling
% Generate a function
figure(1);
hold all;
xbeam = linspace(0, 20, 1000);
ybeam = zeros(length(xbeam), 1);
plot(xbeam, ybeam, '-black','LineWidth', 6);

% Define source position with ginput
[xsource, ysource] = ginput;
plot(xsource, zeros(length(xsource), 1), 'or', 'LineWidth', 6);

% Define nodes  with ginput
[xnode, ynode] = ginput;

% Add in source positions to node list
x = cat(1, xsource, xnode);
x = cat(1, x, max(xbeam));
x = cat(1, min(xbeam), x);
for i = 1:length(x)
    line([x(i), x(i)], [-5, 5], 'Color', [0, 0, 0]);
end

% Sort list of divisions form ginput for h
x = mergesort(x);
h = zeros(length(x)-1, 1);

for i = 1:length(x)-1
    h(i) = x(i+1) - x(i);
end
h(h == 0) = [];
NE = length(h);

%% FEM Calculations

% Initialize Matricies
D = zeros(NE, NE);
M = zeros(NE, NE+1);
f = zeros(NE, 1);
s = zeros(NE+1, 1);
c = zeros(NE, 1);

% Assemble the D matrix
for i = 1:NE
    for j = 1:NE
        if i == 1 && j == 1
            D(i, j) = 1/h(i);
            
        elseif i == j &&  i ~= 1
            D(i, j) = 1/h(i) + 1/h(i-1);
            
        elseif i == j + 1
            D(i, j) = -1/h(i-1);
            
        elseif i == j - 1
            D(i, j) = -1/h(i);
        else
            D(i, j) = 0;
        end
    end
end

% Assemble M matrix
for i = 1:NE
    for j = 1:NE+1
        if i == 1 && j == 1
            M(i, j) = h(i)/3;
            
        elseif i == j && i ~= 1 && i ~= NE+1
            M(i, j) = h(i)/3 + h(i-1)/3;
            
        elseif i == j + 1
            M(i, j) = h(i-1)/6;
            
        elseif i == j - 1
            M(i, j) = h(i)/6;
            
        else
            M(i, j) = 0;
        end
    end
end

% Set up boundary conditions with c and s matricies
q0 = 0;
k = 5;
fL = 24;

c(1) = q0/k;
c(end) = fL/h(end);

% Set up source term
for i = 1:length(xsource)
    source_index(i) = find(x == xsource(i), 1, 'first');
end

if length(source_index) > 0
    s(source_index) = 1; % set all sources to 1
end

% Solve for f
b = c + 1/k * M * s;
f = inv(D) * b;

% Add in known node values
f = cat(1, f, fL);

%% Plotting
% Plot f with color-coded elements and legend
figure(1);
plot(x, f, '--r', 'LineWidth', 3);
xlabel('Length along bar (m)');
ylabel('Temp. (T)');
hold off;
