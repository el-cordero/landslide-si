import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from mpl_toolkits.basemap import Basemap

pd.read_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')

lats = np.array([feature['geometry']['coordinates'][1] for feature in features])
lons = np.array([feature['geometry']['coordinates'][0] for feature in features])
magnitudes = np.array([feature['properties']['mag'] for feature in features])

fig, ax = plt.subplots(figsize=(10, 8))
map = Basemap(projection='merc', llcrnrlat=16, urcrnrlat=21, llcrnrlon=-70, urcrnrlon=-65, resolution='i')
map.drawcoastlines()
map.drawcountries()
map.drawstates()
map.drawmapboundary(fill_color='aqua')
map.fillcontinents(color='coral',lake_color='aqua')
x, y = map(lons, lats)
scatter = map.scatter(x, y, s=magnitudes * 10, c=magnitudes, cmap='Reds', alpha=0.7, edgecolors="k", linewidth=0.5)

plt.colorbar(scatter, label='Magnitude')
plt.title('Custom ShakeMap: Earthquake Magnitudes in Puerto Rico')
plt.show()