package Math::Geometry::Construction::Derivate::PointOnLine;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Math::Geometry::Construction::Types qw(Line);
use Carp;

=head1 NAME

C<Math::Geometry::Construction::Derivate::PointOnLine> - point on a line

=head1 VERSION

Version 0.024

=cut

our $VERSION = '0.024';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'input'    => (isa       => Line,
		   coerce    => 1,
		   is        => 'ro',
		   required  => 1);

has 'distance' => (isa       => 'Num',
		   is        => 'rw',
		   predicate => '_has_distance',
		   clearer   => '_clear_distance',
		   trigger   => \&_distance_rules);

has 'quantile' => (isa       => 'Num',
		   is        => 'rw',
		   predicate => '_has_quantile',
		   clearer   => '_clear_quantile',
		   trigger   => \&_quantile_rules);

has 'x'        => (isa       => 'Num',
		   is        => 'rw',
		   predicate => '_has_x',
		   clearer   => '_clear_x',
		   trigger   => \&_x_rules);

has 'y'        => (isa       => 'Num',
		   is        => 'rw',
		   predicate => '_has_y',
		   clearer   => '_clear_y',
		   trigger   => \&_y_rules);

sub _rules {
    my ($self, $ruler) = @_;
    
    foreach('distance', 'quantile', 'x', 'y') {
	unless($_ eq $ruler) {
	    my $clearer = '_clear_'.$_;
	    $self->$clearer;
	}
    }

    $self->clear_global_buffer;
}

sub _distance_rules { $_[0]->_rules('distance') }
sub _quantile_rules { $_[0]->_rules('quantile') }
sub _x_rules        { $_[0]->_rules('x') }
sub _y_rules        { $_[0]->_rules('y') }

sub BUILD {
    my ($self, $args) = @_;

    foreach('distance', 'quantile', 'x', 'y') {
	my $predicate = '_has_'.$_;
	return if($self->$predicate);
    }
    croak "Position of PointOnLine has to be set somehow";
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub calculate_positions {
    my ($self) = @_;
    my $line  = $self->input;

    my @support_p = map { $_->position } $line->support;
    return if(!defined($support_p[0]) or !defined($support_p[1]));
    my $s_distance = ($support_p[1] - $support_p[0]);

    if($self->_has_distance) {
	my $d = abs($s_distance);
	return if($d == 0);

	return($support_p[0] + $s_distance / $d * $self->distance);
    }
    elsif($self->_has_quantile) {
        return($support_p[0] + $s_distance * $self->quantile);
    }
    elsif($self->_has_x) {
	my $sx = $s_distance->[0];
	return if($sx == 0);

	my $scale = ($self->x - $support_p[0]->[0]) / $sx;
	return($support_p[0] + $s_distance * $scale);
    }
    elsif($self->_has_y) {
	my $sy = $s_distance->[1];
	return if($sy == 0);

	my $scale = ($self->y - $support_p[0]->[1]) / $sy;
	return($support_p[0] + $s_distance * $scale);
    }
    else {
	croak "No way to determine position of PointOnLine ".$self->id;
    }
}

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

sub register_derived_point {
    my ($self, $point) = @_;

    $self->input->register_point($point);
}

1;


__END__

=pod

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Public Attributes

=head2 Methods for Users

=head2 Methods for Subclass Developers


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011, 2013 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

