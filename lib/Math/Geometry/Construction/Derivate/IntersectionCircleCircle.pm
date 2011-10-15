package Math::Geometry::Construction::Derivate::IntersectionCircleCircle;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;
use Math::VectorReal ':all';
use Math::Geometry::Construction::TemporaryPoint;

=head1 NAME

C<Math::Geometry::Construction::Derivate::IntersectionCircleCircle> - circle circle intersection

=head1 VERSION

Version 0.006

=cut

our $VERSION = '0.006';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub points {
    my ($self)  = @_;
    my @circles = $self->input;

    croak "Need two circles to intersect" if(@circles != 2);
    foreach(@circles) {
	if(!$_->isa('Math::Geometry::Construction::Circle')) {
	    croak sprintf("Need circles for CircleCircle intersection, ".
			  "no %s", ref($_));
	}
    }

    # currently assuming that points have to be defined
    my @center_p = map { $_->center->position  } @circles;
    my @radii    = map { $_->radius            } @circles;

    foreach(@center_p, @radii) {
	return if(!defined($_));
    }

    my $distance = ($center_p[1] - $center_p[0]);
    my $d        = $distance->length;
    return if($d == 0);

    my $parallel = $distance / $d;
    my $normal   = vector(-$parallel->y, $parallel->x, 0);

    my $x   = ($d**2 - $radii[1]**2 + $radii[0]**2) / (2 * $d);
    my $rad = $radii[0]**2 - $x**2;
    return if($rad < 0);

    my $y         = sqrt($rad);
    my @positions = ($center_p[0] + $parallel * $x + $normal * $y,
		     $center_p[0] + $parallel * $x - $normal * $y);
    my $class     = 'Math::Geometry::Construction::TemporaryPoint';
    return(map { $class->new(position => $_) } @positions);
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

