# BEFORE RUNNING: MAKE SURE TO CHANGE BACKEND SETTINGS ON SPYDER/ANACONDA: Tools → Preferences → IPython Console → Graphics → under 'Backend' select 'Automatic'


import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import PolygonSelector
from skimage.io import imread
from skimage.draw import polygon
import cv2

# Load the image
image_path = "Xerox Scan_31052023144524_page-0001.jpg"
image = imread(image_path)

# Create a figure and axes
fig, ax = plt.subplots()
ax.imshow(image)
ax.set_title("Draw a polygon around the object and close the window when done")

polygon_points = []

# Function to store polygon points
def onselect(verts):
    global polygon_points
    polygon_points = np.array(verts)
    plt.close(fig)  # Close the window once selection is done

# Use PolygonSelector for interactive selection
selector = PolygonSelector(ax, onselect)

# Show the image in an interactive window
plt.show(block=True)  # Ensures the window stays open for interaction

# Convert the polygon to a mask
if polygon_points.any():
    mask = np.zeros(image.shape[:2], dtype=bool)
    rr, cc = polygon(polygon_points[:, 1], polygon_points[:, 0], mask.shape)
    mask[rr, cc] = True

    # Show the boolean mask
    plt.figure()
    plt.imshow(mask, cmap="gray")
    plt.title("Polygon Boolean Mask")
    plt.axis("off")
    plt.show()

    # Save the mask
    cv2.imwrite("polygon_boolean_mask.png", (mask * 255).astype(np.uint8))

    # Surface plot of the mask
    X, Y = np.meshgrid(np.arange(mask.shape[1]), np.arange(mask.shape[0]))
    aligned_mask = np.flipud(mask)  # Flip vertically if needed

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.plot_surface(X, Y, aligned_mask.astype(float), cmap='gray', edgecolor='none')
    ax.set_xlabel("X (columns)")
    ax.set_ylabel("Y (rows)")
    ax.set_zlabel("Mask Value")
    ax.set_title("Surface Plot of the Aligned Boolean Mask")
    plt.show()

    print(f"Boolean Mask Size: {mask.shape}")
else:
    print("No polygon was drawn.")
