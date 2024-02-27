from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
import os

# Load the images
image_folder = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Photos'
image_paths = [
    # os.path.join(image_folder,'ATT49_Photo 1.jpg'),
    os.path.join(image_folder,'ATT54_Photo 2.jpg'),
    os.path.join(image_folder,'ATT160_Photo 1.jpg'),
    os.path.join(image_folder,'ATT399_attachment1.jpg'),
    os.path.join(image_folder,'ATT421_K-110.jpg'),
    os.path.join(image_folder,'ATT588_K-263.jpg'),
    os.path.join(image_folder,'ATT589_K-264.jpg'),
    os.path.join(image_folder,'ATT825_D1-28.jpg'),
    os.path.join(image_folder,'ATT908_Photo 4.jpg')
]

images = [Image.open(path) for path in image_paths]

# Determine the grid size
grid_size = (2,4)  # Three rows, two columns

# Create a new figure with a defined size
fig, axs = plt.subplots(grid_size[0], grid_size[1], figsize=(15, 7))

# Flatten the Axes array
axs = axs.ravel()

# Loop through the images, adding each to the grid
for i, image in enumerate(images):
    # Turn off axis
    axs[i].axis('off')
    
    # Plot image on corresponding subplot
    axs[i].imshow(image)

# Turn off axes of any unused subplots
for j in range(i + 1, grid_size[0] * grid_size[1]):
    axs[j].axis('off')

# Adjust layout
plt.tight_layout()
# plt.show()

# Save the figure
fig.savefig('/Users/EC13/Documents/Projects/PRSN/Landslides/_docs/_media/ls_examples.png', 
            dpi=300, bbox_inches='tight')

