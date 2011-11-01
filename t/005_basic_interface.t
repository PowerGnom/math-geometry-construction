#!perl -T
use strict;
use warnings;

use Test::More tests => 47;
use Math::Geometry::Construction;
use Math::VectorReal;

sub point {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);
    my $p;
    my $pos;

    $p = $construction->add_point(position => vector(1, 2, 3));
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::VectorReal');
    is($pos->x, 1, 'x coordinate');
    is($pos->y, 2, 'y coordinate');
    is($pos->z, 3, 'z coordinate');

    $p = $construction->add_point(position => [4, 5, 6]);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::VectorReal');
    is($pos->x, 4, 'x coordinate');
    is($pos->y, 5, 'y coordinate');
    is($pos->z, 6, 'z coordinate');

    $p = $construction->add_point(position => [7, 8]);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::VectorReal');
    is($pos->x, 7, 'x coordinate');
    is($pos->y, 8, 'y coordinate');
    is($pos->z, 0, 'z coordinate');

    $p = $construction->add_point(x => 9, 'y' => 10, z => 11);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::VectorReal');
    is($pos->x, 9, 'x coordinate');
    is($pos->y, 10, 'y coordinate');
    is($pos->z, 11, 'z coordinate');
    ok(!$p->hidden, 'not hidden');
    ok(!defined($p->size), 'size undef');  # to be changed when radius goes

    $p = $construction->add_point(x => 12, 'y' => 13, hidden => 1,
				  size => 10);
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::VectorReal');
    is($pos->x, 12, 'x coordinate');
    is($pos->y, 13, 'y coordinate');
    is($pos->z, 0, 'z coordinate');
    ok($p->hidden, 'hidden');
    is($p->size, 10, 'size 10');
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
    $c->position(vector(100, 100, 0));
    is($ci->radius, 20, 'set radius after moving');
}

point;
line;
circle;
