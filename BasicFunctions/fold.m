function [ y,ny ] = fold( x,nx )
    %FOLD Summary of this function goes here
    %   Detailed explanation goes here
    ny = fliplr(-nx);
    y = fliplr(x);
 
end
