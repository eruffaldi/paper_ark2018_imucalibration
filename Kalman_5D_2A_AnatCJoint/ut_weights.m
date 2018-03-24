function [WM,W,c] = ut_weights(alpha, beta, k, n)

%#codegen

% Apply default values%
% Compute the normal weights 
%
% lambda = 2;
lambda = alpha^2*(k+n)-n;	  

WM = zeros(2*n+1,1);
WC = zeros(2*n+1,1);

for j=1:2*n+1
  if j==1
    wm = lambda / (n + lambda);
    wc = lambda / (n + lambda) + (1 - alpha^2 + beta);
  else
    wm = 1 / (2 * (n + lambda));
    wc = wm;
  end
  WM(j) = wm;
  WC(j) = wc;
end

c = n + lambda;

 W = eye(length(WC)) - repmat(WM,1,length(WM));
 W = W * diag(WC) * W';
end