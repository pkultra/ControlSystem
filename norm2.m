function [y, details] = norm2(a,b)

T1 = routh(a);
T2 = routh(b);
T3 = T2;

T2 = [T2; zeros(size(T1,1)-size(T2,1), size(T2,2))];
T2(2:2:size(T2,1),:) = T1(2:2:size(T2,1), 1:size(T2,2));
T2 = getSubTable(3, T2);

T3(1,:) = 0;
T3 = [T3; zeros(size(T1,1)-size(T3,1), size(T3,2))];
T3(3:2:size(T3,1),:) = T1(3:2:size(T3,1), 1:size(T3,2));
T3 = getSubTable(4, T3);

alpha = T1(1:end-1, 1)./T1(2:end, 1);
beta = zeros(numel(alpha), 1);
beta(1:2:end) = T2(1:2:end-1, 1)./T1(2:2:end-1, 1);
beta(2:2:end) = T3(2:2:end-1, 1)./T1(3:2:end-1, 1);

y = sqrt(sum(beta.^2./alpha/2));

details.table1 = T1;
details.table2 = T2;
details.table3 = T3;
details.alpha = alpha;
details.beta = beta;
details.y = y;

function T = getSubTable(startingRow, inputT)
	T = inputT;
	for r = startingRow:2:size(T,1)
		for c = 1:size(T,2)-1
			if T(r-1,c) == 0
				continue;
			end
			T(r,c) = -1/T(r-1,c)*det(T(r-2:r-1,c:c+1));
		end
	end
end

end
