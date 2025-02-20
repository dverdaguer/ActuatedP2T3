import requests
import json
import pandas as pd
import threading
import time

## Station information: 'https://gbfs.divvybikes.com/gbfs/en/station_information.json'
STATION_STATUS = 'https://gbfs.lyft.com/gbfs/1.1/chi/en/station_status.json'

id_list = [
    "a3ad5c90-a135-11e9-9cda-0a87ae2ba916",
    "1850866657089146912",
    "a3aaa17b-a135-11e9-9cda-0a87ae2ba916",
    "a3aabfe3-a135-11e9-9cda-0a87ae2ba916",
    "a3ad8587-a135-11e9-9cda-0a87ae2ba916",
    "a3a89488-a135-11e9-9cda-0a87ae2ba916",
    "a3b4497a-a135-11e9-9cda-0a87ae2ba916",
    "a3ad8072-a135-11e9-9cda-0a87ae2ba916",
    "a3a7b936-a135-11e9-9cda-0a87ae2ba916",
    "a3ad66e6-a135-11e9-9cda-0a87ae2ba916",
    "a3a98429-a135-11e9-9cda-0a87ae2ba916",
    "a3ad9ad9-a135-11e9-9cda-0a87ae2ba916",
    "a3a93622-a135-11e9-9cda-0a87ae2ba916",
    "1838613156025764214",
    "1963673207600511026",
    "1968516035938026380",
    "a3a7a4fc-a135-11e9-9cda-0a87ae2ba916",
    "a3ad8aa3-a135-11e9-9cda-0a87ae2ba916",
    "a3a88f84-a135-11e9-9cda-0a87ae2ba916",
    "a3ad6c01-a135-11e9-9cda-0a87ae2ba916",
    "a3ad711d-a135-11e9-9cda-0a87ae2ba916",
    "a3adaa52-a135-11e9-9cda-0a87ae2ba916",
    "a3ad7b51-a135-11e9-9cda-0a87ae2ba916",
    "1754781885939323186",
    "a3ad7636-a135-11e9-9cda-0a87ae2ba916",
    "a3ac30c5-a135-11e9-9cda-0a87ae2ba916",
    "1850868044363584392",
    "a3aae870-a135-11e9-9cda-0a87ae2ba916",
    "a3ada52f-a135-11e9-9cda-0a87ae2ba916",
    "a3acdae2-a135-11e9-9cda-0a87ae2ba916",
    "a3a547b8-a135-11e9-9cda-0a87ae2ba916",
    "a3a5a9d0-a135-11e9-9cda-0a87ae2ba916",
    "1850867138125484782",
    "a3ad95a7-a135-11e9-9cda-0a87ae2ba916",
    "a3ac0fff-a135-11e9-9cda-0a87ae2ba916",
    "a3ad61c2-a135-11e9-9cda-0a87ae2ba916",
    "a3ad8fd9-a135-11e9-9cda-0a87ae2ba916"
    ]

def get_num_bikes():
    res = requests.get(STATION_STATUS)
    jsonres = res.json()

    station_json = json.dumps(jsonres['data']['stations'])
    station_status_df = pd.read_json(station_json)

    cleaned_stationdata = station_status_df[['station_id','num_bikes_available']]

    filtered_df = cleaned_stationdata[cleaned_stationdata['station_id'].isin(id_list)]

    filtered_json = filtered_df.to_json(orient='records')

    print(filtered_json)


def run_periodically():
    while True:
        get_num_bikes()
        time.sleep(180)  # Sleep for 180 seconds (3 minutes)

if __name__ == "__main__":
    # Create a thread for periodic execution
    thread = threading.Thread(target=run_periodically)
    # Set the thread as daemon so it will be killed when the main program exits
    thread.daemon = True
    # Start the thread
    thread.start()

    # Keep the main thread alive (optional, if you want to do other things)
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Program terminated.")
# filtered_df.to_csv('station.csv')