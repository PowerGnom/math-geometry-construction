#!perl -T
use strict;
use warnings;

use Test::More tests => 16;
use Math::Geometry::Construction;
use Math::Vector::Real;

sub fixed_point {
    my $construction = Math::Geometry::Construction->new;
    my @points;
    my @lines;
    my @circles;

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

    push(@points, $construction->add_derived_point
	 ('TranslatedPoint',
	  {input => [$points[0]], translator => [1, 2]}));
    is($points[5]->position->[0], 3, 'initial x');
    is($points[5]->position->[1], 1, 'initial y');
    $points[0]->position(V(12, -4));
    is($points[5]->position->[0], 13, 'shifted x');
    is($points[5]->position->[1], -2, 'shifted y');

    # changing position selection
    @points = ($construction->add_point(position => [0, 0]),
	       $construction->add_point(position => [4, 7]),
	       $construction->add_point(position => [4, -1]),
	       $construction->add_point(position => [4, 2]));
    
    @circles = ($construction->add_circle(center => $points[0],
					  radius => 5));
    @lines = ($construction->add_line(support => [@points[1, 2]]));

    push(@points, $construction->add_derived_point
	 ('IntersectionCircleLine',
	  {input => [$circles[0], $lines[0]]},
	  {position_selector => ['close_position', [$points[3]]]}));
    is($points[4]->position->[0], 4, 'initial x');
    is($points[4]->position->[1], 3, 'initial y');
    $points[0]->position(V(0, 4));
    is($points[4]->position->[0], 4, 'shifted x');
    is($points[4]->position->[1], 1, 'shifted y');

    # chained dependency
    @points = ($construction->add_point(position => [1, -4]));
    push(@points, $construction->add_derived_point
	 ('TranslatedPoint',
	  {input => [$points[0]], translator => [-1, 2]}));
    push(@points, $construction->add_derived_point
	 ('TranslatedPoint',
	  {input => [$points[0]], translator => [3, 5]}));
    push(@points, $construction->add_derived_point
	 ('TranslatedPoint',
	  {input => [$points[0]], translator => [-4, 5]}));
    @circles = ($construction->add_circle(center => $points[1],
					  radius => 5));
    @lines = ($construction->add_line(support => [@points[2, 3]]));

    push(@points, $construction->add_derived_point
	 ('IntersectionCircleLine',
	  {input => [$circles[0], $lines[0]]},
	  {position_selector => ['extreme_position', [[1, 0]]]}));
    is($points[4]->position->[0], 4, 'initial x');
    is($points[4]->position->[1], 1, 'initial y');
    $points[0]->position(V(-10, -3));
    is($points[4]->position->[0], -7, 'shifted x');
    is($points[4]->position->[1], 2, 'shifted y');
}

fixed_point;
