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