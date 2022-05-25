function T = getT(a, m)
aReordered = a(end:-1:1);
T = tril(toeplitz([aReordered(:);zeros(m-1,1)]));
T = T(:,1:m);
