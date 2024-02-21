from osgeo import ogr, osr

input_file = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/USGS/shakemap/official17870502160000000.kml'
output_file = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap/test.geojson'

driver = ogr.GetDriverByName('GeoJSON')
input_ds = ogr.Open(input_file)
input_layer = input_ds.GetLayer()

# Create the output GeoJSON
output_ds = driver.CreateDataSource(output_file)
output_layer = output_ds.CreateLayer('layer', geom_type=ogr.wkbMultiPolygon)

# Add fields
layer_defn = input_layer.GetLayerDefn()
for i in range(layer_defn.GetFieldCount()):
    field_defn = layer_defn.GetFieldDefn(i)
    output_layer.CreateField(field_defn)

# Add features
for feature in input_layer:
    output_layer.CreateFeature(feature)

# Cleanup
del input_ds, output_ds
