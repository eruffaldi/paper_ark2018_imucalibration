function [ m ] = resampleMark( min )
%RESAMPLEMARK Summary of this function goes here
%   Detailed explanation goes here
a = fields(min);
for i=1:length(a)
    x = min.(a{i});
    t0 = find(x(:,1) ~= 0); 
    m.(a{i}) = interp1(t0,x(t0,:),1:size(x,1),'spline');
end

