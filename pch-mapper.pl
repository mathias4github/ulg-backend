#!/usr/bin/perl
use NetAddr::IP;
use Data::Dumper;

my %list;
open my $fh, '<', 'exchangelist.csv' or die "Cannot open: $!";
while (my $line = <$fh>) {
  $line =~ s/\s*\z//;
  my @array = split /\t/, $line;
  my $key = shift @array;
  $list{$key} = \@array;
}
close $fh;

#print Dumper(%list);

open (RH, "> ausgabe.csv") or die "Cannot open ausgabe";
print ("rc_short,rc_long,prefix,name,city,country,region_continent,website,link\n");
print RH ("rc_short,rc_long,prefix,name,city,country,region_continent,website,link\n");

@files = <*>;
foreach $file (@files) {
	next unless $file =~ /^route-collector/;
	open (FH, $file) or die("Cannot open $file\n");
	my %final;
	my %hash;
	while (<FH>) {
	  if ($_ =~ /^.{15}.* (\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})  /) {
	  	next if $_ =~ /0 42 i/;
	  	$network = "$1.$2.$3.$4";
	  	$hash{$network} = "1";
	  }
	}

	@uniq_nets = keys %hash;
	#print join ("\n", sort @uniq_nets);

	my @nets;
	foreach (sort @uniq_nets) {
		my $search_IP = NetAddr::IP->new($_);
		foreach (keys %list) {
			my $network = NetAddr::IP->new($_);
			if ($search_IP->within($network)) {
				$final{$network->cidr()} = 1;
			}
		}
	}
	foreach (keys %final){
		
        	$file =~ /^(.*\.)(.*)(\.pch.net)/;
		print ($2.",$1$2$3, ". $_ .", ". join(",", @{$list{$_}})."\n");
		print RH ($2.",$1$2$3, ". $_ .", ". join(",", @{$list{$_}})."\n");
	}
	#print join("\n ", keys %final), "\n";
}
close (RH);
