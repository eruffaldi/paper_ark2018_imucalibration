function oq = allp(Ps2)

q = Ps2;
d = diff(q);
thr = 0.16;
threl = 0;

%%
mark = zeros(length(q),1);
for I=1:size(q,2)
    up = mean(d(:,I))+thr*std(d(:,I));
    if threl == 1
        fi = find(abs(d(:,I)) > up);
    else
        fi = find(abs(d(:,I)) > thr);
    end
    mark(fi) = 1;
end
% plot(q);
% hold on;
% plot(mark,'k*');
% hold off

%%
% Mark contains all problems
parts = mark2ranges(mark);
parts = parts(parts(:,3) == 1,:);
length(parts);
parts = mergeranges(parts(:,1:2),60);
length(parts);
% if two are to near join

oq = q; %zeros(size(q));
cutaround=2; % how much enlarge the cut
usearound=10; % margin around the cut
method='spline';

for I=1:size(parts,1)   
    a = parts(I,1);
    b = parts(I,2);
    %[parts(I),parts(I+1)]
    pre = max(1,a-cutaround);
    post = min(b+cutaround,length(q));
    prec = max(1,a-usearound);
    postc = min(b+usearound,length(q));
    inrange = [prec:pre-1,post+1:postc];
    oq(pre:post,:) = interp1(inrange,q(inrange,:),pre:post,method);    
end
