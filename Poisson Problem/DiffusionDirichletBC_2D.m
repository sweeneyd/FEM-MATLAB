%% 2D Diffusion on a Rectangular Plane (Dirichlet Boundaries)
% SOLVE: grad(grad(u(x,y))) = 0
% BCs: u(xmax,y) = sin(y), u(xmin,y) = u(x,ymin) = u(x,ymax) = 0
% First, we define a rectangle [xmin, xmax] by [ymin, ymax] split evenly
% into N even segments along the x-dimension and M even segments along the
% y-dimension.
% REFERENCE: http://www.iue.tuwien.ac.at/phd/orio/node48.html
xmin = 0; xmax = 1;
ymin = 0; ymax = 1;
N = 5;
M = 5;
xvals = linspace(xmin, xmax, N+1);
yvals = linspace(ymin, ymax, M+1);

% Initialize vert_list because it's good practice
verts = zeros((N+1)*(M+1),2);

hold on
for i=1:N+1
    for j = 1:M+1
        % How do we create a list of vertex points?
        verts(i+(N+1)*(j-1),:) = [xvals(i), yvals(j)];
        
        % How do we plot these to check that all went well?
        plot(xvals(i), yvals(j), 'ok');
        xlim([xmin-0.1*(xmax-xmin), 0.1*(xmax-xmin)+xmax]);
        ylim([ymin-0.1*(ymax-ymin), 0.1*(ymax-ymin)+ymax]);
        
        % How do we come up with a numbering scheme for our nodal values?
        text(xvals(i)+0.1*(xmax-xmin)/N, yvals(j)+0.1*(ymax-ymin)/M, sprintf('%d', i+(N+1)*(j-1)));
    end
end

% Now, knowing these vertices, how do we generate a correctly-oriented
% uniform fitted mesh?

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

% Now, how do we ensure that we have assigned the correct references in the
% connectivity/element matrix?
for i = 1:N
    for j = 1:M
        
        % Find the global labels of each of the nodes for a given element
        nodes = elements(i+(j-1)*N,:);
        
        % Find the coordinates of the bounding rectangle of the element
        outline = [verts(nodes(1),:);
                   verts(nodes(2),:);
                   verts(nodes(3),:);
                   verts(nodes(4),:);
                   verts(nodes(1),:)];
               
        % How can we visualize what exactly we are plotting?
        plot(outline(:,1), outline(:,2), '-r')
        pause()
        plot(outline(:,1), outline(:,2), '-k')
        center = [(verts(nodes(1),1)+verts(nodes(2),1))/2,
                  (verts(nodes(3),2)+verts(nodes(1),2))/2];
        text(center(1), center(2), sprintf('%d', i+(j-1)*N), 'color', 'b')
    end
end