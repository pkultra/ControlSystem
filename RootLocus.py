import numpy as np
import control
import control.matlab as ctrlm
import matplotlib.pyplot as plt

# %% Creating model:
num = np.poly([-3, -5])
den = np.poly([-2,-4,-6])
H = ctrlm.tf(num, den)

ctrlm.rlocus(H)
plt.show()
