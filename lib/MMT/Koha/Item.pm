use 5.22.1;

package MMT::Koha::Item;
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

MMT::Koha::Item - Transforms a bunch of Voyager data into a Koha item

=cut

=head2 build
 @param1 Voyager data object
 @param2 Builder
=cut
sub build($self, $o, $b) {
  $self->setItemnumber           ($o, $b);
  $self->setBiblionumber         ($o, $b);
  $self->setBarcode              ($o, $b);
  $self->setDateaccessioned      ($o, $b);
  #$self->setDatereceived        ($o, $b);
  #$self->setBooksellerid        ($o, $b);
  $self->setHomebranch           ($o, $b);
  $self->setPrice                ($o, $b);
  #$self->setReplacementprice    ($o, $b);
  #$self->setReplacementpricedate($o, $b);
  $self->setDatelastborrowed     ($o, $b);
  #$self->setDatelastseen        ($o, $b);
  #$self->setStack               ($o, $b);
  $self->setStatuses             ($o, $b);
  #  \$self->setNotforloan        ($o, $b);
  #   \$self->setDamaged           ($o, $b);
  #    \$self->setItemlost          ($o, $b);
  #     \$self->setItemlost_on       ($o, $b);
  #      \$self->setWithdrawn         ($o, $b);
  #       \$self->setWithdrawn_on      ($o, $b);
  $self->setItemcallnumber       ($o, $b);
  #$self->setCoded_location_qualifier($o, $b);
  $self->setIssues               ($o, $b);
  #$self->setRenewals            ($o, $b);
  #$self->setReserves            ($o, $b);
  #$self->setRestricted          ($o, $b);
  $self->setItemnotes            ($o, $b);
  #  \$self->setItemnotes_nonpublic($o, $b);
  $self->setHoldingbranch        ($o, $b);
  #$self->setPaidfor($o, $b);
  #$self->setTimestamp($o, $b);
  $self->setPermanent_location   ($o, $b);
  $self->setLocation             ($o, $b);
  #$self->setOnloan($o, $b);
  #$self->setCn_source($o, $b);
  #$self->setCn_sort($o, $b);
  #$self->setMaterials($o, $b);
  #$self->setUri($o, $b);
  $self->setItype                ($o, $b);
  #$self->setMore_subfields_xml($o, $b);
  $self->setEnumchron            ($o, $b);
  #$self->setCopynumber($o, $b);
  #$self->setStocknumber($o, $b);
  #$self->setNew_status($o, $b);
  #$self->setGenre($o, $b);
  #$self->setSub_location($o, $b);
  #$self->setCirculation_level($o, $b);
  #$self->setReserve_level($o, $b);
  $self->setCcode                ($o, $b);
}

sub id {
  return ($_[0]->{barcode} || $_[0]->{itemnumber} || 'NULL');
}

sub logId($s) {
  return 'Item: '.$s->id();
}

