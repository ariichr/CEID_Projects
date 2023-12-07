function [C] = readFile(filename)
%READFILE Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(filename,'r');
C = fscanf(fileID,'%s');
fclose(fileID);
end

