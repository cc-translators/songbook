#!/usr/bin/perl

use strict;
use warnings;


my %dict;

open SETTINGS, "gchords_settings.tex";

for my $line (<SETTINGS>) {

   chomp $line;
   
   if ( $line =~ m|\\newcommand\{\\(.*)\}\{\\chord\{.*\}\{.*\}\{(.*)\}\}| ) {

      my ($key, $value) = ($1, $2);
      $value =~ s|\\||g;
      $dict{$key} = $value;

   }

}

close SETTINGS;


foreach my $file (<songs_gchords/*.tex>) {

   open FILE, "$file";
   # changes $file to converted name
   $file =~ s|songs_gchords|songs|;
   open NEWFILE, ">$file";

   foreach my $line (<FILE>) {
      my @chords = $line =~ m|\Ch\D?\{\\([^\}]*)\}|g;
      my %valid_chords;

      foreach my $chord (@chords) {
         if ($dict{$chord}) {
            $valid_chords{$chord} = 1;
         } else {
            die "Could not find $chord in the settings. Please add it.".$/;
         }

      }

      foreach my $chord (keys %valid_chords) {
         $line =~ s|\{\\$chord\}|\{$dict{$chord}\}|g;
      }

      print NEWFILE $line;

   }

   close FILE;
   close NEWFILE;

}
