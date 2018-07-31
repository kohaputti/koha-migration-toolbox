use Modern::Perl '2016';

package MMT::Koha::Fine;
#Pragmas
use Carp::Always::Color;
use experimental 'smartmatch', 'signatures';
use English;

#External modules

#Local modules
use MMT::Config;
use Log::Log4perl;
my $log = Log::Log4perl->get_logger(__PACKAGE__);
use MMT::Date;
use MMT::Validator;

#Inheritance
use MMT::KohaObject;
use base qw(MMT::KohaObject);

#Exceptions
use MMT::Exception::Delete;

=head1 NAME

MMT::Koha::Fine - Transforms a bunch of Voyager data into Koha accountlines

=cut

=head2 build

 @param1 Voyager data object
 @param2 Builder

=cut

sub build($self, $o, $b) {
  #$self->setAccountlines_id    ($o, $b);
  $self->setKeys                ($o, $b);
  #  \$self->setIssue_id         ($o, $b);
  #   \$self->setBorrowernumber   ($o, $b);
  #    \$self->setItemnumber       ($o, $b);
  #$self->setAccountno          ($o, $b); #Internally generated by C4::Accounts::getnextacctno
  $self->setDate                ($o, $b);
  $self->setAmount              ($o, $b);
  $self->setAmountoutstanding   ($o, $b);
  $self->setDescription         ($o, $b);
  #$self->setDispute            ($o, $b);
  $self->setAccounttype         ($o, $b);
  #$self->setLastincrement      ($o, $b);
  #$self->setTimestamp          ($o, $b); #Populated ON UPDATE
  #$self->setNotify_id          ($o, $b); #Koha generates it from accounttype in C4::Accounts::manualinvoice
  #$self->setNotify_level       ($o, $b);
  #$self->setNote               ($o, $b);
  #$self->setManager_id         ($o, $b);
}

sub id {
  return ($_[0]->{borrowernumber}.'-'.($_[0]->{itemnumber} || 'NULL'));
}

sub logId($s) {
  return 'Fine: '.$s->id();
}

sub setKeys($s, $o, $b) {
  unless ($o->{patron_id}) {
    MMT::Exception::Delete->throw("Fine is missing patron_id ".MMT::Validator::dumpObject($o));
  }
  $s->{borrowernumber} = $o->{patron_id};
  unless ($o->{item_id}) {
    MMT::Exception::Delete->throw("Fine is missing item_id ".MMT::Validator::dumpObject($o));
  }
  $s->{itemnumber} = $o->{item_id};
}
sub setDate($s, $o, $b) {
  $s->{date} = $o->{create_date};

  unless ($s->{date}) {
    $log->warn($s->logId()." has no create_date|date.");
  }
}
sub setAmount($s, $o, $b) {
  unless ($o->{fine_fee_amount}) {
    $log->warn($s->logId()." is missing fine_fee_amount");
  }
  $s->{amount} = $o->{fine_fee_amount};
}
sub setAmountoutstanding($s, $o, $b) {
  unless ($o->{fine_fee_balance}) {
    $log->warn($s->logId()." is missing fine_fee_balance");
  }
  $s->{amountoutstanding} = $o->{fine_fee_balance};
}
sub setDescription($s, $o, $b) {
  $s->sourceKeyExists($o, 'fine_fee_note');
  $s->sourceKeyExists($o, 'item_barcode');
  $s->{description} = $o->{fine_fee_note};

  if ($o->{item_barcode}) {
    $s->{description} = '' unless $s->{description};
    $s->{description} .= " | Item='".$o->{item_barcode}."'";
  }
}
sub setAccounttype($s, $o, $b) {
  $s->sourceKeyExists($o, 'fine_fee_type');
  $s->{accounttype} = $b->{FineTypes}->translate(@_, $o->{fine_fee_type});

  unless ($s->{accounttype}) {
    MMT::Exception::Delete->throw($s->logId()."' has no accounttype! fine_fee_type=".$o->{fine_fee_type}.". Define a default in the Branchcodes translation table!");
  }
}


return 1;
