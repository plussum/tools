#!/usr/bin/perl
#
#
#
use strict;
use warnings;

my $fn = "/mnt/c/temp/text.txt";
for(@ARGV){
	if(/-of/){
		my $outf = "/mnt/c/temp/text-out.txt";
		open(STDOUT, '>', $outf) || die "cannot redirect STDOUT $outf";
	}
	else {
		$fn = $ARGV[0];
	}
}
open(FD, $fn) || die "cannot open $fn";
my @lines = ();
while(<FD>){
	s/[\n\r]+$//;
	if(/\. /){					# Try to cr at ".", but not to 1.2 xxxx 1.xxxx 
		my $ll = "";
		my @w = split(/\. /, $_);
		for(my $i = 0; $i <= $#w; $i++){
			my $l = $w[$i];
			#print"[$l]\n";
			if($l =~ /^\d[\d\.]*$/){
				$ll .= $l . " ";
				#print"<$ll>\n";
				next;
			}
			$l = $ll . $l;
			$l .= "." if($i < $#w);
			#print "($l)\n";
			push(@lines, $l);
			$ll = "";
		}
		push(@lines, $ll) if($ll);
		next;
	}
	push(@lines, $_);
	#print "[$_]\n";
#	s/^[0-9]+ //;
#	s/[.]{6,} [0-9ivx]+$//;
#	if(/[^a-zA-Z,]$/ || $#l < 0){
#		$_ .= "\n";
#	}
#	else {
#		$_ .= " ";
#	}
#	if(/^[ \t]*[]/){
#		s/$&/*/;
#		$_ = "\n" . $_;
#	}
#	elsif(/^[ \t]*[\-0-9]+/){
#		print "####### $_\n";
#		#s/$&/-/;
#		$_ = "\n" . $_;
#	}
}
close(FD);
#print "\n" x 2 ."-" x 20 . "\n";
#print "\n" x 2;

my $clipf = 0;
my @one_line = ();
open(CLIP, "| clip.exe") || die "Cannot open clip.exe";
for(my $l = 0; $l <= $#lines; $l++){
	my $ln = $lines[$l];
	if($ln =~ /^[-=]+$/){
		&flash();
	}
	elsif($ln =~ /^I+\.|^IV\.|^V\./){
		#print "I: $ln\n";
		&flash();
	}
	elsif($ln =~ /^\d+/){
		push(@one_line, "\n");
		&flash();
	}
	push(@one_line, $ln);
	#print "[$l] " . "[$ln]";
	if($ln =~ /[0-9a-zA-Z, ]$/){
		$ln =~ s/ $//;
		next;
	}
	&flash();
}
&flash();
#print join(" ", @one_line) . "\n";
#print "\n" x 2 ."-" x 20 . "\n";

close(STDOUT);
close(CLIP);
exit;

sub	flash
{
	print join(" ", @one_line) . "\n";
	print CLIP join(" ", @one_line) . "\n";
	@one_line = ();
}

