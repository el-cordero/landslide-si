import arcpy

# Set workspace to the directory containing rasters
arcpy.env.workspace = 'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs_download'

# List all raster datasets in the workspace
raster_list = arcpy.ListRasters()

# Output parameters
output_location = 'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\'
output_raster_name = 'usgs2024.tif'

# Merge rasters
arcpy.management.MosaicToNewRaster(
    input_rasters=raster_list,
    output_location=output_location,
    raster_dataset_name_with_extension=output_raster_name,
    pixel_type='8_BIT_UNSIGNED',  # Adjust as needed
    mosaic_method='LAST',
    number_of_bands=1  # Adjust based on your rasters
)

print("Merging complete.")
