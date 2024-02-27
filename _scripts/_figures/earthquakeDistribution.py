import matplotlib  
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime


eqdf = pd.read_csv('~/Documents/Projects/PRSN/Hazus/Data/Tables/earthquake_data.csv')
eqdf.time = pd.to_datetime(eqdf.time)
eqdf['year'] = eqdf.time.dt.year

lat_min, lat_max = 17.5, 20.0  # Latitude bounds
lon_min, lon_max = -70, -64.5  # Longitude bounds

# Filter the dataset for earthquakes within these bounds
eqdf_pr = eqdf[(eqdf['lat'] >= lat_min) & (eqdf['lat'] <= lat_max) &
                                     (eqdf['lon'] >= lon_min) & (eqdf['lon'] <= lon_max)]

eqdf_year = eqdf_pr[eqdf_pr['year'] >= 1999]

bar_chart_data = eqdf_year.groupby('year').size()

# Creating a 3D plot for the entire dataset without filtering by date and without attempting a grid visualization
fig = plt.figure(figsize=(14, 5))
ax = fig.add_subplot(121, projection='3d')

# Plotting the entire dataset
sc = ax.scatter(eqdf['lon'], eqdf['lat'], eqdf['mag'], c=eqdf['mag'], 
                cmap='coolwarm', alpha=0.8,marker='x')

# Labels and title for the entire dataset
ax.set_xlabel('Longitude')
ax.set_ylabel('Latitude')
ax.set_zlabel('Magnitude')
ax.set_ylim(15.5,24)
ax.set_xlim(-70,-60)
ax.set_zlim(3.0,7.1)
ax.set_title('(a) Latitude and Longitude (Entire Dataset)')

# Setting the angle of the view for better visualization
ax.view_init(30, 240)

# Creating a 3D plot for the entire dataset without filtering by date and without attempting a grid visualization
ax2 = fig.add_subplot(122, projection='3d')

# Plotting the entire dataset
sc2 = ax2.scatter(eqdf_year['year'], eqdf_year['lat'], eqdf_year['mag'], 
                c=eqdf_year['mag'], cmap='coolwarm', alpha=0.8,marker='x')

# Labels and title for the entire dataset
ax2.set_xlabel('Time')
ax2.set_ylabel('Latitude')
ax2.set_zlabel('Magnitude')
ax2.set_title('(b) Latitude and Time (1999 onwards)')

# Setting the angle of the view for better visualization
ax2.view_init(30, 240)

# Create a colorbar for the entire figure, rather than for each subplot
fig.colorbar(sc, ax=[ax, ax2], label='Magnitude', shrink=0.5, aspect=10)
# fig.suptitle('Earthquake Magnitudes', fontsize=16)

fig.savefig('/Users/EC13/Documents/Projects/PRSN/Landslides/_docs/_media/eq_magnitudes.png',
            dpi=300, bbox_inches = matplotlib.transforms.Bbox.from_bounds(1.5, 0.2, 10.2, 4.6))


fig, axs = plt.subplots(2, 1, figsize=(13, 12))  # 2 rows, 1 column

# Plot 1: Number of Earthquakes per Year
axs[0].bar(bar_chart_data.index, bar_chart_data.values, color='gray')
axs[0].set_title('')
axs[0].set_xlabel('')
axs[0].set_ylabel('(a) Number of Earthquakes')
axs[0].tick_params(axis='x', rotation=45)
axs[0].grid(axis='y', linestyle='--')

# Plot 2: Earthquake Magnitudes Over Time
scatter = axs[1].scatter(eqdf_year['time'], eqdf_year['mag'],color='gray')
axs[1].set_title('')
axs[1].set_xlabel('Year')
axs[1].set_ylabel('(b) Magnitude')
axs[1].tick_params(axis='x', rotation=45)
axs[1].grid(True)

# Adjust layout
plt.tight_layout()

fig.savefig('/Users/EC13/Documents/Projects/PRSN/Landslides/_docs/_media/eq_frequency.png',
            dpi=300) #bbox_inches = matplotlib.transforms.Bbox.from_bounds(1.5, 0.2, 10.2, 4.6))