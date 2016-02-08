#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: find.pl
#
#        USAGE: ./find.pl  
#
#  DESCRIPTION: find addresses
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED:  5.11.2015 г. 14:04:15 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.20;

use File::Find;
use File::Slurp qw/read_file/;

my $comp = {};
my $formatre = qr/CUS(\d+)\s+(.{35})(.{35})\s.*?(\d+)\s+(.*?)\s+BG(\d+)/;

sub process {
    ! -f and return;
    /txt/ or return;

    my @data = read_file $_;

    foreach (@data) {
        chomp;
        /$formatre/ or next;
        # iterate over lines of interest
        # say;
        my $bid = $1;
        $comp->{$1} = { 
            name => $2,
            addr => $3,
            pcod => $4,
            city => $5, 
            vat => $6
        };

        $comp->{$bid}->{name} =~ s/^\s+(\S+.*\S+)\s+$/$1/;
        $comp->{$bid}->{addr} =~ s/^\s+(\S+.*\S+)\s+$/$1/;
    }
}

find({ wanted => \&process, follow => 1 }, '.');

say join ",\n", map {
    join '', (
        "[",
        join ( ',', map { qq{"$_"} } $_, @{$comp->{$_}}{qw/name addr pcod city vat/} ), 
        "]"
    )
} sort { $a <=> $b } keys $comp;

