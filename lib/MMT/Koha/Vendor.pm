package MMT::Koha::Vendor;

use MMT::Pragmas;

#Local modules
my $log = Log::Log4perl->get_logger(__PACKAGE__);

#Inheritance
use MMT::KohaObject;
use base qw(MMT::KohaObject);

=head1 NAME

MMT::Koha::Vendor - Transforms a bunch of Voyager data into Koha vendors

=cut

=head2 build

 @param1 Voyager data object
 @param2 Builder

=cut

sub build($self, $o, $b) {
  $self->setKeys($o, $b, [['vendor_id' => 'id']]);
  $self->set(default_currency => 'currency', $o, $b);
  $self->set(vendor_name => 'name', $o, $b);
  $self->setAccountnumber($o, $b);
  $self->setNotes($o, $b);
  $self->setAddresses($o, $b);

}

sub id {
  return 'v:'.($_[0]->{id} || 'NULL');
}

sub logId($s) {
  return 'Vendor: '.$s->id();
}

sub setCurrency($s, $o, $b) {
    $s->{currency} = $o->{default_currency} || 'EUR';
}

sub setName($s, $o, $b) {
    $s->{name} = $o->{vendor_name} || undef;
}

sub setAccountnumber($s, $o, $b) {
    if ($b->{accounts}->get($o->{vendor_id})) {
        my $accountNumber = $b->{accounts}->get($o->{vendor_id})->[0]->{account_number};
        my $accountName = $b->{accounts}->get($o->{vendor_id})->[0]->{account_name};
        $s->{accountnumber} = "$accountNumber ($accountName)";
    }
}

sub setNotes($s, $o, $b) {
    my $original_notes = $b->{notes}->get($o->{vendor_id});
    my $final_notes;
    foreach my $note (@$original_notes) {
	$final_notes .= "$note->{note}\n\n";
    }

    $s->{notes} = $final_notes;
}

sub setAddresses($s, $o, $b) {
    my $original_addresses = $b->{addresses}->get($o->{vendor_id});
    my @phones;
    my @faxes;
    foreach my $address (@$original_addresses) {
	$s->{address1} = "$address->{address_line1}, $address->{address_line2}, $address->{address_line3}, $address->{address_line4}, $address->{address_line5}";
	$s->{address1} = "$address->{zip_postal} $address->{city}";

        my $original_phones = $b->{phones}->get($address->{address_id});
        foreach my $phone (@$original_phones) {
	    push @phones, $phone->{phone_number};
	}
    }

    $s->{phones} = join ' TAI ', @phones;

}


return 1;
