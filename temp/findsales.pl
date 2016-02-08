#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: findsales.pl
#
#        USAGE: ./findsales.pl  
#
#  DESCRIPTION: recover sales from reports
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 15.01.2016 г. 17:03:36 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.20;

use File::Find;
use File::Slurp qw/read_file/;

my $comp = {};
my $cusre = qr/^(CUS\d+).*(?:(BG\d+))/;
my $prsre = qr/^PRS(\d+)\s+(\w+)\s+(\d+)\s+BGL(\d*)/;
my @sls; 

sub process {
    my @cust; 
    my ($year, $month, $date);

    ! -f and return;
    /txt/ or return;

    /(20\d\d)(\d\d)(\d\d)/ and do { 
        ($year, $month, $date) = ($1, $2, $3);
    };

    my @data = read_file $_;

    foreach (@data) {
        chomp;

        if (/$prsre/) {
            push @sls, [$1, $2, $3, "$date.$month.$year", $4];
            $#sls % 128 or say "found...", $#sls;
        }
    }
}

my $srcdir = $ARGV[0] || '.';
find({ wanted => \&process, follow => 1 }, $srcdir);
say "found...", $#sls;

say "[",
    ( join ',',
        map { 
            sprintf '[ %d, "%s", %d, "%s", %d ]', @$_
        } @sls
    ),
    "]";

