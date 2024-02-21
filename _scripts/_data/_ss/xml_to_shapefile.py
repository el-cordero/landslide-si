from osgeo import ogr, osr

# Load your XML file (assuming it's GML, a common geospatial XML format)
input_file = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/grid.xml'

# Create the output Shapefile
driver = ogr.GetDriverByName('ESRI Shapefile')
output_ds = driver.CreateDataSource('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/grid_shapefile.shp')
output_layer = output_ds.CreateLayer('layer', geom_type=ogr.wkbPoint)

# Define fields in the Shapefile
field_name = ogr.FieldDefn("Name", ogr.OFTString)
field_name.SetWidth(24)
output_layer.CreateField(field_name)

# Open the input GML
input_ds = ogr.Open(input_file)
input_layer = input_ds.GetLayer()

# Loop through input features and copy them to the output
for feature in input_layer:
    output_layer.CreateFeature(feature)

# Cleanup
del input_ds, output_ds
