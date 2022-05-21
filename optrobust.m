function [p, q, details] = optrobust(a, b)

% Check plant order 
if numel(a) ~=2 && numel(b) ~= 2 
	error("Only support first order plant, i.e., both numerator and denorminator have order 1.");     
end

d = sfac(a,b);
[p,q] = poleplace(a,b,roots(d),'proper');

details.a = a;
details.b = b;
details.d = d;
details.p = p;
details.q = q;
