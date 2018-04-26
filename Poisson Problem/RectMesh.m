%% 2D Diffusion on a Rectangular Plane (Dirichlet Boundaries)
xmin = 0; xmax = 10;
ymin = 0; ymax = 10;
N = 10;
M = 10;
xvals = linspace(xmin, xmax, N+1);
yvals = linspace(ymin, ymax, M+1);

% Initialize vert_list because it's good practice
verts = zeros((N+1)*(M+1),2);

hold on
for i=1:N+1
    for j = 1:M+1
        % How do we create a list of vertex points?
        verts(i+(N+1)*(j-1),:) = [xvals(i), yvals(j)];
    end
end

%Initialize elements matrix for good practice
elements = zeros(N*M, 4);

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
    end
end