package Math::Geometry::Construction::Derivate::PointOnLine;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Derivate::PointOnLine> - point on a line

=head1 VERSION

Version 0.008

=cut

our $VERSION = '0.008';


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

has 'x'        => (isa       => 'Num',
		   is        => 'rw',
		   predicate => 'has_x',
		   clearer   => 'clear_x',
		   trigger   => \&_x_rules);

has 'y'        => (isa       => 'Num',
		   is        => 'rw',
		   predicate => 'has_y',
		   clearer   => 'clear_y',
		   trigger   => \&_y_rules);

sub _rules {
    my ($self, $ruler) = @_;
    
    foreach('distance', 'quantile', 'x', 'y') {
	unless($_ eq $ruler) {
	    my $clearer = 'clear_'.$_;
	    $self->$clearer;
	}
    }
}

sub _distance_rules { $_[0]->_rules('distance') }
sub _quantile_rules { $_[0]->_rules('quantile') }
sub _x_rules        { $_[0]->_rules('x') }
sub _y_rules        { $_[0]->_rules('y') }

sub BUILD {
    my ($self, $args) = @_;

    foreach('distance', 'quantile', 'x', 'y') {
	my $predicate = 'has_'.$_;
	return if($self->$predicate);
    }
    croak "Position of PointOnLine has to be set somehow";
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub positions {
    my ($self) = @_;
    my @input  = $self->input;

    if(@input != 1
       or
       !eval { $input[0]->isa('Math::Geometry::Construction::Line') })
    {
	croak "Need one line for PointOnLine";
    }

    my @support_p = map { $_->position } $input[0]->support;
    return if(!defined($support_p[0]) or !defined($support_p[1]));
    my $s_distance = ($support_p[1] - $support_p[0]);

    if($self->has_distance) {
	my $d = $s_distance->length;
	return if($d == 0);

	return($support_p[0] + $s_distance / $d * $self->distance);
    }
    elsif($self->has_quantile) {
        return($support_p[0] + $s_distance * $self->quantile);
    }
    elsif($self->has_x) {
	my $sx = $s_distance->x;
	return if($sx == 0);

	my $scale = ($self->x - $support_p[0]->x) / $sx;
	return($support_p[0] + $s_distance * $scale);
    }
    elsif($self->has_y) {
	my $sy = $s_distance->y;
	return if($sy == 0);

	my $scale = ($self->y - $support_p[0]->y) / $sy;
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

1;


__END__

=pod

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Public Attributes

=head2 Methods for Users

=head2 Methods for Subclass Developers

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

