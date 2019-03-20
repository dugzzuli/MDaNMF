function [ data ] = replaceNAN( data )
%REPLACENAN 此处显示有关此函数的摘要
%   此处显示详细说明
data(isnan(data)) = 0;
end

