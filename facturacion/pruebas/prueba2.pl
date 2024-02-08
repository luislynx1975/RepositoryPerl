#!/usr/bin/perl -w
use strict;
use DBI;			# Module connection for ODBC

# Set up variables for the connection
my $server_name = "Nomin";
my $server_ip = "192.168.1.2:1443";
my $database_name = "Smart Response System";
my $database_user = "cs59173";
my $database_pass = "5055";

my $DSN = "driver={SQL Server};server=$server_name;tcpip=$server_ip;database=$database_name;uid=$database_user;pwd=$database_pass"; 
my $DBH = DBI->connect("DBI:ODBC:$DSN") or die "Couldn't open database: $DBI::errstr\n";
