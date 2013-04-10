#!perl -T
use strict;
use warnings;

use Test::More tests => 89;
use Test::Exception;
use Test::Warn;
use Math::Geometry::Construction;
use Math::Vector::Real;
use Math::VectorReal;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub position_ok {
    my ($pos, $x, $y) = @_;

    ok(defined($pos), 'position is defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'position has 2 components');

    if(defined($x)) {
	is($pos->[0], $x, "x coordinate is $x");
    }
    if(defined($y)) {
	is($pos->[1], $y, "y coordinate is $y");
    }
}

sub support_ok {
    my ($circle, $pos) = @_;
    my $center  = $circle->center;
    my $support = $circle->support;

    ok(defined($center), 'center point defined');
    isa_ok($center, 'Math::Geometry::Construction::Point');
    position_ok($center->position, @{$pos->[0]});
    if($pos->[1]) {
	ok(defined($support), 'support point defined');
	isa_ok($support, 'Math::Geometry::Construction::Point');
	position_ok($support->position, @{$pos->[1]});
    }
}

sub constructs_ok {
    my ($construction, $args, $pos) = @_;
    my $circle;

    warning_is { $circle = $construction->add_circle(%$args) } undef,
        'no warnings in constructor';

    ok(defined($circle), 'circle is defined');
    isa_ok($circle, 'Math::Geometry::Construction::Circle');
    support_ok($circle, $pos);

    if($args->{radius}) {
	is_close($circle->radius, $args->{radius},
		 'radius is '.$args->{radius});
    }
    else {
	my $radius = sqrt(($pos->[1]->[0] - $pos->[0]->[0])**2 +
			  ($pos->[1]->[1] - $pos->[0]->[1])**2);
	is_close($circle->radius, $radius, "radius is $radius");
    }

    return $circle;
}

sub construction {
    my $construction = Math::Geometry::Construction->new;
    my $circle;
    my @template;

    @template = ([{center  => [1, 2],
		   support => [3, 4]},
		  [[1, 2], [3, 4]]]);

=pod

,
		 [{position => [3, 4, 5]}, [3, 4]],
		 [{position => V(6, 7)}, [6, 7]],
		 [{position => vector(8, 9, 10)}, [8, 9]],
		 [{x => 11, 'y' => 12}, [11, 12]],
		 [{x => 13, 'y' => 14, z => 15}, [13, 14]]);

=cut

    foreach(@template) {
	constructs_ok($construction, $_->[0], $_->[1]);
    }

=pod

    $point = $construction->add_point(position => [0, 0]);
    ok(!$point->hidden, 'point not hidden by default');
    $point->hidden(1);
    ok($point->hidden, 'point can be hidden');
    $point = $construction->add_point(position => [0, 0],
				      hidden   => 1);
    ok($point->hidden, 'point can be hidden at startup');

=cut

}

sub circle {
    my $construction = Math::Geometry::Construction->new;
    my $circle;
    my $center;
    my $support;
    my @points;
    my @positions;

    $center  = $construction->add_point(position => [10, 10]);
    $support = $construction->add_point(position => [40, 50]);
    $circle  = constructs_ok($construction, {center  => $center,
					     support => $support},
			     [[10, 10], [40, 50]]);
    @points = $circle->points;
    is(@points, 1, 'one point');
    is($points[0]->id, $support->id, 'point is support point');
    @positions = $circle->positions;
    position_ok($positions[0], 40, 50);

    $circle = constructs_ok($construction, {center  => [20, -10],
					    support => [70, 110]},
			     [[20, -10], [70, 110]]);

    $circle = constructs_ok($construction, {center  => V(5, 6),
					    support => vector(3, 2, 0)},
			     [[5, 6], [3, 2]]);

    $circle = constructs_ok($construction, {center => [50, 100],
					    radius => 20},
			     [[50, 100]]);

    $circle->center->position(V(100, 200));
    is_close($circle->radius, 20, 'set radius after moving');
    $center = $circle->center;
    position_ok($center->position, 100, 200);
    $support = $circle->support;
    ok(defined($support), 'support defined');
    isa_ok($support, 'Math::Geometry::Construction::DerivedPoint');
    is_close(($support->position - $center->position)->abs, 20,
	     'support distance');
    @points = $circle->points;
    is(@points, 1, 'one point');
    is($points[0]->id, $support->id, 'point is support point');
    @positions = $circle->positions;
    is(@positions, 1, 'one position');
    is_close(($positions[0] - $center->position)->abs, 20,
	     'position lies on circle');
}

construction;
#circle;
