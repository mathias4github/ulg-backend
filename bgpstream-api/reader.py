from _pybgpstream import BGPStream, BGPRecord, BGPElem
from datetime import time, timedelta
import time
import json

# create a new bgpstream instance
stream = BGPStream()

# select the data source
basepath = "/home/ubuntu/database/"
collector= "route-collector.fra.pch.net"

# DEBUG print(stream.get_data_interfaces())

# on the CLI it works this way $ bgpreader -d sqlite -o db-file,ULG.sqlite -w 1477000000,1777360000
stream.set_data_interface("sqlite")
# FIXME Use the collector name
stream.set_data_interface_option('sqlite', 'db-file', basepath + collector +'.sqlite')

# create a reusable bgprecord instance
rec = BGPRecord()

# configure the stream to retrieve Updates records from the RRC06 collector
#stream.add_filter('collector', 'rrc06')
#stream.add_filter('record-type', 'updates')

# select the time interval to process:
# default to 24h from now
now = int(time.time())
stream.add_interval_filter(now-(3*24*60*60), now)

# start the stream
stream.start()
# DEBUG print("opening stream")

results = {}

while(stream.get_next_record(rec)):
    elem = rec.get_next_elem()
    while(elem):
        print(elem.fields['prefix'])
	# Get the peer ASn
        peer = str(elem.peer_asn)
        # Get the neighbor ID
        address = str(elem.peer_address)
        #
        result[elem.peer_address] = (elem.peer_asn, set()) # create with an empty prefix set
        if elem.type in ['announcement', 'rib']:
            nexthop = elem.fields['next-hop']
            aspath = elem.fields['as-path']
            prefix = elem.fields['prefix']

            result[elem.peer_address][1].add(prefix)
        elif elem.type == 'withdrawal':
            result[elem.peer_address][1].remove(prefix)

print(json.dumps(results))
