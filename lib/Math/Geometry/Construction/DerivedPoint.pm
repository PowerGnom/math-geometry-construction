package Math::Geometry::Construction::DerivedPoint;

use 5.008008;

use Moose;
use Math::VectorReal;
use Carp;

=head1 NAME

C<Math::Geometry::Construction::DerivedPoint> - e.g. intersection point

=head1 VERSION

Version 0.003

=cut

our $VERSION = '0.003';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

our $ID_TEMPLATE = 'S%09d';

sub id_template { return $ID_TEMPLATE }

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Object';
with 'Math::Geometry::Construction::Output';

has 'derivate'       => (isa      => 'Item',
		         is       => 'ro',
		         required => 1);

has 'point_selector' => (isa      => 'ArrayRef[Item]',
			 is       => 'ro',
			 reader   => '_point_selector',
			 required => 1);

has 'radius'         => (isa     => 'Num',
			 is      => 'rw',
			 default => 3);

sub BUILD {
    my ($self, $args) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));
    $self->style('fill', 'white')   unless($self->style('fill'));
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub position {
    my ($self) = @_;

    my ($selection_method, $args) = @{$self->_point_selector};
    my $point = $self->intersection->$selection_method(@$args);
    return $point ? $point->position : undef;
}

sub as_svg {
    my ($self, %args) = @_;
    return undef if $self->hidden;

    my $position = $self->position;
    if(!defined($position)) {
	warn sprintf("Undefined position of intersection point  %s, ".
		     "nothing to draw.\n", $self->id);
	return undef;
    }

    $args{parent}->circle(cx    => $position->x,
			  cy    => $position->y,
			  r     => $self->radius,
			  style => $self->style_hash,
			  id    => $self->id);

    return undef;
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

=head3 id_template

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

