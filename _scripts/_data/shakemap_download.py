import requests
import os
import pandas as pd

# The provided URL
url = "https://earthquake.usgs.gov/fdsnws/event/1/query.geojson?starttime=1500-01-01%2000:00:00&endtime=2023-02-19%2000:00:00&maxlatitude=23.789&minlatitude=13.094&maxlongitude=-57.217&minlongitude=-73.125&minmagnitude=3&orderby=time-asc&producttype=shakemap"

# Send a GET request to the URL
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the response JSON content
    geojson_data = response.json()
    
    # You can now work with the GeoJSON data directly in Python
    # For example, print the number of earthquake events returned
    print(f"Number of earthquake events returned: {len(geojson_data['features'])}")
else:
    print("Failed to fetch GeoJSON data.")

def download_file(url, local_filename):
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    return local_filename

local_path = '/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Vector/Shakemap'

shakemap_url = []
event_id = []
for feature in geojson_data['features']:
    event_id.append(feature['id'])
    properties = feature['properties']
    shakemap_url.append(properties['detail'])





for shakemap in shakemap_url:

    # Fetch detailed event information (this is a conceptual step - implementation may vary)
    details_response = requests.get(shakemap)
    if details_response.status_code == 200:
        detail = details_response.json()
        detail_contents = detail['properties']['products']['shakemap'][0]['contents']
        pgv_url = detail_contents['download/cont_pgv.json']['url']
        pga_url = detail_contents['download/cont_pga.json']['url']
        psa03_url = detail_contents['download/cont_psa0p3.json']['url']
        psa10_url = detail_contents['download/cont_psa1p0.json']['url']
        psa30_url = detail_contents['download/cont_psa3p0.json']['url']
        # Conceptual: Extract the ShakeMap download URL from the details data
        # This step is highly dependent on the structure of the detailed event data
        # and where the ShakeMap information is located within it.
        # You may need to navigate through the 'products' or similar sections.
        
        # If you find a ShakeMap URL, download the ShakeMap
        pgv_path = os.path.join(local_path,f"pgv/{detail['id']}_pgv.json")
        pga_path = os.path.join(local_path,f"pga/{detail['id']}_pga.json")
        
        download_file(pgv_url, pgv_path) 
        download_file(pga_url, pga_path) 
        
    else:
        pass