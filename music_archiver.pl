#!/usr/bin/env perl

use strict;
use warnings;

print "\n[ -- Auto Music Archiver -- ]\n";

print "\n[>] Enter full YouTube playlist link: ";
chomp(my $plist = <STDIN>);

print "[>] Enter album name: ";
chomp(my $album = <STDIN>);

print "[>] Enter artist name: ";
chomp(my $artist = <STDIN>);

$album = lc $album;
$artist = lc $artist;

$album =~ s/ /_/g;
$artist =~ s/ /_/g;

if (-d "/home/alex/Music/$artist"){
	print "\n[~] Looks like a directory exists for $artist.\n";
	chdir "/home/alex/Music/$artist";
	
	print "[+] Creating new album directory at '/home/alex/Music/$artist/$album'\n";
	mkdir $album;
} else {
	print "\n[+] Creating new artist and album directories at '/home/alex/Music/$artist/$album'\n";
	mkdir "/home/alex/Music/$artist";
	mkdir "/home/alex/Music/$artist/$album";

}

chdir "/home/alex/Music/$artist/$album";

print "\n[+] Sending link to youtube-dl...\n\n";
system("youtube-dl -f bestaudio -o \"%(playlist_index)d - %(title)s.%(ext)s\" \"$plist\"");

print "\n[+] Converting .webm's to .m4a's...";

my @files = <"/home/alex/Music/$artist/$album/*.webm">;
for my $file(@files){
        my $oldfile = $file;
        $file =~ s/\.webm/\.m4a/g;
        print "\n\t[+] Converting ".(split /\//, $oldfile)[-1]." [==>] ".(split /\//, $file)[-1]."\n";
        system "ffmpeg -hide_banner -loglevel quiet -stats -i \"$oldfile\" -vn \"$file\"";
        system "rm \"$oldfile\"";
}

print "\n[+] Done. Please check '/home/alex/Music/$artist/$album'";
print "\n[+] Have a nice day.\n";
