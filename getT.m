function T = getT(a, m)
T = tril(toeplitz([a(:);zeros(m-1,1)]));
T = T(:,1:m);
