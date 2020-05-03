function [ y,ny ] = shift( x,nx,n0 )
    %SHIFT Summary of this function goes here
    %   y[n] = x[n-n0]
    ny = nx + n0;
    y = x;
end
