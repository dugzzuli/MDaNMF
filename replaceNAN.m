function [ data ] = replaceNAN( data )
%REPLACENAN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
data(isnan(data)) = 0;
end

