import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from mpl_toolkits.basemap import Basemap
import ast

features = pd.read_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')

features = features.sort_values('mag',ascending=True)

fig, ax = plt.subplots(figsize=(10, 8))
x, y = map(np.array(features.lon), np.array(features.lat))
map = Basemap(projection='merc', llcrnrlat=min(features.lat), urcrnrlat=max(features.lat), 
              llcrnrlon=min(features.lon), urcrnrlon=max(features.lon), resolution='i')
map.drawcoastlines()
map.drawcountries()
map.drawstates()
map.drawmapboundary(fill_color='aqua')
map.fillcontinents(color='coral',lake_color='aqua')
x, y = map(np.array(features.lon), np.array(features.lat))
scatter = map.scatter(x, y, s=np.array(features.mag) * 10, c=np.array(features.mag),
                      cmap='Reds', alpha=0.7, edgecolors="k", linewidth=0)

plt.colorbar(scatter, label='Magnitude')
plt.title('Custom ShakeMap: Earthquake Magnitudes in Puerto Rico')
plt.show()


features.to_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data_refined.csv')
