function [p, q, details] = optrobust2dof(a, b, rho)

n = numel(a)-1;

[dRho, detailsFactorization] = sfac(a, rho*b);

aResized = detailsFactorization.a;
bResizedRho = detailsFactorization.b;

aMinusS = detailsFactorization.aMinusS;
bMinusSRho = detailsFactorization.bMinusS;

J = diag((-1*ones(1,n)).^([n-1:-1:0]));

F = getT(dRho, n);
E = getS(bMinusSRho, -aMinusS, n)*(getS(aResized, bResizedRho, n)\F);

F0 = F(1:n,:);
E0 = E(1:n,:);

H = J*(F0\E0);

[V, D] = eig(H);
[D_Magnitude, I] = max(abs(diag(D)));

eVector = V(:,I(1)).';

[p, q, detailsPoleplace] = poleplace(a,b,roots(conv(dRho,eVector)),'proper');

details.F = F;
details.E = E;
details.F0 = F0;
details.E0 = E0;
details.H = H;
details.eVector = eVector;
