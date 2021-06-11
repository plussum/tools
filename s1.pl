#!/usr/bin/perl
#	copy all from Sentinel one console
#	Save it to /c/temp/SentinelOne.txt"
#	run ./s1.pl	(Automatically copy to cripboad)
#	Pasete to list
#
use strict;
use warnings;

my $author = "高橋";
my $fn = "/mnt/c/temp/SentinelOne.txt";
for(@ARGV){
	if(/-of/){
		my $outf = "/mnt/c/temp/s1-out.txt";
		open(STDOUT, '>', $outf) || die "cannot redirect STDOUT $outf";
	}
	else {
		$fn = $ARGV[0];
	}
}
open(FD, $fn) || die "cannot open $fn";
my @lines = ();
my $flag = 0;
while(<FD>){
	if(!$flag){
		next if(! /First seen/);
		$flag = 1;
	}
	s/[\n\r]+$//;
	my ($tag, $data) = split(/:/, $_);
	push(@lines, $_);
	#print "[$_]\n";
}
close(FD);
my $tag = "";
my $val = "";
my %TAGS = ();
for(my $i = 0; $i < $#lines; $i += 2){
	my $tag = $lines[$i];
	if($lines[$i] =~ /Real-time data about the endpoint:/){
		$val = $lines[$i+1]; # ."\t" . $lines[$i+2];
		$i++;
	}
	elsif($lines[$i] =~ /At detection time:/){
		$i--;
	}
	else {
		$val = $lines[$i+1];
	}
	print join("\t", $tag, $val) . "\n";
	$TAGS{$tag} = $val;
}
my @targets = ("First seen", "Classification", "THREAT FILE NAME", 
			"Real-time data about the endpoint:");
my @result = ();
foreach my $tag (@targets){
	push(@result, $TAGS{$tag});
}

open(CLIP, "| clip.exe") || die "clip.exe";
print CLIP join("\t", &ut2dt(time), "Resolved", $author, @result) . "\n";
close(CLIP);

sub ut2dt
{
    my ($tm, $dlm) = @_;

    $dlm = $dlm // ":";
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($tm);
    #my $s = sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
    my $s = sprintf("%04d/%02d/%02d", $year + 1900, $mon + 1, $mday);
    return $s;
}

