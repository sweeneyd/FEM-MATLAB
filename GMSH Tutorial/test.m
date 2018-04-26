clc; clear;
%% Read mesh from GMSH file
filename = 'gmshExample_2D.msh';

%% Plot mesh
mesh = readGMSH(filename);
fig = figure(1);
plotMesh(mesh)
xlabel('x')
ylabel('y')
saveas(fig, 'gmshExample_2D_MATLABmesh.png')
close all

%% Generate stiffness matrix
K = zeros(mesh.nodeNumber, mesh.nodeNumber);
dphi = [-1, -1;
        1, 0;
        0, 1];
for i=1:mesh.elementNumber
    nodes = mesh.elements(i,:);
    verts = zeros(3,2);
    if sum(nodes==0) < 1
        for j=1:length(nodes)
            verts(j,:) = mesh.nodes(nodes(j),1:2);
        end
        B = [verts(2,1)-verts(1,1), verts(3,1)-verts(1,1);
             verts(2,2)-verts(1,2), verts(3,2)-verts(1,2)];
        Bi = inv(B);
        for j=1:length(nodes)
            for k=1:length(nodes)
                % Determine local stiffness matrix
                alpha = dphi(j,:)*Bi'*Bi*dphi(k,:)'*det(B)/2;
                % Add local stiffness matrix to global stiffness matrix
                K(nodes(j),nodes(k)) = K(nodes(j),nodes(k)) + alpha;
            end
        end
    end
end

%% Generate mass matrix
M = zeros(mesh.nodeNumber, mesh.nodeNumber);
dphi = 1/24*[2, 1, 1;
             1, 2, 1;
             1, 1, 2];
for i=1:mesh.elementNumber
    nodes = mesh.elements(i,:);
    verts = zeros(3,2);
    if sum(nodes==0) < 1
        for j=1:length(nodes)
            verts(j,:) = mesh.nodes(nodes(j),1:2);
        end
        B = [verts(2,1)-verts(1,1), verts(3,1)-verts(1,1);
             verts(2,2)-verts(1,2), verts(3,2)-verts(1,2)];
        Bi = inv(B);
        for j=1:length(nodes)
            for k=1:length(nodes)
                M(nodes(j),nodes(k)) = M(nodes(j),nodes(k)) + dphi(j,k)*det(B);
            end
        end
    end
end

%% Combing Mass and stiffness matrices
A = K + M;

%% RHS
L = zeros(length(mesh.nodes),1);

%% Apply Dirichlet BC's
for i=1:length(mesh.edges)
    nodes = mesh.edges(i,:);
    for j=1:length(nodes)
        if nodes(j) ~= 0
            x = mesh.nodes(nodes(j),1);
            y = mesh.nodes(nodes(j),2);
            A(nodes(j),:) = 0;
            A(nodes(j),nodes(j)) = 1;
            switch mesh.ID(nodes(j))
                case 1
                    L(nodes(j)) = cos(x/10)*sin(y/10);
                    continue
                case 2                 
                    L(nodes(j)) = cos(x/10)*sin(y/10);
                    continue
                case 3                   
                    L(nodes(j)) = cos(x/10)*sin(y/10);
                    continue
                case 4                     
                    L(nodes(j)) = cos(x/10)*sin(y/10);
                    continue
                otherwise
                    continue
            end
        end
    end
end

%% Apply Neumann BC's
beta = -1;
for i=1:length(mesh.edges)
    nodes = mesh.edges(i,:);
    if sum(nodes==0) < 1
        for j=1:length(nodes)
            if nodes(j) ~= 0
                B = [verts(2,1)-verts(1,1), verts(3,1)-verts(1,1);
                     verts(2,2)-verts(1,2), verts(3,2)-verts(1,2)];
                switch mesh.ID(nodes(j))
                    case 5                     
                        L(nodes(j)) = L(nodes(j)) + beta*det(B)/6;
                    otherwise
                        continue
                end
            end
        end
    end
end

%% Solve system
sol = A\L;

fig = figure(2);
tri = mesh.elements(any(mesh.elements ~= 0,2),:); %remove lines with [0,0,0] in them
trisurf(tri, mesh.nodes(:,1), mesh.nodes(:,2), sol)
xlabel('x')
ylabel('y')
zlabel('u(x,y)')
saveas(fig, 'gmshExample_2D_MATLABsolution_trisurf.png')
% close all
