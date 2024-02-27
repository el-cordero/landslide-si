import arcpy

# Set workspace to the directory containing rasters
arcpy.env.workspace = r'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs_download2018'

# List all raster datasets in the workspace
raster_list = arcpy.ListRasters()

# Output parameters
output_location = r'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster'
output_raster_name = 'usgs2018.tif'

# Merge rasters
arcpy.management.MosaicToNewRaster(
    input_rasters=raster_list,
    output_location=output_location,
    raster_dataset_name_with_extension=output_raster_name,
    pixel_type='32_BIT_UNSIGNED',  # Adjust as needed
    mosaic_method='LAST',
    number_of_bands=1  # Adjust based on your rasters
)

print("Merging complete 2018.")

# arcpy.Resample_management(in_raster='C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs2018.tif', 
#                           out_raster='C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs2018_5m.tif', 
#                           cell_size="5", 
#                           resampling_type="BILINEAR")


# Set workspace to the directory containing rasters
arcpy.env.workspace = r'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs_download2015'

# List all raster datasets in the workspace
raster_list = arcpy.ListRasters()

# Output parameters
output_location = r'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster'
output_raster_name = 'usgs2015.tif'

# Merge rasters
arcpy.management.MosaicToNewRaster(
    input_rasters=raster_list,
    output_location=output_location,
    raster_dataset_name_with_extension=output_raster_name,
    pixel_type='32_BIT_UNSIGNED',  # Adjust as needed
    mosaic_method='LAST',
    number_of_bands=1  # Adjust based on your rasters
)

print("Merging complete 2015.")

# Merge new rasters
arcpy.management.MosaicToNewRaster(
    input_rasters=[r'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs2018.tif',
                   r'C:\Users\estudiante\Documents\Projects\Data\GIS\Raster\usgs2015.tif'],
    output_location='C:\Users\estudiante\Documents\Projects\Data\GIS\Raster',
    raster_dataset_name_with_extension='usgs2024.tif',
    pixel_type='32_BIT_UNSIGNED',  # Adjust as needed
    mosaic_method='First',
    number_of_bands=1  # Adjust based on your rasters
)



