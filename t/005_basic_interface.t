#!perl -T
use strict;
use warnings;

use Test::More tests => 63;
use Math::Geometry::Construction;
use Math::VectorReal;
use Math::Vector::Real;

sub point {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);
    my $p;
    my $pos;

    $p = $construction->add_point(position => vector(1, 2, 3));
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 1, 'x coordinate');
    is($pos->[1], 2, 'y coordinate');

    $p = $construction->add_point(position => [4, 5, 6]);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 4, 'x coordinate');
    is($pos->[1], 5, 'y coordinate');

    $p = $construction->add_point(position => [7, 8]);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 7, 'x coordinate');
    is($pos->[1], 8, 'y coordinate');

    $p = $construction->add_point(x => 9, 'y' => 10, z => 11);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 9, 'x coordinate');
    is($pos->[1], 10, 'y coordinate');
    ok(!$p->hidden, 'not hidden');
    is($p->size, 6, 'default size');

    $p = $construction->add_point(x => 12, 'y' => 13, hidden => 1,
				  size => 10);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 12, 'x coordinate');
    is($pos->[1], 13, 'y coordinate');
    ok($p->hidden, 'hidden');
    is($p->size, 10, 'size 10');

    $p = $construction->add_point(position => V(14, 15));
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 14, 'x coordinate');
    is($pos->[1], 15, 'y coordinate');

    # defaults
    is($p->style('stroke'), 'black', 'default stroke black');
    is($p->style('fill'), 'white', 'default stroke white');

    $p = $construction->add_point(position => [0, 0]);
    is($p->size, 6, 'default point size 6');
    is($p->radius, 3, 'default radius 3');
    $construction->point_size(7.5);
    $p = $construction->add_point(position => [0, 0]);
    is($p->size, 7.5, 'default point size 7.5');
    is($p->radius, 3.75, 'default radius 3.75');
    $p->size(12);
    is($p->size, 12, 'adjusted point size 12');
    is($p->radius, 6, 'adjusted point size 6');
    $p = $construction->add_point(position => [0, 0], size => 13.35);
    is($p->size, 13.35, 'constructed point size 13.35');
    is($p->radius, 6.675, 'constructed point size 6.675');
}

sub derived_point {
}

sub line {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $p1 = $construction->add_point('x' => 500, 'y' => 100, hidden => 1);
    my $p2 = $construction->add_point(position => vector(700, 200, 0),
				      style    => {stroke => 'none',
						   fill   => 'blue',
						   'fill-opacity' => 0.5});
    my $l1 = $construction->add_line(support => [$p1, $p2]);

    my @support = $l1->support;
    is(@support, 2, "two support points");
    isa_ok($support[0], 'Math::Geometry::Construction::Point');
    isa_ok($support[1], 'Math::Geometry::Construction::Point');

    @support = $l1->points;
    is(@support, 2, "two poi");
    isa_ok($support[0], 'Math::Geometry::Construction::Point');
    isa_ok($support[1], 'Math::Geometry::Construction::Point');
}

sub circle {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $c;
    my $p;
    my $ci;

    $c = $construction->add_point(position => [10, 10]);
    $p = $construction->add_point(position => [40, 50]);

    $ci = $construction->add_circle(center  => $c,
				    support => $p);
    ok(defined($ci), 'circle is defined');
    isa_ok($ci, 'Math::Geometry::Construction::Circle');
    is($ci->radius, 50, 'calculated radius');

    $ci = $construction->add_circle(center => $c,
				    radius => 20);
    ok(defined($ci), 'circle is defined');
    isa_ok($ci, 'Math::Geometry::Construction::Circle');
    is($ci->radius, 20, 'set radius');
    $c->position(V(100, 100));
    is($ci->radius, 20, 'set radius after moving');
}

point;
line;
circle;
