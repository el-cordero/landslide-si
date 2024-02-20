import requests

def fetch_earthquake_data(starttime, endtime, minmagnitude, 
                          centerlat, centerlon, km):
    base_url = "https://earthquake.usgs.gov/fdsnws/event/1/query"
    payload = {
        "format": "geojson",
        "starttime": starttime,
        "endtime": endtime,
        "minmagnitude": minmagnitude,
        "latitude": centerlat,
        "longitude": centerlon,
        "maxradiuskm": km
    }
    response = requests.get(base_url, params=payload)
    return response.json()