sub setItemnumber($s, $o, $b) {
  unless ($o->{item_id}) {
    MMT::Exception::Delete->throw("Item is missing item_id ".MMT::Validator::dumpObject($o));
  }
  $s->{itemnumber} = $o->{item_id};
}
sub setBiblionumber($s, $o, $b) {
  unless ($o->{bib_id}) {
    MMT::Exception::Delete->throw("Item is missing bib_id ".MMT::Validator::dumpObject($o));
  }
  $s->{biblionumber} = $o->{bib_id};
}
sub setBarcode($s, $o, $b) {
  $s->{barcode} = $o->{barcode};

  unless ($s->{barcode}) {
    $log->warn($s->logId()."' has no barcode.");
    $s->{barcode} = $s->createTemporaryBarcode();
  }
}
sub setDateaccessioned($s, $o, $b) {
  $s->{dateaccessioned} = $o->{add_date};

  unless ($s->{dateaccessioned}) {
    $log->warn($s->logId()."' has no dateaccessioned.");
  }
}
sub setPrice($s, $o, $b) {
  $s->sourceKeyExists($o, 'price');
  $s->{price} = (defined($o->{price})) ? $o->{price}/100 : undef;

  #$log->warn($s->logId()."' has no price.") unless $s->{price}; #Too much complaining about the missing price. Hides all other issues.
}
sub setDatelastborrowed($s, $o, $b) {
  $s->sourceKeyExists($o, 'last_borrow_date');
  $s->{datelastborrowed} = $o->{last_borrow_date};
  #It is ok for the Item to not have datelastborrowed
}
sub setItemcallnumber($s, $o, $b) {
  $s->{itemcallnumber} = $o->{call_no};

  unless ($s->{itemcallnumber}) {
    $log->warn($s->logId()." has no itemcallnumber! call_no=".$o->{call_no});
  }
}
sub setIssues($s, $o, $b) {
  $s->sourceKeyExists($o, 'historical_charges');
  $s->{issues} = $o->{historical_charges} || 0;
}
sub setItemnotes($s, $o, $b) {
  my $itemNotes = $b->{ItemNotes}->get($o->{item_id});
  #Translation table mutates $s directly
  if ($itemNotes) {
    $b->{ItemNoteTypes}->translate(@_, $_->{item_note_type}, $_) for (@$itemNotes);
  }
}
sub setHomebranch($s, $o, $b) {
  my $branchcodeLocation = $b->{LocationId}->translate(@_, $o->{perm_location});
  $s->{homebranch} = $branchcodeLocation->{branch};
  $s->{ccode} = $branchcodeLocation->{collectionCode} if $branchcodeLocation->{collectionCode};

  unless ($s->{homebranch}) {
    MMT::Exception::Delete->throw($s->logId()."' has no homebranch! perm_location=".$o->{perm_location}.". Define a default in the Branchcodes translation table!");
  }
}
sub setHoldingbranch($s, $o, $b) {
  if ($o->{temp_location}) {
    my $branchcodeLocation = $b->{LocationId}->translate(@_, $o->{temp_location});
    $s->{holdingbranch} = $branchcodeLocation->{branch};
    $s->{ccode} = $branchcodeLocation->{collectionCode} if $branchcodeLocation->{collectionCode};
  }
  else {
    $s->{holdingbranch} = $s->{homebranch};
  }
}
sub setPermanent_location($s, $o, $b) {
  my $branchcodeLocation = $b->{LocationId}->translate(@_, $o->{perm_location});
  $s->{permanent_location} = $branchcodeLocation->{location};
  $s->{ccode} = $branchcodeLocation->{collectionCode} if $branchcodeLocation->{collectionCode};

  unless ($s->{permanent_location}) {
    MMT::Exception::Delete->throw($s->logId()."' has no permanent_location! perm_location=".$o->{perm_location});
  }
}
sub setLocation($s, $o, $b) {
  if ($o->{temp_location}) {
    my $branchcodeLocation = $b->{LocationId}->translate(@_, $o->{temp_location});
    $s->{location} = $branchcodeLocation->{location};
    $s->{ccode} = $branchcodeLocation->{collectionCode} if $branchcodeLocation->{collectionCode};
  }
  else {
    $s->{location} = $s->{permanent_location};
  }
}
sub setItype($s, $o, $b) {
  $s->{itype} = $b->{ItemTypes}->translate(@_, $o->{item_type_id});

  unless ($s->{itype}) {
    MMT::Exception::Delete->throw($s->logId()."' has no itype! item_type_id=".$o->{item_type_id});
  }
}
sub setEnumchron($s, $o, $b) {
  if ($o->{enumeration} && $o->{chronology}) {
    $s->{enumchron} = $o->{enumeration}.' - '.$o->{chronology};
  }
  elsif ($o->{enumeration}) {
    $s->{enumchron} = $o->{enumeration};
  }
  elsif ($o->{chronology}) {
    $s->{enumchron} = $o->{chronology};
  }
}
sub setCcode($s, $o, $b) {
  my $itemStatisticalCategories = $b->{ItemStats}->get($o->{item_id});
  return unless $itemStatisticalCategories;

  if (scalar(@$itemStatisticalCategories) > 1) {
    $log->warn($s->logId()." has '".scalar(@$itemStatisticalCategories)."' statistical categories, but in Koha we can only put one collection code. Using the newest value.");
  }

  my $statCat = $itemStatisticalCategories->[-1]->{item_stat_code}; #Pick the last (should be sorted so it is the newest) stat cat.
  unless ($statCat) {
    $log->warn($s->logId()." has a statistical category with no attribute 'item_stat_code'?");
    return;
  }
  if ($s->{ccode}) {
    $log->warn($s->logId()." has collection code '".$s->{ccode}."' and an incoming statistical category '$statCat', but in Koha we can only have one collection code.");
    return;
  }
}




sub setStatuses($s, $o, $b) {
  my $itemStatuses = $b->{ItemStatuses}->get($o->{item_id});
  return unless $itemStatuses;

  for my $affliction (@$itemStatuses) {
    my $desc = $affliction->{item_status_desc};
    $log->trace($s->logId().' has affliction "'.$desc.'"');

    if   ($desc eq 'At Bindery' ||
          $desc eq 'Cataloging Review' ||
          $desc eq 'Circulation Review' ||
          $desc eq 'Claims Returned' ||
          $desc eq 'In Process') {
      $s->{notforloan} = 1;
    }
    elsif($desc eq 'Call Slip Request' ||
          $desc eq 'Charged' ||
          $desc eq 'Hold Request' ||
          $desc eq 'In Transit' ||
          $desc eq 'In Transit Discharged' ||
          $desc eq 'In Transit On Hold' ||
          $desc eq 'On Hold' ||
          $desc eq 'Overdue' ||
          $desc eq 'Recall Request' ||
          $desc eq 'Renewed' ||
          $desc eq 'Short Loan Request' ||
          $desc eq "Not Charged") {
      # Nothing we can do about that
    }
    elsif ($desc eq 'Damaged') {
      $s->{damaged} = 1;
    }
    elsif ($desc eq 'Lost--Library Applied') {
      $s->{itemlost} = 1;
      # $itemlost_on = DATE...
    }
    elsif ($desc eq 'Lost--System Applied') {
      $s->{itemlost} = 2; # long overdue
    }
    elsif ($desc eq "Missing") {
      $s->{itemlost} = 1;
      # $itemlost_on = DATE...
    }
    elsif ($desc eq "Withdrawn") {
      $s->{withdrawn} = 1;
      # $withdrawn_on = DATE
    }
    else {
      $log->error("Unhandled status '$desc'");
    }
  }
}

return 1;
