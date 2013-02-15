#!/usr/bin/perl -w

$date=`date +%d-%m-%Y`;
chomp($date);
$srcdir="/home/spenap/Dropbox/MSWL/";
$srcpath="/tmp/backups/";
$dstfile=$srcpath . "backup-" . $date . ".tar.gz";

unless ( -d $srcpath ) {
	system("mkdir", "-p", $srcpath);
}

system("tar", "-C", $srcdir,"-czf",$dstfile, ".");
print "Backup done!\n";
