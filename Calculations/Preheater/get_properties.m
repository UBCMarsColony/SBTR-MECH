function [result] = get_properties(filename,temperature, property)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    load(filename)
    result = interp1(filename.T,filename.dens,temperature)
end

