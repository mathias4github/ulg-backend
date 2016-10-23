# ulg-backend

Usage:

Usage: get_data_from_pch.sh <type> <collector_type> <day> <month> <year>

type could be raw or snapshot
raw - raw routing data
snapshot - routing data snapshot



Example with real data:

./get_data_from_pch.sh snapshot fra 22 10 2016

./get_data_from_pch.sh raw fra 22 10 2016


Goal: to read raw MRT data for a given data provider and to insert intoSQLITE DB.
    
./load2db.pl

Usage:
./load2db.pl -d directory

Where:

-d | --dir                - source directory for MRT files for some data
provider

Example with real data:

# /home/ubuntu/src/load2db.pl -d
"/home/ubuntu/src_data/www.pch.net/resources/Raw_Routing_Data/route-collector.ams.pch.net/2016/10/23/"

./pch-data.pl

Parses Daily Routing shnapshots and matches the next hop with the IXP subnets
Result: List with route collectors enriched with peeringDB data
