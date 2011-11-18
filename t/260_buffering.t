#!perl -T
use strict;
use warnings;

use Test::More tests => 4;
use Math::Geometry::Construction;
use Math::Vector::Real;

sub derived_point {
    my $construction = Math::Geometry::Construction->new;
    my @points;
    my @lines;

    @points = ($construction->add_point(position => [2, -1]),
	       $construction->add_point(position => [4, -1]),
	       $construction->add_point(position => [3,  5]),
	       $construction->add_point(position => [3,  7]));

    @lines = ($construction->add_line(support => [@points[0, 1]]),
	      $construction->add_line(support => [@points[2, 3]]));

    push(@points, $construction->add_derived_point
	 ('IntersectionLineLine',
	  {input => [@lines[0, 1]]}));

    is($points[4]->position->[0],  3, 'initial x');
    is($points[4]->position->[1], -1, 'initial y');

    $points[1]->position(V(4, -3));
    is($points[4]->position->[0],  3, 'shifted x');
    is($points[4]->position->[1], -2, 'shifted y');
}

derived_point;
