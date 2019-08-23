#!/usr/bin/perl

use Modern::Perl '2015';
use experimental 'smartmatch', 'signatures';
$|=1;
binmode(STDOUT, ":encoding(UTF-8)");
binmode(STDIN, ":encoding(UTF-8)");

use Data::Printer;
use Getopt::Long;
use Log::Log4perl qw(:easy);

use C4::Context;

my ($vendorFile);

our $verbosity = 3;

GetOptions(
    'vendorFile:s'       => \$vendorFile,
    'v|verbosity:i'            => \$verbosity,
);

my $help = <<HELP;

NAME
  $0 - Import Vendors en masse

SYNOPSIS
  perl bulkVendorImport.pl --vendorFile /home/koha/pielinen/vendors.migrateme


DESCRIPTION

    --vendorFile filepath
          The perl-serialized HASH of Vendors.

    -v level
          Verbose output to the STDOUT,
          Defaults to $verbosity, 6 is max verbosity, 0 is fatal only.

HELP

require Bulk::Util; #Init logging && verbosity

unless ($vendorFile) {
    die "$help\n\n--vendorFile is mandatory";
}

my $dbh = C4::Context->dbh();
my $vendor_insert_sth = $dbh->prepare("INSERT INTO aqbooksellers
                                    (id, name, currency, accountnumber, active, listprice, invoiceprice)
                                    VALUES (?,?,?,?,?,?,?)");

sub migrate_vendor($s) {
    $vendor_insert_sth->execute($s->{id}, $s->{name}, $s->{currency}, $s->{accountnumber}, 1, $s->{currency}, $s->{currency}) or die "INSERT:ing Vendor failed: ".$vendor_insert_sth->errstr();

    my $newBookSellerId = $dbh->last_insert_id(undef, undef, 'aqbooksellers', 'id') or die("Fetching last insert if failed: ".$dbh->errstr());
}


my $fh = Bulk::Util::openFile($vendorFile);
my $i = 0;
while (<$fh>) {
    $i++;
    INFO "Processed $i Vendors" if ($i % 100 == 0);

    my $vendor = Bulk::Util::newFromBlessedMigratemeRow($_);
    migrate_vendor($vendor);
}
$fh->close();
