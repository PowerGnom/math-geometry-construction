package Math::Geometry::Construction::Derivate::PointOnCircle;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Derivate::PointOnCircle> - point on a Circle

=head1 VERSION

Version 0.023

=cut

our $VERSION = '0.023';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'distance' => (isa       => 'Num',
		   is        => 'rw',
		   predicate => 'has_distance',
		   clearer   => 'clear_distance',
		   trigger   => \&_distance_rules);

has 'quantile' => (isa       => 'Num',
		   is        => 'rw',
		   predicate => 'has_quantile',
		   clearer   => 'clear_quantile',
		   trigger   => \&_quantile_rules);

has 'phi'      => (isa       => 'Num',
		   is        => 'rw',
		   predicate => 'has_phi',
		   clearer   => 'clear_phi',
		   trigger   => \&_phi_rules);

sub _rules {
    my ($self, $ruler) = @_;
    
    foreach('distance', 'quantile', 'phi') {
	unless($_ eq $ruler) {
	    my $clearer = 'clear_'.$_;
	    $self->$clearer;
	}
    }

    $self->clear_global_buffer;
}

sub _distance_rules { $_[0]->_rules('distance') }
sub _quantile_rules { $_[0]->_rules('quantile') }
sub _phi_rules      { $_[0]->_rules('phi') }

sub BUILD {
    my ($self, $args) = @_;

    foreach('distance', 'quantile', 'phi') {
	my $predicate = 'has_'.$_;
	return if($self->$predicate);
    }
    croak "Position of PointOnCircle has to be set somehow";
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub calculate_positions {
    my ($self) = @_;
    my @input  = $self->input;

    if(@input != 1
       or
       !eval { $input[0]->isa('Math::Geometry::Construction::Circle') })
    {
	croak "Need one Circle for PointOnCircle";
    }

    my $center_p  = $input[0]->center->position;
    my $support_p = $input[0]->support->position;
    return if(!defined($center_p) or !defined($support_p));
    my $radius_v  = $support_p - $center_p;
    my $radius    = abs($radius_v);
    return $center_p if($radius == 0);

    my $phi = atan2($radius_v->[1], $radius_v->[0]);
    if($self->has_distance) {
	$phi += $self->distance / $radius;
    }
    elsif($self->has_quantile) {
	$phi += 6.28318530717959 * $self->quantile;
    }
    elsif($self->has_phi) {
	$phi += $self->phi;
    }
    else {
	croak "No way to determine position of PointOnCircle ".$self->id;
    }

    return($center_p + [$radius * cos($phi), $radius * sin($phi)]);
}

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

sub register_derived_point {
    my ($self, $point) = @_;

    foreach($self->input) { $_->register_point($point) }
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

Copyright 2013 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

