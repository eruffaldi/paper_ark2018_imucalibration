function  L = chol2( A )

%#codegen
%CHOL2 Summary of this function goes here
%   Detailed explanation goes here
n = size(A,1);
L = eye(n);

% if any(eig(A) < 0) || any(any(imag(A)))
%     p = 1;
%     return
% end

L(1,1) = sqrt(A(1,1));
% if imag(L(1,1))
%     error('L(1,1) complex!');
if L(1,1) == 0
    error('L(1,1) zero!');
end


for j=1:n
    L(j,1) = 1/L(1,1)*A(1,j);
end

for i=2:n
    L(i,i) = sqrt(A(i,i)-sum(L(i,1:i-1).^2));
%     if imag(L(i,i))
%      error('diagonal element L complex!');
    if L(i,i) == 0
        error('diagonal element L zero!');
    end
    for k = i+1:n
        L(k,i) = 1/L(i,i)*(A(k,i)-sum(L(k,1:i-1).*L(i,1:i-1)));
    end
end
        
end

