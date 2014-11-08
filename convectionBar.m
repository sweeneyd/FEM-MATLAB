%% 1-D UNSTEADY CONVECTION IN A BAR ======================================
% This code solves for the equation (pc*A)*M*(df/dt) + (A*P)*N*(f) = (A)*s

% ==== CONSTANTS ====
% x  == array containing the x-values of each node
% NE == number of elements 
% h  == array containing the length of each element

% ==== MATRICIES ====
% N  == Global advection matrix
% M  == Mass matrix
% f  == 1D matrix of temperature values at each element
% s  == Source matrix

% Reference: 
% Original code by: Flyrockstar10
%[1] Strang G. and Fix G. (2008): An analysis of the Finite Element Method,Second Edition, Wellesley-Cambridge Press, Wellesley USA
%[2] R. W. Lewis et al. (1996):  The Finite Element Method in Heat Transfer Analysis, John Wiley and Sons, West Sussex England

% Developed by Dan Sweeney (3 November 2014)
% Last updated: 5 November 2014
% ========================================================================

%% Setup
A = 1;      % Element area
pc = 1;     % Heat capacity
P = 1;      % Thermal conductivity

%% Define x values for nodes and # of elements
x = linspace(0, 3, 10);

% # of elements = # of nodes - 1
NE = length(x) - 1;

% Generate element connectivity matrix
for i = 2:length(x)
    elements(i-1, :) = [i-1, i];
end

%% Initialize matricies
% Equation takes the form: M*f' + N*f = s(t)
M = zeros(NE+1, NE+1);      % NE+1 x NE+1
N = zeros(NE+1, NE+1);      % NE+1 x NE+1
f = zeros(NE+1, 1);         % NE+1 x 1
s = zeros(NE+1, 1);

%% Assemble the matricies
for i = 1:NE
    nodes = elements(i, :);                         % Define node
    h_loc = x(i+1) - x(i);                          % Determine node width
    
    Ne = (A*P/h_loc) * [1, -1; -1, 1];              % Define local N as Ne
    Me = (pc*A*h_loc/6) * [2, 1; 1, 2];             % Define local M as Me
    se = (A*h_loc/6) * [2, 1; 1, 2] * s(nodes, 1) ; % Define local s as Se
        
    N(nodes, nodes) = N(nodes, nodes) + Ne;         % Fill in global N
    M(nodes, nodes) = M(nodes, nodes) + Me;         % Fill in global M
    s(nodes, 1) = s(nodes, 1) + se;                 % Fill in global s
end

%% Apply Neumann Boundary Condition
s(1) = 1;

%% Apply Dirichlet Boundary Condition
f(1) = 0;

%% Setup time scale
dt = 0.01;
t_max = 1;
tt = 0:dt:1;

%% Assemble right hand side
% M*f(t+1) = (M - dt * N - dt * s) * f(t)
for i = 2:length(tt)
    RHS = (M - dt .* N)*f(:, end) + dt .* s;
    f = cat(2, f, M\RHS);
end

%% Get some freakin' sweet plots
figure(1);
subplot(2, 1, 1)
hold all
plot(x, f(:, end), x, f(:, end), 'ro')
title('Length vs. Temperature @ t = 1.0s')
xlabel('Length (m)')
ylabel('Temperature (C)')
hold off

subplot(2, 1, 2)
hold all
plot(tt, f(1, :), 'r')
title('Time vs. Temperature @ x = 0m')
xlabel('Time (s)')
ylabel('Temperature (C)')
hold off

figure(2);
surf(f);
