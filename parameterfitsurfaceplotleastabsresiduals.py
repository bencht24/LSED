import numpy as np
import matplotlib.pyplot as plt

# Given Data
x = np.array([1.04, 2.22333333333333, 3.39333333333333, 4.02, 5.38333333333333,
              6.67666666666667, 8.18, 9.70333333333333, 11.09, 12.2533333333333,
              13.8166666666667, 15.3233333333333, 16.8133333333333, 18.1266666666667,
              19.6733333333333, 21.3233333333333, 22.7233333333333, 25.3966666666667,
              26.8966666666667, 29.03, 30.28])

L = np.array([0, 0.00975636438163995, 0.057361433427564, 0.026750329314909, 0.0428537112846817,
              0.0704960988239085, 0.0536668017915828, 0.29002388452717, 0.196744879360554,
              0.870901138416643, 0.689029148093359, 1.29947849236274, 1.34463973607678,
              1.03999901248472, 1.03982721712197, 0.846011962927814, 0.863685623563919,
              0.863494357098247, 1.19505927274062, 1.09116551538459, 0.986595231212624])

error_L = np.array([0.00320479846460689, 0.00204303182499297, 0.00582706141037327, 0.00318581787205527,
                     0.00447290991270651, 0.00469713442372092, 0.00343600806930636, 0.0073486853235461,
                     0.00493909963444319, 0.0190504014580511, 0.0226953268078108, 0.029364716836165,
                     0.0321851673329639, 0.0227169586825521, 0.0270864460301806, 0.0378114693514792,
                     0.0321960471452477, 0.0270317039389524, 0.0307029347158349, 0.0359358303023111,
                     0.0400564535020012])

# Known value of t
t = 1000000  # Change this as needed

# User-defined range for ps and u
ps_range = np.linspace(0, 0.001, 1000)
u_range = np.linspace(0.001, 1.2, 1000)

# Initialize misfit matrix
misfit = np.zeros((len(u_range), len(ps_range)))

# Loop over all combinations of ps and u
for i, u in enumerate(u_range):
    for j, ps in enumerate(ps_range):
        # Compute model predictions
        L_model = np.exp(-ps * t * np.exp(-u * x))
        
        # Compute misfit using least absolute residuals (L1 norm)
        misfit[i, j] = np.sum(np.abs((L - L_model) / error_L))

# Find best-fit parameters
min_misfit = np.min(misfit)
best_u_idx, best_ps_idx = np.unravel_index(np.argmin(misfit), misfit.shape)
best_u = u_range[best_u_idx]
best_ps = ps_range[best_ps_idx]

# Normalize and invert misfit values
misfit_inv = 1.0 / misfit
misfit_inv /= np.max(misfit_inv)  # Normalize

# Compute 1-sigma confidence interval (Δχ² = 1 threshold)
threshold = min_misfit + 1
valid_indices = np.where(misfit <= threshold)

# Extract confidence interval range
u_min, u_max = np.min(u_range[valid_indices[0]]), np.max(u_range[valid_indices[0]])
ps_min, ps_max = np.min(ps_range[valid_indices[1]]), np.max(ps_range[valid_indices[1]])

# Compute uncertainties as half-range
u_uncertainty = (u_max - u_min) / 2
ps_uncertainty = (ps_max - ps_min) / 2

# Display results
print("Best-fit parameters:")
print(f"  u  = {best_u:.5f} ± {u_uncertainty:.5f}")
print(f"  ps = {best_ps:.5f} ± {ps_uncertainty:.5f}")

# Surface plot
plt.figure(figsize=(8, 6))
plt.contourf(ps_range, u_range, misfit_inv, levels=50, cmap='viridis')
plt.colorbar(label='Normalized Inverse Misfit')
plt.xlabel('ps')
plt.ylabel('u')
plt.title('Parameter Space Exploration (Least Absolute Residuals)')
plt.scatter(best_ps, best_u, color='red', marker='o', label='Best Fit')
plt.legend()
plt.show()

