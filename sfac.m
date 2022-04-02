function [d, details] = sfac(a, b)

eps_ = 1e-8;

maxSize = max(numel(a),numel(b));
a = [zeros(1, maxSize-numel(a)), a];
b = [zeros(1, maxSize-numel(b)), b];

aMinusS = a;
bMinusS = b;

aMinusS(numel(a)-1:-2:1) = -a(numel(a)-1:-2:1);
bMinusS(numel(b)-1:-2:1) = -b(numel(b)-1:-2:1);

f = conv(a, aMinusS) + conv(b, bMinusS);
rootsOfF = roots(f);

G1 = [];
flag1 = [];

for k = 1:numel(rootsOfF)
	index = -1;
	for l = 1:numel(G1)
		if flag1(l)==0 && abs(rootsOfF(k)+G1(l))<eps_
			index = l;
			break;
		end
	end
	if index == -1
		G1 = [G1 rootsOfF(k)];
		flag1 = [flag1 0];
	else
		flag1(index) = 1;
	end
end

d = poly(G1);

details.f = f;
details.rootsOfF = rootsOfF;
details.a = a;
details.aMinusS = aMinusS;
details.b = b;
details.bMinusS = bMinusS;
details.G1 = G1;
details.d = d;
