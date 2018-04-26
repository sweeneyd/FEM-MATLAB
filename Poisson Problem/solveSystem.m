%% Solve Linear System
c = K\f;

%% Plot Solution
% Reformat solution for plotting
sol = zeros(N+1, M+1);
for i = 1:M+1
    for j = 1:N+1
        sol(j,i) = c(j+(i-1)*(N+1));
    end
end
% Create contour plot
contourf(xvals, yvals, sol)