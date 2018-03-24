% merge ranges that are separated less than th
function r = mergerange(rin,th)
if isempty(rin)
r = rin;
else
    
neg = [rin(1:end-1,2)+1,rin(2:end,1)-1]; % negative part of the ranges
l = (neg(:,2)-neg(:,1)+1);
neg = neg(l <= th & l > 0,:); % not empty and longer equal then th

if isempty(neg)
    r = rin;
else
    % not a special algorithm just join the ranges and convert back and
    % front
    %r = event2ranges(ranges2event([rin;neg]));
    r  = [rin;neg];
    n = max(r(:,2));
    e = zeros(n,1);
    for I=1:size(r,1)
        e(r(I,1):r(I,2)) = 1;
    end
    r = event2ranges(e);
end
end

% logical to list of ranges start:end
function r = event2ranges(e)

if isempty(e)
    r = [];
else
q = diff(e);
change = find((abs(q) > 0)); % sorry no tilde in mac
if e(1) == 0
else
    change = [0,change(:)'];
end

if mod(length(change),2) == 1
    change = [change(:)',length(e)];
end
r = reshape(change,2,length(change)/2)';
r(:,1) = r(:,1)+1;
end