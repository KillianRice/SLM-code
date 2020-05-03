function [ x,n ] = unitstep_dt( n1,n0,n2 )
    %UNITSTEP_DT Summary of this function goes here
    %   Detailed explanation goes here
    n = n1:n2;  %the time vector
    n0 = find(n == n0); %finds the index of the step starting point
    x = zeros(1,length(n));
    x(n0:end) = 1;
end
