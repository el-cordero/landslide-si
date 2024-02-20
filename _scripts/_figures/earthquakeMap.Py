import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

fig, ax = plt.subplots(figsize=(10, 8))
map = Basemap(projection='merc', llcrnrlat=17, urcrnrlat=19, llcrnrlon=-67, urcrnrlon=-65, resolution='i')
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