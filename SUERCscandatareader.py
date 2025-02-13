import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import griddata

# Define file names
dcy_filename = '31TOP.dcy'  # Replace with your .dcy filename
excel_filename = '31TOP_excel.xlsx'
processed_filename = '31TOP_excel_processed_data.xlsx'

# Read .dcy file, skipping header lines
dcy_data = pd.read_csv(dcy_filename, delimiter=', ', skiprows=14, engine='python')

# Error correction for values near 2^24
error_value = 2**24
tolerance = 1e5
dcy_data = dcy_data.applymap(lambda x: x - error_value if abs(x - error_value) < tolerance else (x + error_value if abs(x + error_value) < tolerance else x))

# Save to Excel
dcy_data.to_excel(excel_filename, index=False)

# Reload data with proper headers
data = pd.read_excel(excel_filename)
headers = data.columns

# Identify Background and Laser_On columns
background_columns = [col for col in headers if 'background' in col.lower()]
laser_on_columns = [col for col in headers if 'laser_on' in col.lower()]

# Extract XY, Background, and OSL data
xy_data = data.iloc[:, :2]  # First two columns for X and Y
background_data = data[background_columns]
osl_data = data[laser_on_columns]

# Compute background subtracted data
background_sum = background_data.sum(axis=1)
osl_sum = osl_data.sum(axis=1)
z_values = osl_sum - background_sum

# Combine results into a new DataFrame
result_data = xy_data.copy()
result_data['z_values'] = z_values
result_data.to_excel(processed_filename, index=False)

# Surface Plot
x = xy_data.iloc[:, 0].values
y = xy_data.iloc[:, 1].values
z = z_values.values

valid_rows = np.isfinite(x) & np.isfinite(y) & np.isfinite(z)
x, y, z = x[valid_rows], y[valid_rows], z[valid_rows]

# Create a grid
xi = np.linspace(min(x), max(x), 100)
yi = np.linspace(min(y), max(y), 100)
X, Y = np.meshgrid(xi, yi)
Z = griddata((x, y), z, (X, Y), method='cubic')

# Plot
fig, ax = plt.subplots(figsize=(8, 6))
c = ax.pcolormesh(X, Y, Z, shading='auto', cmap='jet')
fig.colorbar(c, ax=ax, label='(OSL - Background)')
ax.set_xlabel('Depth (um)')
ax.set_ylabel('Length (um)')
ax.set_title('Surface Plot of OSL minus Background')
plt.show()
