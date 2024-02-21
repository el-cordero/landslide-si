# detailed earthquake information

import requests
import numpy as np
import pandas as pd
from datetime import datetime

# Example usage
earthquake_data = fetch_earthquake_data("1500-01-01", "2023-02-19", 
                                        3, 18.2208, -66.5901, 200)


extract_pga_pgv(earthquake_data)
features = earthquake_data['features']
eqdata = pd.DataFrame(features)


expanded_properties = eqdata['properties'].apply(pd.Series)
expanded_geom = eqdata['geometry'].apply(pd.Series)
eqdata = eqdata.drop(['properties','geometry'], axis=1)
eqdata = pd.concat([eqdata, expanded_properties, expanded_geom], axis=1)


eqdata.time = eqdata.time.apply(convert_unix_to_date)
eqdata.updated = eqdata.updated.apply(convert_unix_to_date)

eqdata.to_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')

