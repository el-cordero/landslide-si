import json

def coveragejson_to_geojson(coveragejson_path, output_geojson):
    # Load the CoverageJSON file
    with open(coveragejson_path, 'r') as file:
        coveragejson = json.load(file)
    
    # Initialize an empty GeoJSON structure
    geojson = {
        "type": "FeatureCollection",
        "features": []
    }
    
    # Assuming the CoverageJSON structure has a domain with an array of latitudes and longitudes
    for point in coveragejson['domain']['axes']['y']['values']:
        lat = point
        for lon in coveragejson['domain']['axes']['x']['values']:
            # Assuming a simple structure where values are directly accessible
            # This part needs to be adjusted based on the actual CoverageJSON structure
            value = coveragejson['ranges']['psa']['values'][0]  # Example, adjust according to your CoverageJSON
            
            # Construct a GeoJSON feature for each point
            feature = {
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [lon, lat]
                },
                "properties": {
                    "value": value
                }
            }
            geojson['features'].append(feature)
            coveragejson['ranges']['psa']['values'].pop(0)  # Adjust based on your CoverageJSON structure
    
    # Save the GeoJSON to a file
    with open(output_geojson, 'w') as file:
        json.dump(geojson, file, indent=4)

# Example usage
coveragejson_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/USGS/shakemap/coverage_psa3p0_high_res.covjson'
outjson_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/USGS/shakemap/coverage_psa3p0_high_res.geojson'
coveragejson_to_geojson(coveragejson_path,outjson_path)

with open(coveragejson_path, 'r') as file:
    coveragejson = json.load(file)
    
    # Initialize an empty GeoJSON structure
geojson = {
    "type": "FeatureCollection",
    "features": []
}

# dict_keys(['type', 'domain', 'parameters', 'ranges'])
coveragejson['parameters']
