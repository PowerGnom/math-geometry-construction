#!perl -T
use strict;
use warnings;

use Test::More tests => 68;
use Test::Exception;
use Math::Geometry::Construction;
use Math::Vector::Real;
use Math::VectorReal;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub circle {
    my $construction = Math::Geometry::Construction->new;

    my $c;
    my $p;
    my $ci;
    my $root;
    my @points;
    my @positions;

    $c  = $construction->add_point(position => [10, 10]);
    $p  = $construction->add_point(position => [40, 50]);
    $ci = $construction->add_circle(center  => $c,
				    support => $p);
    ok(defined($ci), 'circle defined');
    isa_ok($ci, 'Math::Geometry::Construction::Circle');
    $root = $ci->construction;
    ok(defined($root), 'construction defined');
    isa_ok($root, 'Math::Geometry::Construction');
    ok(!$ci->fixed_radius, 'radius is not fixed');

    $c = $ci->center;
    ok(defined($c), 'center defined');
    isa_ok($c, 'Math::Geometry::Construction::Point');
    is_close($c->position->[0], 10, 'center x');
    is_close($c->position->[1], 10, 'center y');
    $p = $ci->support;
    ok(defined($p), 'support defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    is_close($p->position->[0], 40, 'support x');
    is_close($p->position->[1], 50, 'support y');
    is_close($ci->radius, 50, 'radius');
    @points = $ci->points;
    is(@points, 1, 'one point');
    is($points[0]->id, $p->id, 'point is support point');
    @positions = $ci->positions;
    is(@positions, 1, 'one position');
    is_close($positions[0]->[0], 40, 'position x');
    is_close($positions[0]->[1], 50, 'position y');

    $ci = $construction->add_circle(center  => [20, -10],
				    support => [70, 110]);
    ok(defined($ci), 'circle defined');
    isa_ok($ci, 'Math::Geometry::Construction::Circle');
    $root = $ci->construction;
    ok(defined($root), 'construction defined');
    isa_ok($root, 'Math::Geometry::Construction');
    ok(!$ci->fixed_radius, 'radius is not fixed');
    
    $c = $ci->center;
    ok(defined($c), 'center defined');
    isa_ok($c, 'Math::Geometry::Construction::Point');
    is_close($c->position->[0], 20, 'center x');
    is_close($c->position->[1], -10, 'center y');
    $p = $ci->support;
    ok(defined($p), 'support defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    is_close($p->position->[0], 70, 'support x');
    is_close($p->position->[1], 110, 'support y');
    is_close($ci->radius, 130, 'radius');

    $ci = $construction->add_circle(center  => V(5, 6),
				    support => vector(3, 2, 0));
    ok(defined($ci), 'circle defined');
    isa_ok($ci, 'Math::Geometry::Construction::Circle');
    $root = $ci->construction;
    ok(defined($root), 'construction defined');
    isa_ok($root, 'Math::Geometry::Construction');
    ok(!$ci->fixed_radius, 'radius is not fixed');
    
    $c = $ci->center;
    ok(defined($c), 'center defined');
    isa_ok($c, 'Math::Geometry::Construction::Point');
    is_close($c->position->[0], 5, 'center x');
    is_close($c->position->[1], 6, 'center y');
    $p = $ci->support;
    ok(defined($p), 'support defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    is_close($p->position->[0], 3, 'support x');
    is_close($p->position->[1], 2, 'support y');

    $ci = $construction->add_circle(center => [50, 100],
				    radius => 20);
    ok(defined($ci), 'circle defined');
    isa_ok($ci, 'Math::Geometry::Construction::Circle');
    is_close($ci->radius, 20, 'set radius');
    ok($ci->fixed_radius, 'radius is fixed');

    $c = $ci->center;
    ok(defined($c), 'center defined');
    isa_ok($c, 'Math::Geometry::Construction::Point');
    is_close($c->position->[0], 50, 'center x');
    is_close($c->position->[1], 100, 'center y');
    $p = $ci->support;
    ok(defined($p), 'support defined');
    isa_ok($p, 'Math::Geometry::Construction::DerivedPoint');
    is_close(($p->position - $c->position)->abs, 20, 'support distance');

    $c->position(V(100, 200));
    is_close($ci->radius, 20, 'set radius after moving');
    $c = $ci->center;
    ok(defined($c), 'center defined');
    isa_ok($c, 'Math::Geometry::Construction::Point');
    is_close($c->position->[0], 100, 'center x');
    is_close($c->position->[1], 200, 'center y');
    $p = $ci->support;
    ok(defined($p), 'support defined');
    isa_ok($p, 'Math::Geometry::Construction::DerivedPoint');
    is_close(($p->position - $c->position)->abs, 20, 'support distance');
    @points = $ci->points;
    is(@points, 1, 'one point');
    is($points[0]->id, $p->id, 'point is support point');
    @positions = $ci->positions;
    is(@positions, 1, 'one position');
}

circle;
