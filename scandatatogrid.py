import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import griddata

# Filename
filename = '31TOP_excel_processed_data.xlsx'

# Read the data from Excel
data = pd.read_excel(filename)

# Convert to matrix
xyz_matrix = data.iloc[:, :3].values

# Data matrix generator organizer
X = xyz_matrix[:, 0]
Y = xyz_matrix[:, 1]
Z = xyz_matrix[:, 2]

# Grid generator
unique_X = np.unique(X)
unique_Y = np.unique(Y)
XGrid, YGrid = np.meshgrid(unique_X, unique_Y)
ZGrid = griddata((X, Y), Z, (XGrid, YGrid), method='cubic')

# Plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
surf = ax.plot_surface(XGrid, YGrid, ZGrid, cmap='viridis')
ax.set_title('Surface Plot of ZGrid')
ax.set_xlabel('X-axis')
ax.set_ylabel('Y-axis')
ax.set_zlabel('Z-axis')
fig.colorbar(surf)
plt.show()
