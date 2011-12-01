#!perl -T
use strict;
use warnings;

use Test::More tests => 72;
use Test::Exception;
use Test::Warn;
use Math::Geometry::Construction;
use Math::VectorReal;
use Math::Vector::Real;

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

sub constructs_ok {
    my ($construction, $args, $x, $y) = @_;
    my $point;

    warning_is { $point = $construction->add_point(%$args) } undef,
        'no warnings in constructor';

    ok(defined($point), 'point is defined');
    isa_ok($point, 'Math::Geometry::Construction::Point');
    position_ok($point->position, $x, $y);

    return $point;
}

sub point {
    my $construction = Math::Geometry::Construction->new;
    my $p;

    $p = constructs_ok($construction,
		       {position => V(14, 15)},
		       14, 15);

    $p = constructs_ok($construction,
		       {x => 9, 'y' => 10, z => 11},
		       9, 10);
    ok(!$p->hidden, 'not hidden');
    is($p->size, 6, 'default size');

    $p = constructs_ok($construction,
		       {x => 12, 'y' => 13, hidden => 1, size => 10},
		       12, 13);
    ok($p->hidden, 'hidden');
    is($p->size, 10, 'size 10');

    lives_ok(sub { $construction->as_svg(width => 800, height => 300) },
	     'as_svg');
    lives_ok(sub { $construction->as_tikz(width => 800, height => 300) },
	     'as_tikz');
}

sub coercion {
    my $construction = Math::Geometry::Construction->new;
    my $point;

    $point = constructs_ok($construction,
			   {position => vector(1, 2, 3)},
			   1, 2);

    $point = constructs_ok($construction,
			   {position => [4, 5, 6]},
			   4, 5);

    $point = constructs_ok($construction,
			   {position => [7, 8]},
			   7, 8);

    $point->position(vector(-3, 4, 1));
    position_ok($point->position, -3, 4);

    $point->position([9, -10]);
    position_ok($point->position, 9, -10);
}

sub defaults {
    my $construction = Math::Geometry::Construction->new;
    my $point;

    $point = $construction->add_point(position => [0, 0]);
    is($point->size, 6, 'default point size 6');
    is($point->radius, 3, 'default radius 3');
    $construction->point_size(7.5);

    $point = $construction->add_point(position => [0, 0]);
    is($point->size, 7.5, 'default point size 7.5');
    is($point->radius, 3.75, 'default radius 3.75');
    $point->size(12);
    is($point->size, 12, 'adjusted point size 12');
    is($point->radius, 6, 'adjusted point size 6');

    $point = $construction->add_point(position => [0, 0], size => 13.35);
    is($point->size, 13.35, 'constructed point size 13.35');
    is($point->radius, 6.675, 'constructed point size 6.675');
}

point;
coercion;
defaults;
