from datetime import datetime

def convert_unix_to_date(timestamp_ms, date_format='%Y-%m-%d %H:%M:%S'):
    """
    Converts a Unix timestamp in milliseconds to a human-readable date format.

    Parameters:
    - timestamp_ms: Unix timestamp in milliseconds.
    - date_format: String representing the desired format of the output date.

    Returns:
    - A string representing the date and time in the specified format.
    """
    # Convert milliseconds to seconds
    timestamp_s = timestamp_ms / 1000

    # Convert to a datetime object
    date_time = datetime.utcfromtimestamp(timestamp_s)

    # Format the date
    formatted_date = date_time.strftime(date_format)

    return formatted_date

# Example usage
timestamp_ms = 1676752460510
formatted_date = convert_unix_to_date(timestamp_ms)
print("Formatted Date:", formatted_date)


def extract_pga_pgv(earthquake_data):
    for earthquake in earthquake_data['features']:
        properties = earthquake['properties']
        if 'shakemap' in properties['types']:
            shakemap_info = properties['products']['shakemap'][0]
            pga = shakemap_info['properties']['pga']
            pgv = shakemap_info['properties']['pgv']
            print(f"Earthquake ID: {properties['code']} | PGA: {pga} | PGV: {pgv}")

