package Bulk::ConversionTable::VendoridConversionTable;

use Modern::Perl;

BEGIN {
    use FindBin;
    eval { use lib "$FindBin::Bin/../"; };
}

use Bulk::ConversionTable;
our @ISA = qw(Bulk::ConversionTable);

use Carp qw(cluck);

sub readRow {
    my ($self, $textRow) = @_;

    if ( $_ =~ /^(\d+) (\d+)$/ ) {
        my $oldVendorId   = $1; #Old value
        my $newVendorId   = $2; #new Koha itemnumber

        $self->{table}->{$oldVendorId} = $newVendorId;
    } else {
        print "ConversionTable::VendoridConversionTable->readRow(): Couldn't parse vendor id row: $_\n";
    }
}
sub writeRow {
    my ($self, $vendorId, $newVendorId) = @_;

    $vendorId = '' unless $vendorId;
    $newVendorId = '' unless $newVendorId;

    my $fh = $self->{FILE};
    print $fh "$vendorId $newVendorId\n";
}

1;
