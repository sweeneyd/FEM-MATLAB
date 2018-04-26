%% LineMesh_p1.m
% REFERENCE: http://www.cs.rpi.edu/~flaherje/FEM/index4.html
% REFERENCE: http://www.math.chalmers.se/~mohammad/teaching/PDEbok/draft_FEM_version4.pdf
xmin = 0; xmax = 1;
N = 5;
xvals = linspace(xmin, xmax, N+1);
verts = zeros(N+1,1);

for i=1:N+1
    % How do we create a list of vertex points?
    verts(i,:) = xvals(i);
end

% Let's visualize this
hold on
for i=1:length(verts)
    plot(verts(i), 0, 'ok')
    text(xvals(i)+0.1*(xmax-xmin)/N, 0.1, sprintf('%d', i), 'color', 'red');
end
xlim([xmin-0.1*(xmax-xmin), xmax+0.1*(xmax-xmin)])
ylim([-1, 1])

% Let's generate elements from this list
elements = zeros(N, 2);
for i = 1:N
    % global vertex label for local vertex 1
    v1 = i;

    % global vertex label for local vertex 2
    v2 = i+1;
    
    % Add global element labels into a list of elements
    elements(i,:) = [v1, v2]; 
end

% Let's visualize this
hold on
for i=1:length(elements)
    % Find the global labels of each of the nodes for a given element
    nodes = elements(i,:);

    % Find the coordinates of the bounding rectangle of the element
    line = [verts(nodes(1),:);
            verts(nodes(2),:)];    
    plot(line, [0,0], '-r')
    center = [(verts(nodes(1),1)+verts(nodes(2),1))/2,
              -0.1];
    text(center(1), center(2), sprintf('%d', i), 'color', 'blue');
    pause()
    plot(line, [0,0], '-k')
end
xlim([xmin-0.1*(xmax-xmin), xmax+0.1*(xmax-xmin)])
ylim([-1, 3])

% Let's plot the shape functions on each element
for i=1:length(elements)
    % Find the global labels of each of the nodes for a given element
    nodes = elements(i,:);
    
    m = 1/(verts(nodes(2))-verts(nodes(1)));
    f1 = @(x) m*(x-verts(nodes(1)));
    f2 = @(x) m*(verts(nodes(2))-x);
    x = linspace(verts(nodes(1)), verts(nodes(2)));
    plot(x, f1(x), '--r')
    plot(x, f2(x), '--r')
    pause()
    plot(x, f1(x), '--k')
    plot(x, f2(x), '--k')
end
