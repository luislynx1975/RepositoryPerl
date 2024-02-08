#!/usr/bin/perl -w
require DBI;

my @drivers = DBI->available_drivers;
print join(", ", @drivers), "\n";


my $d = join(",", @drivers);
print "DBD::ODBC";
print "not" if ($d !~ /ODBC/);
print "installed\n";
