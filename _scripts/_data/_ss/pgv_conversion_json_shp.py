
import glob
import os
import geopandas as gpd

# Path to the directory containing your GeoJSON files
directory_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgv'

# Use glob to find all GeoJSON files in the directory
geojson_files = glob.glob(os.path.join(directory_path, '*.json'))
file_names = [os.path.basename(file) for file in geojson_files]

output_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/pgvShapefiles'
for i in range(0,len(geojson_files)):
    # Read the GeoJSON file
    gdf = gpd.read_file(geojson_files[i])
    
    # Define the output path for the Shapefile
    # This uses the original filename but with the .shp extension
    output_file = os.path.splitext(file_names[i])[0] + '.shp'
    output_file = os.path.join(output_path,output_file)
    
    # Save the GeoDataFrame as a Shapefile
    gdf.to_file(output_file)
    
    print(f'Converted {file_names[i]} to {output_file}')
