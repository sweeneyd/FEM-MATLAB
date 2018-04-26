function [ output_args ] = plotMesh( mesh )
%Plot 2D triangular mesh
%   Detailed explanation goes here
hold on
for i=1:mesh.elementNumber
    nodes = mesh.elements(i,:);
    if sum(nodes==0) < 1
        vert = zeros(4,2);
        for j=1:length(nodes)
            vert(j,:) = mesh.nodes(nodes(j),1:2);
        end
        vert(4,:) = mesh.nodes(nodes(1),1:2);
        plot(vert(:,1), vert(:,2), 'k')
    end
end

end

