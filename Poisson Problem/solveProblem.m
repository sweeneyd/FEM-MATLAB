%% 2D Diffusion on a Rectangular Plane (Dirichlet Boundaries)
clear; clc;
xmin = 0; xmax = 10;
ymin = 0; ymax = 10;
N = 50;
M = 50;
xvals = linspace(xmin, xmax, N+1);
yvals = linspace(ymin, ymax, M+1);

% Initialize vert_list because it's good practice
verts = zeros((N+1)*(M+1),2);

for i=1:M+1
    for j = 1:N+1
        % How do we create a list of vertex points?
        verts(j+(N+1)*(i-1),:) = [xvals(j), yvals(i)];
    end
end

%Initialize elements matrix for good practice
elements = zeros(N*M, 4);
fig = figure(1);
hold on
for i = 1:N
    for j = 1:M
        
        % global vertex label for local vertex 1
        v1 = i+(N+1)*(j-1);
        
        % global vertex label for local vertex 2
        v2 = i+1+(N+1)*(j-1);
        
        % global vertex label for local vertex 3
        v3 = i+1+(N+1)*j;
        
        % global vertex label for local vertex 4
        v4 = i+(N+1)*j;
        
        % Add global element labels into a list of elements
        elements(i+(j-1)*N,:) = [v1, v2, v3, v4];
        
                % Find the global labels of each of the nodes for a given element
        nodes = elements(i+(j-1)*N,:);
        
        % Find the coordinates of the bounding rectangle of the element
        outline = [verts(nodes(1),:);
                   verts(nodes(2),:);
                   verts(nodes(3),:);
                   verts(nodes(4),:);
                   verts(nodes(1),:)];
               
        % How can we visualize what exactly we are plotting?
        plot(outline(:,1), outline(:,2), '-k')
    end
end
xlim([xmin-0.1*(xmax-xmin), 0.1*(xmax-xmin)+xmax]);
ylim([ymin-0.1*(ymax-ymin), 0.1*(ymax-ymin)+ymax]);
xlabel('x', 'FontSize', 14)
ylabel('y', 'FontSize', 14)
saveas(fig, 'workedProblem_meshHomemade.png')

%% Assemble Stiffness Matrix
K = zeros((M+1)*(N+1),(M+1)*(N+1));
kk = [1/3, -1/12, -1/6, -1/12;
      -1/12, 1/3, -1/12, -1/6;
      -1/6, -1/12, 1/3, -1/12;
      -1/12, -1/6, -1/12, 1/3];
for i = 1:length(elements)
    nodes = elements(i,:);
    hx = verts(nodes(2),1) - verts(nodes(1),1);
    hy = verts(nodes(4),2) - verts(nodes(1),2);
    for j = 1:length(nodes)
        for k = 1:length(nodes)
            K(nodes(j), nodes(k)) = K(nodes(j), nodes(k)) + 1/(2*hx*hy)*kk(j,k);
        end
    end
    
end

%% Solve for Dirichlet Boundary Conditions
fxn1 = @(y) sin(y);
fxn2 = @(y) sin(y);
f = zeros((N+1)*(M+1), 1);
for i = 1:length(verts)
    if verts(i,1) == xmax
        K(i,:) = 0;
        K(i,i) = 1;
        f(i) = fxn1(verts(i,2));
    elseif verts(i,1) == xmin
        K(i,:) = 0;
        K(i,i) = 1;
        f(i) = fxn2(verts(i,2));        
    end
end

%% Solve Linear System
c = K\f;

%% Plot Solution
sol = zeros(N+1, M+1);
for i = 1:M+1
    for j = 1:N+1
        sol(i,j) = c(j+(i-1)*(N+1));
    end
end

fig = figure(2);
contourf(xvals, yvals, sol,5)
xlabel('x', 'FontSize', 14)
ylabel('y', 'FontSize', 14)
saveas(fig, 'workedProblem_figure2.png')

fig = figure(3);
surf(xvals, yvals, sol)
xlabel('x', 'FontSize', 14)
ylabel('y', 'FontSize', 14)
zlabel('u(x,y)', 'FontSize', 14)
saveas(fig, 'workedProblem_figure3.png')
