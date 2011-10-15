package Math::Geometry::Construction::PositionSelection;
use Moose::Role;

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::PositionSelection> - select position from list

=head1 VERSION

Version 0.006

=cut

our $VERSION = '0.006';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

requires 'id';
requires 'positions';

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub indexed_position {
    my ($self, $index) = @_;
    my @positions         = $self->positions;

    if(!@positions) {
	warn sprintf("No positions to select from in %s.\n", $self->id);
	return undef;
    }
    if($index < 0 or $index >= @positions) {
	warn sprintf("Position index out of range in %s.\n", $self->id);
	return undef;
    }

    return($positions[$index]);
}

sub extreme_position {
    my ($self, $direction) = @_;
    my $norm               = $direction / $direction->length;
    my @positions             = grep { defined($_->position) } $self->positions;

    if(!@positions) {
	warn sprintf("No positions to select from in %s.\n", $self->id);
	return undef;
    }

    return((map  { $_->[0] }
	    sort { $b->[1] <=> $a->[1] }
	    map  { [$_, $_->position . $norm] }
	    @positions)[0]);
}

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

1;


__END__

=pod

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Public Attributes

=head2 Methods for Users

=head2 Methods for Subclass Developers

=head3 as_svg

=head1 DIAGNOSTICS

=head2 Exceptions

=head2 Warnings


=head1 BUGS AND LIMITATIONS

No bugs have been reported. Please report all bugs directly to the author.


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

