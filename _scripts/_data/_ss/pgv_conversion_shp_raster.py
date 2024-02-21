import os
import geopandas as gpd
import rasterio
from rasterio.transform import from_origin
from rasterio.features import rasterize
import numpy as np
import matplotlib.pyplot as plt
import glob

# Directory containing the shapefiles
shapefiles_directory_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgvShapefiles'

# Directory to save the raster files
output_rasters_directory_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/Shakemap/pgv'

# Find all shapefiles in the directory
shapefiles = glob.glob(os.path.join(shapefiles_directory_path, '*.shp'))

for shapefile_path in shapefiles:
    # Load the shapefile
    gdf = gpd.read_file(shapefile_path)
    
    # Determine the bounds and calculate raster dimensions as before
    bounds = gdf.total_bounds
    resolution = 0.01  # Example resolution
    width = int((bounds[2] - bounds[0]) / resolution)
    height = int((bounds[3] - bounds[1]) / resolution)
    transform = from_origin(bounds[0], bounds[3], resolution, resolution)
    
    # Rasterize the geometries
    raster = np.zeros((height, width))
    shapes = ((geom, 1) for geom in gdf.geometry)
    rasterized = rasterize(shapes=shapes, out_shape=raster.shape, transform=transform, fill=0)
    
    # Define the output raster file path
    filename = os.path.basename(shapefile_path)
    filename_no_ext = os.path.splitext(filename)[0]
    output_raster_path = os.path.join(output_rasters_directory_path, f"{filename_no_ext}.tif")
    
    # Save the rasterized data to a new file
    with rasterio.open(
        output_raster_path, 'w',
        driver='GTiff',
        height=raster.shape[0],
        width=raster.shape[1],
        count=1,
        dtype=rasterized.dtype,
        crs=gdf.crs,
        transform=transform,
    ) as dst:
        dst.write(rasterized, 1)
    
    print(f"Converted {shapefile_path} to {output_raster_path}")

shapefile_path = shapefiles[0]
gdf = gpd.read_file(shapefile_path)
    
# Determine the bounds and calculate raster dimensions as before
bounds = gdf.total_bounds
resolution = 0.01  # Example resolution
width = int((bounds[2] - bounds[0]) / resolution)
height = int((bounds[3] - bounds[1]) / resolution)
transform = from_origin(bounds[0], bounds[3], resolution, resolution)

# Rasterize the geometries
raster = np.zeros((height, width))
shapes = ((geom, 1) for geom in gdf.geometry)
rasterized = rasterize(shapes=shapes, out_shape=raster.shape, transform=transform, fill=None)


plt.figure(figsize=(10, 6))
plt.imshow(rasterized, cmap='viridis')  # 'viridis' is a commonly used colormap; change as needed
plt.colorbar(label='Raster values')  # Adjust the label as appropriate
plt.title('Raster Visualization')
plt.xlabel('Column Number')
plt.ylabel('Row Number')
plt.show()

# Define the output raster file path
filename = os.path.basename(shapefile_path)
filename_no_ext = os.path.splitext(filename)[0]
output_raster_path = os.path.join(output_rasters_directory_path, f"{filename_no_ext}.tif")

# Save the rasterized data to a new file
with rasterio.open(
    output_raster_path, 'w',
    driver='GTiff',
    height=raster.shape[0],
    width=raster.shape[1],
    count=1,
    dtype=rasterized.dtype,
    crs=gdf.crs,
    transform=transform,
) as dst:
    dst.write(rasterized, 1)

print(f"Converted {shapefile_path} to {output_raster_path}")
