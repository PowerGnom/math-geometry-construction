package Math::Geometry::Construction::Derivate::IntersectionCircleLine;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Derivate::IntersectionCircleLine> - circle line intersection

=head1 VERSION

Version 0.020

=cut

our $VERSION = '0.020';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

sub BUILD {
    my ($self, $args) = @_;

    my @input = $self->input;
    croak "Need one circle and one line to intersect" if(@input != 2);
    unless(eval { $input[0]->isa('Math::Geometry::Construction::Circle') }
	   and
	   eval { $input[1]->isa('Math::Geometry::Construction::Line') }
	   or
	   eval { $input[0]->isa('Math::Geometry::Construction::Line') }
	   and
	   eval { $input[1]->isa('Math::Geometry::Construction::Circle') })
    { croak "Need one circle and one line to intersect" }
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub calculate_positions {
    my ($self) = @_;
    my @input  = $self->input;

    my $circle_class = 'Math::Geometry::Construction::Circle';
    my ($circle, $line) = $input[0]->isa($circle_class)
        ? @input : reverse(@input);
       
    my $c_center_p  = $circle->center->position;
    my $c_radius    = $circle->radius;
    my @l_support_p = map { $_->position } $line->support;

    foreach($c_center_p, $c_radius, @l_support_p) {
	return if(!defined($_));
    }

    my $l_parallel = $line->parallel or return;
    my $l_normal   = $line->normal;
    my $l_constant = $l_normal * $l_support_p[0];

    my $a   = $l_normal * $c_center_p - $l_constant;
    my $rad = $c_radius ** 2 - $a ** 2;
    return if($rad < 0);
    my $b   = sqrt($rad);
    
    return($c_center_p - $l_normal * $a - $l_parallel * $b,
	   $c_center_p - $l_normal * $a + $l_parallel * $b);
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

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

