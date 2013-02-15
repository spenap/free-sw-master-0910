#!/usr/bin/perl -w

use strict;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;

my $user=$ARGV[0];
$user="bulfaiter" unless defined($user);

my $url="http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$user&api_key=b25b959554ed76058ac220b7b2e0a026";

my $response = get($url) or die "Bad response";
my $xml_response=XMLin($response) or die "Bad XML response";

my %artists=%{$xml_response->{topartists}->{artist}};

my @name_top_artists=sort order_by_playcount keys(%artists);

for (my $i=0; $i < 10; $i ++) {
	print "$name_top_artists[$i]\n";
}

sub order_by_playcount {

	my %entry_a = %{$artists{$a}};
	my %entry_b = %{$artists{$b}};
	
	$entry_b{playcount} <=> $entry_a{playcount};
}
