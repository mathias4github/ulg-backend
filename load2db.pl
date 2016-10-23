#!/usr/bin/perl
use Time::Local;
use Getopt::Long;
my $outdir="/home/ubuntu/database";
my $provider="PCH";
my $srcdir="";
#my $srcdir="/home/ubuntu/src_data/www.pch.net/resources/Raw_Routing_Data/route-collector.ams.pch.net/2016/10/23";

GetOptions (
                                                        'd|dir=s' => \$srcdir



);

if ($srcdir eq '') {
    print <<"EOF";

Usage:
$0 -d directory

Where:

-d | --dir                - source directory for MRT files for some data provider

EOF
;
        exit 0;
} elsif (not -d $srcdir) {
  print "Error with local path for src dir '$srcdir'\n";
  exit 0;
};

@filelist=glob($srcdir."/*");
foreach $item (@filelist) {
        next if ($item =~ /^\./);
        print "$item\n";
	if ($item =~ /(route-collector\.(\w+)\.pch.net-mrt-bgp-updates-(\d{4})-(\d{1,2})-(\d{1,2})-(\d{1,2})-(\d{1,2}).gz)/) {
		$file=$1; $collector=$2; 
 		$year=$3; $month=$4-1; $day=$5; $hour=$6; $min=$7; $sec=0;    
#	print "$file $collector $year $month $day $hour $min $sec\n";
		$timegm=timegm($sec,$min,$hour,$day,$month,$year);
        	print "$file $timegm\n";
		`python2 /home/ubuntu/src/bgpstream_sqlite_mgmt.py -M $srcdir/$file $outdir/route-collector.$collector.pch.net.sqlite -p $provider -c $collector -t updates -T $timegm -u 60`;
 	};
};
