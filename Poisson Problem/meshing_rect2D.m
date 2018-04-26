%% Generating a 2-D Rectangular Mesh
xmin = 0; xmax = 1;
ymin = 0; ymax = 1;
N = 3;
M = 3;
xvals = linspace(xmin, xmax, N+1);
yvals = linspace(ymin, ymax, M+1);

verts = zeros((N+1)*(M+1), 2);

for i = 1:N+1
    for j = 1:M+1
        verts(i+(N+1)*(j-1),:) = [xvals(i), yvals(j)];
    end
end

%% Create connectivity matrix
elements = zeros(N*M, 4);

for i = 1:N
    for j = 1:M
        % global vertex label for local vertex 1
        v1 = j+(M+1)*(i-1);
        
        % global vertex label for local vertex 2
        v2 = j+1+(M+1)*(i-1);
        
        % global vertex label for local vertex 3
        v3 = j+1+(M+1)*i;
        
        % global vertex label for local vertex 4
        v4 = j+(M+1)*i;
        
        % Add global element labels into a list of elements
        elements(j+(i-1)*N,:) = [v1, v2, v3, v4];
    end
end
