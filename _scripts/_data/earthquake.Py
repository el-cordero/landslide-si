# detailed earthquake information

import requests
import numpy as np
import pandas as pd
from datetime import datetime
import ast

# local functions:
# convert_unix_to_date
# fetch_earthquake_data

fetch_points = pd.read_csv('/Users/EC13/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_center.csv')

# Example usage
start_date = "1500-01-01"
end_date = "2023-02-19"
min_mag = 3
distance = 200



# Initialize an empty DataFrame for eqdf if not already defined
eqdf = pd.DataFrame()


for lat, lon in zip(fetch_points.y, fetch_points.x):
    df = fetch_earthquake_data(start_date, end_date, min_mag, lat, lon, distance)
    # Check if the DataFrame is not empty
    if not df.empty:
        # Use pd.concat to combine eqdf and the new df if df is not empty
        eqdf = pd.concat([eqdf, df], ignore_index=True)
    

eqdf = eqdf.drop_duplicates(subset='id')

eqdf = eqdf.sort_values(by='time')
eqdf = eqdf.reset_index()
eqdf = eqdf.drop('index',axis=1)

eqdf.to_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')

eqdf = pd.read_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')

coordinates = eqdf['coordinates'].apply(ast.literal_eval)
eqdf[['lon', 'lat', 'value']] = pd.DataFrame(coordinates.tolist(), index=eqdf.index)
eqdf = eqdf.drop('coordinates',axis=1)

eqdf.to_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')
