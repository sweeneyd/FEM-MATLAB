%% FEM FOR HEAT TRANSFER IN A 1D BAR =====================================
% This code solves for the temperature distribution through a bar of 
% length 20 with 2 elements defined by nodes at x = {0, 12, 20}. The
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
% Last updated: 26 September 2014
% ========================================================================

%% Setup
% Boundary conditions
q0 = 1;
fL = 0;

% Constants
k = 1;

%% Define x values for nodes and # of elements
x = linspace(0, 3, 5);

% # of elements = # of nodes - 1
NE = length(x) - 1;

%% Calculate the length of each element
% Initialize element length array
h = zeros(1, length(x)-1);

% Calculate the length of each element
for i = 1:length(x)-1
    h(i) = x(i+1) - x(i);
end

%% Initialize matricies
% Equation takes the form: D*f = c + M*s
D = zeros(NE, NE);      % NE x NE
M = zeros(NE, NE+1);    % NE x NE+1
f = zeros(NE, 1);       % NE x 1
s = zeros(NE+1, 1);     % NE+1 x 1
c = zeros(NE, 1);       % NE x 1

%% Assemble c matrix
c(1) = q0/k;
c(end) = fL/h(end);

%% Assemble s matrix
s(3) = 5;

%% Assemble the D matrix
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
            
        %elseif i == j && i == NE
        %    D(i, j) = 1/h(i);
            
        else
            D(i, j) = 0;
        end
    end
end

%% Assemble the M matrix
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

%% Generate the b matrix
% Equation takes the form: D*f = c + M*s
% --> b = c + M*s
b = c + 1/k * M * s;

%% Solve for the f matrix
% Equation takes the form: D*f = b
% --> f = inv(D)*b
f = inv(D) * b;
plot(f)
%% Display f matrix
disp('f-matrix =')
disp(f)
