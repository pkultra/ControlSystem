function [p, q, details] = opttran(a,b,rho,mu)

d_rho = sfac(a,rho*b);
d_mu = sfac(a,mu*b);

c = conv(d_rho,d_mu);

[p,q] = poleplace(a,b,roots(c),'strictly_proper');

details.p = p;
details.c = c;
details.q = q;
details.d_rho = d_rho;
details.d_mu = d_mu;

