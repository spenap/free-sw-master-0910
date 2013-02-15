#!/usr/bin/perl -w

use strict;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;

my $user=$ARGV[0];
$user="bulfaiter" unless defined($user);

my %artists;
my @neighbours = get_neighbours($user);
my %artists_rank;

foreach my $neighbour (@neighbours[0..4]) {

	my %entry = %{$neighbour};
	my @top_artists = get_top_artists($entry{name});
	
	store_artists(@top_artists[0..9]);
}

my @sorted_artists=sort order_by_count keys(%artists_rank);

foreach my $item (@sorted_artists) {
	
	print "$item: $artists_rank{$item}\n";
	
}

sub store_artists {
	
	my @to_store = @_;
	
	foreach my $artist (@to_store) {
		$artists_rank{$artist} ++;
	}
}

sub get_top_artists {
	
	my $the_user = shift;
	
	my $url="http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$the_user&api_key=b25b959554ed76058ac220b7b2e0a026";

	my $xml_response=XMLin(get($url)) or die "Unable to get XML response";

	%artists=%{$xml_response->{topartists}->{artist}};

	my @name_top_artists=sort order_by_playcount keys(%artists);
	
	return @name_top_artists;
}

sub get_neighbours {

	my $the_user = shift;

	my $url="http://ws.audioscrobbler.com/2.0/?method=user.getneighbours&user=$the_user&api_key=b25b959554ed76058ac220b7b2e0a026";
	
	my $response=get($url) or die "Bad response";
	
	my $xml_response=XMLin($response) or die "Bad XML response";

	my @neighbour_names = @{$xml_response->{neighbours}->{user}};
	
	# By shifting the list, we ignore the first item: the user.
	shift(@neighbour_names);
	
	return @neighbour_names;
}

sub order_by_playcount {

	my %entry_a = %{$artists{$a}};
	my %entry_b = %{$artists{$b}};
	
	$entry_b{playcount} <=> $entry_a{playcount};
}

sub order_by_count {

	$artists_rank{$b} <=> $artists_rank{$a};

}
