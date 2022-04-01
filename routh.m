function T = routh(p)

N = ceil(numel(p)/2);
T = zeros(numel(p), N);
r0 = p(1,1:2:end);
r1 = p(1,2:2:end);
T(1,1:numel(r0)) = r0;
T(2,1:numel(r1)) = r1;

for r = 3:numel(p)
	for c = 1:N-1
		if T(r-1,c) == 0
			continue;
		end
		T(r,c) = -1/T(r-1,c)*det(T(r-2:r-1,c:c+1));
	end
end
