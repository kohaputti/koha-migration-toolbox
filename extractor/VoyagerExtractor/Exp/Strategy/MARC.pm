# This file is part of koha-migration-toolbox
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with koha-migration-toolbox; if not, see <http://www.gnu.org/licenses>.
#

package Exp::Strategy::MARC;

#Pragmas
use warnings;
use strict;

#External modules
use Carp;
use MARC::File::MARCXML;
use Encode;

#Local modules
use Exp::nvolk_marc21;

=head2 NAME

Exp::Strategy::MARC

=head2 DESCRIPTION

Export Bibliographic, Authorities and MFHD MARC records as raw ISO

=cut

use Exp::Config;
use Exp::DB;
use Exp::Encoding;

sub exportBiblios($) {
  _exportMARC(Exp::Config::exportPath('biblios.marcxml'),
              'select * from BIB_DATA order by BIB_ID, SEQNUM');
}

sub exportAuth() {
  _exportMARC(Exp::Config::exportPath('authorities.marcxml'),
              'select * from AUTH_DATA order by AUTH_ID, SEQNUM');
}

sub exportMFHD() {
  _exportMARC(Exp::Config::exportPath('holdings.marcxml'),
              'select * from MFHD_DATA order by MFHD_ID, SEQNUM');
}

=head2 _exportMARC

Implements the export logic.
Can be hooked with a subroutine to do transformations before writing to disk.

 @param1 String, filepath where to write the data
 @param2 String, SQL statement to extract data with
 @param3 Subroutine, OPTIONAL, Executed after the MARC as ISO has been concatenated. Is used to write the data to disk.

=cut

sub _exportMARC($$$) {
  my ($outFilePath, $sql, $outputHook) = @_;

  open(my $FH, '>:raw', $outFilePath) or confess("Opening file '$outFilePath' failed: ".$!);

  my $dbh = Exp::DB::dbh();
  my $sth = $dbh->prepare($sql) || confess($dbh->errstr);
  $sth->execute() || confess($dbh->errstr);


  my @row;
  my $record = '';
  my $prev_id = 0;
  while ( ((@row) = $sth->fetchrow_array) ) {
    if ( $row[1] == 1 ) {
      ($outputHook) ? $outputHook->($FH, $prev_id, \$record) : _output_record($FH, $prev_id, \$record);
      $record = $row[2];
    }
    else {
      $record .= $row[2];
    }
    $prev_id = $row[0];
  }
  $sth->finish();
  ($outputHook) ? $outputHook->($FH, $prev_id, \$record) : _output_record($FH, $prev_id, \$record);
  close($FH);
}

sub _output_record($$$) {
  my ( $FH, $id, $record_ptr ) = @_;

  if ( length($$record_ptr) ) {
    if ( !Exp::Encoding::isUtf8($$record_ptr) ) {
      print STDERR "$id\tWarning\tRecord contains non-UTF-8 characters\n";
      $$record_ptr = Exp::Encoding::toUtf8($$record_ptr);
    }
    $$record_ptr = Exp::nvolk_marc21::nvolk_marc212oai_marc($$record_ptr);

    $$record_ptr = _convert_component_record_linking_to_koha($$record_ptr);

    print $FH $$record_ptr, "\n";
  }
}

sub _convert_component_record_linking_to_koha($) {
  my $record = shift();

  return $record unless ($record =~ m/tag="773"/);

  my $record_object = MARC::File::MARCXML->decode($record);
  my @link_fields = $record_object->field('773');

  foreach my $link_field ( @link_fields ) {
      my @subfields = $link_field->subfield('w');
      print STDERR "ERROR: multiple 773w not supported\n" if $#subfields > 0;
      foreach my $subfield ( @subfields ) {
          my $host_bib_id = _get_host_records_bib_id($subfield);
          $link_field->update('w' => $host_bib_id);
      }
  }

  if ($#link_fields >= 0) {
      my $transformed_record = MARC::File::MARCXML->encode($record_object, { skipDeclaration => 1 });
      $transformed_record =~ s/^(.*\n)//;
      return encode('UTF-8', $transformed_record);
  } else {
      return $record;
  }
}

sub _get_host_records_bib_id($) {
  my $linking_id = shift();

  my $dbh = Exp::DB::dbh();
  my $sth = $dbh->prepare("SELECT bib_id FROM bib_index WHERE index_code = '035A' AND normal_heading = ?") || confess($dbh->errstr);
  $sth->execute($linking_id) || confess($dbh->errstr);
  my @row;
  my $rows = 0;
  my $host_bib_id = $linking_id;

  while ( ( @row ) = $sth->fetchrow_array ) {
      $rows++;
      print STDERR "ERROR: no support for multiple parents\n" if $rows > 1;
      $host_bib_id = $row[0];
  }
  return $host_bib_id;
}

return 1;
