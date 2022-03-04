import numpy as np
import sys
from scipy.linalg import toeplitz

def ClController(a, b, poles, controllerType):
	supportTypes = ['proper', 'strictly_proper', 'proper_integral_action', 'strictly_proper_integral_action']
	if not controllerType in supportTypes:
		sys.exit("Error: Unsupported controller type.")
	
	numPoles = poles.size	# number of poles
	n = a.size - 1			# order of a(s)

	# Find min order of controller m
	m = 0
	if controllerType == 'proper':
		m = n-1
	elif controllerType == 'strictly_proper' or controllerType == 'proper_integral_action':
		m = n;
	elif controllerType == 'strictly_proper_integral_action':
		m = n+1

	# Check pole dimensions
	if m+n != numPoles:
		sys.exit('Error: Incorrect numer of poles for the provided P(s) and controllerType, the numer of poles should be: {}'.format(m+n))

	if a.size < b.size:
		sys.exit('Plant P(s) is not proper, i.e., its numerator polynomial has higher order than the denominator polynomial.')

	c = np.poly(poles)
	numCfCoefficients = c.size

	a_bar = np.concatenate((a, np.zeros(numCfCoefficients - a.size, dtype=np.complex_)))
	b_bar = np.concatenate((np.zeros(a.size - b.size, dtype=np.complex_), b))
	b_bar = np.concatenate((b_bar, np.zeros(numCfCoefficients - b_bar.size, dtype=np.complex_)))
	A = np.tril(toeplitz(a_bar))
	B = np.tril(toeplitz(b_bar))
	S = np.concatenate((A[:,0:m+1], B[:,0:m+1]), axis=1)

	if controllerType == 'proper':
		result = np.linalg.solve(S,c)
		p = result[0:m+1]
		q = result[m+1:]
	elif controllerType == 'strictly_proper':
		S = np.delete(S, m+1, 1)
		result = np.linalg.solve(S,c)
		p = result[0:m+1]
		q = result[m+1:]
	elif controllerType == 'proper_integral_action':
		S = np.delete(S, m, 1)
		result = np.linalg.solve(S,c)
		p = np.concatenate((result[0:m],np.zeros(1)))
		q = result[m:]
	elif controllerType == 'strictly_proper_integral_action':
		S = np.delete(S, np.s_[m:m+2], 1)
		result = np.linalg.solve(S,c)
		p = np.concatenate((result[0:m],np.zeros(1)))
		q = result[m:]

	# save details
	details = dict()
	details['a'] = a
	details['b'] = b
	details['c'] = c
	details['m'] = m
	details['n'] = n
	details['p'] = p
	details['q'] = q
	details['S'] = S
	return p, q, details

if __name__ == "__main__":
    poles = np.array([-1,-1,-1,-1, -1], dtype=np.complex_)
    a = np.array([1,-4,3], dtype=np.complex_) # a polynomial
    b = np.array([1,-2], dtype=np.complex_)   # b polynomial
    p, q, details = ClController(a, b, poles, 'strictly_proper_integral_action')
    print(details)
