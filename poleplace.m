%% Minimum-order closed-loop controller with pole placements
% Inputs:
% a: denorminator polynomial coefficients of plant P(s), row vector
% b: numerator polynomial coefficients of plant P(s), row vector
% poles: desired poles, row vector
% controllerType: type of controller, string
% Outputs:
% p: denorminator polynomial coefficients of controller C(s), row vector
% q: numerator polynomial coefficients of controller C(s), row vector
% details: details of calculation process, struct  
function [p,q,details] = poleplace(a,b,poles,controllerType)
  % Check type
  if ~strcmp(controllerType, 'proper') &&...
     ~strcmp(controllerType, 'strictly_proper') &&... 
     ~strcmp(controllerType, 'proper_integral_action') &&...
     ~strcmp(controllerType, 'strictly_proper_integral_action') 
     error("Unsupported controller type");     
  end
  
  numPoles = numel(poles); %number of pols
  n = numel(a)-1; % the numCfCoefficients of a(s)
  
  % Find min order of controller m
  m = 0;
  switch(controllerType)
    case 'proper'
      m = n-1;
    case {'strictly_proper', 'proper_integral_action'}
      m = n;
    case 'strictly_proper_integral_action'
      m = n+1;
  end

  % Check poles dimensions
  if m+n~=numPoles
    error(strcat('Incorrect numer of poles for the provided P(s) and controllerType, the numer of poles should be: ', int2str(m+n)));
  end
  if numel(a)<numel(b)
    error('Plant P(s) is not proper, i.e., its numerator polynomial has higher order than the denominator polynomial.');
  end

  % Characteristic function  
  c = poly(poles).';
  numCfCoefficients = numel(c);
  abar = [a, zeros(1,numCfCoefficients-numel(a))];
  A = tril(toeplitz(abar));
  b = [zeros(1, numel(a)-numel(b)), b];
  bbar = [b, zeros(1,numCfCoefficients-numel(b))];
  B = tril(toeplitz(bbar));
  S = [A(:,1:(1+m)), B(:,1:(1+m))];

  p = 1;
  q = 1;
  switch(controllerType)
    case 'proper'
	  result = S\c;
	  p = result(1:1+m);
	  q = result(m+2:end);
    case 'strictly_proper' 
	  S(:,m+2)=[];
	  result = S\c;
	  p = result(1:1+m);
	  q = result(m+2:end);
	case 'proper_integral_action'
	  S(:,m+1)=[];
	  result = S\c;
	  p = [result(1:m); 0];
	  q = result((m+1):end);
    case 'strictly_proper_integral_action'
	  S(:,[m+1,m+2])=[];
	  result = S\c;
	  p = [result(1:m); 0];
	  q = result((m+1):end);
  end
  p = p.';
  q = q.';
  
  % Save details
  details.n = n;
  details.m = m;
  details.p = p;
  details.q = q;
  details.S = S;
  details.c = c.';
  details.a = a;
  details.b = b;
