#!perl -T
use strict;
use warnings;

use Test::More tests => 52;
use Test::Exception;
use Math::Geometry::Construction;
use Math::VectorReal;
use Math::Vector::Real;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub point {
    my $construction = Math::Geometry::Construction->new;
    my $p;
    my $pos;
    my $root;

    $p = $construction->add_point(position => V(14, 15));
    ok(defined($p), 'point is defined');
    isa_ok($p, 'Math::Geometry::Construction::Point');
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 14, 'x coordinate');
    is($pos->[1], 15, 'y coordinate');

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

    lives_ok(sub { $construction->as_svg(width => 800, height => 300) },
	     'as_svg');
    lives_ok(sub { $construction->as_tikz(width => 800, height => 300) },
	     'as_tikz');
}

sub coercion {
    my $construction = Math::Geometry::Construction->new;
    my $p;
    my $pos;

    $p = $construction->add_point(position => vector(1, 2, 3));
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 1, 'x coordinate');
    is($pos->[1], 2, 'y coordinate');

    $p = $construction->add_point(position => [4, 5, 6]);
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 4, 'x coordinate');
    is($pos->[1], 5, 'y coordinate');

    $p = $construction->add_point(position => [7, 8]);
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 7, 'x coordinate');
    is($pos->[1], 8, 'y coordinate');

    $p->position(vector(-3, 4, 1));
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], -3, 'x coordinate');
    is($pos->[1], 4, 'y coordinate');

    $p->position([9, -10]);
    $pos = $p->position;
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is($pos->[0], 9, 'x coordinate');
    is($pos->[1], -10, 'y coordinate');
}

sub defaults {
    my $construction = Math::Geometry::Construction->new;
    my $p;
    my $pos;
    my $root;

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

point;
coercion;
defaults;
