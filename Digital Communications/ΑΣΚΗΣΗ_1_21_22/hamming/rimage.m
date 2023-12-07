function [C] = rimage(filename)
%IMAGE Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(filename,'r');
C = imread(fileID,'%s');
fclose(fileID);
end

