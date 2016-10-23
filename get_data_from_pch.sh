#!/bin/sh

RAW="https://www.pch.net/resources/Raw_Routing_Data"
SNAPSHOT="https://www.pch.net/resources/Routing_Data/IPv4_daily_snapshots"
OUTPUT=/home/ubuntu/src_data
#f [ "$1" == "-h" ] || [ "$#" == 0 ]; then
if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
  echo "Usage: `basename $0` <type> <collector_type> <day> <month> <year>\n"
  echo "type could be raw or snapshot"
  echo "raw - raw routing data"
  echo "snapshot - routing data snapshot\n"
  exit 0
fi
echo $1
# ARG1 is type of data
# ARG2 is type of collector
# ARG3 is day
# ARG4 is month
# ARG5 is year
case $1 in
   raw ) 
	wget -r -l1 -k -P $OUTPUT -np $RAW/route-collector.$2.pch.net/$5/$4/$3/
	exit 0
   ;;
   snapshot )
 	wget -r -l2 --spider --no-parent -nd -np -A "*$5.$4.$3.gz" $SNAPSHOT/$5/$4/ 2>&1 | grep https | grep route-collector | awk '{print $3}' | xargs wget -P $OUTPUT/www.pch.net/resources/Routing_Data/ -r -nd -np -k
   ;;
esac

