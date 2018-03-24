function r = mark2ranges(d)
% r = mark2ranges(d)
%
% Given group identifiers this function builds ranges [start,end,groupid]
%
% For example: [1,1,1,1,1,2,2,2,2,3,3,3]
% Gives:
%     1     5     1
%     6     9     2
%    10    11     3

if size(d,1) > 1
    d = d';
end

a = diff(d);
a(end) = 1;
af = find(a);

r = end2ranges(af);
r(:,3) = d(af);

function r = end2ranges(e)
% logical to list of ranges start:end
%
% NOTE: repetitions not supported

if isempty(e)
    r = [];
else

q = e;

r = [1,q(1:end-1)+1; q]';
end