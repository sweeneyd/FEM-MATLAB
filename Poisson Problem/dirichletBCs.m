%% Solve for Dirichlet Boundary Conditions
fxn1 = @(y) cos(y);
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