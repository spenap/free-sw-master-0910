#!/usr/bin/perl -w

use strict;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;

my $user=$ARGV[0];
$user="bulfaiter" unless defined($user);

my $url="http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$user&api_key=b25b959554ed76058ac220b7b2e0a026";

my $response=get($url) or die "Bad response";

my @response_lines=split('\n',$response);

my $line;
my $artist_count = 0;

for (my $i = 0; $i <= $#response_lines && $artist_count < 10; $i ++) {
    if ($response_lines[$i] =~ s/<name>(.*)</name)/) {
		print "$1\n";
		$artist_count ++;
	}
}
