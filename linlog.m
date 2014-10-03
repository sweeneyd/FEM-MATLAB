function [ logarray ] = linlog( a, b, n )
%Like linspace, but logrithmic

logarray = [];
for i = a:b-1
    logarray = [logarray, linspace(10^i, 10^(i+1), n)];
end
end
