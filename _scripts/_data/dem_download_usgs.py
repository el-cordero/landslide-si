import requests
import os

# Define the path to the file containing the URLs
file_path = r'C:/Users/estudiante/Documents/Projects/Data/GIS/Raster/usgslidarPR.txt'
file_path = r'/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/USGS/datatest.txt'

# Define the directory where files will be saved
save_dir = r'C:/Users/estudiante/Documents/Projects/Data/GIS/Raster/usgs_download'
save_dir = r'/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Spatial/Raster/USGS'
# Ensure the save directory exists
os.makedirs(save_dir, exist_ok=True)

# Read the file and download each URL
with open(file_path, 'r') as file:
    for line in file:
        url = line.strip()
        # Extract the file name from the URL
        file_name = url.split('/')[-1]
        save_path = os.path.join(save_dir, file_name)

        # Download and save the file
        print(f"Downloading {file_name}")
        response = requests.get(url)
        with open(save_path, 'wb') as f:
            f.write(response.content)
        print(f"Saved to {save_path}")

print("All files have been downloaded.")