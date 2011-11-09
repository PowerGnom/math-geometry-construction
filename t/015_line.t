#!perl -T
use strict;
use warnings;

use Test::More tests => 55;
use Test::Exception;
use Math::Geometry::Construction;
use Math::Vector::Real;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub line {
    my $construction = Math::Geometry::Construction->new;
    my $l;
    my $root;
    my @support;
    my $dir;

    @support = ($construction->add_point(position => [0.1, 0.2]),
		$construction->add_point(position => [0.3, 0.4]));
    $l = $construction->add_line(support => [@support]);
    ok(defined($l), 'line defined');
    isa_ok($l, 'Math::Geometry::Construction::Line');
    $root = $l->construction;
    ok(defined($root), 'construction defined');
    isa_ok($root, 'Math::Geometry::Construction');

    @support = $l->support;
    is(@support, 2, 'two support points');
    foreach my $p (@support) {
	ok(defined($p), 'support point defined');
	isa_ok($p, 'Math::Geometry::Construction::Point');

	my $pos = $p->position;
	isa_ok($pos, 'Math::Vector::Real');
	is(@$pos, 2, 'two components');
    }
    is($support[0]->position->[0], 0.1, 'x coordinate');
    is($support[0]->position->[1], 0.2, 'y coordinate');
    is($support[1]->position->[0], 0.3, 'x coordinate');
    is($support[1]->position->[1], 0.4, 'y coordinate');

    is($l->extend, 0, 'default extend');

    $dir = $l->parallel;
    ok(defined($dir), 'parallel defined');
    isa_ok($dir, 'Math::Vector::Real');
    is_close($dir->[0], 0.2 / (sqrt(2 * 0.2**2)), 'x direction');
    is_close($dir->[1], 0.2 / (sqrt(2 * 0.2**2)), 'y direction');
    $dir = $l->normal;
    ok(defined($dir), 'normal defined');
    isa_ok($dir, 'Math::Vector::Real');
    is_close($dir->[0], -0.2 / (sqrt(2 * 0.2**2)), 'x direction');
    is_close($dir->[1],  0.2 / (sqrt(2 * 0.2**2)), 'y direction');

    $l = $construction->add_line(support => [[3, 5], V(-1, 12)]);
    ok(defined($l), 'line defined');
    isa_ok($l, 'Math::Geometry::Construction::Line');
    $root = $l->construction;
    ok(defined($root), 'construction defined');
    isa_ok($root, 'Math::Geometry::Construction');

    @support = $l->support;
    is(@support, 2, 'two support points');
    foreach my $p (@support) {
	ok(defined($p), 'support point defined');
	isa_ok($p, 'Math::Geometry::Construction::Point');

	ok($p->hidden, 'implicit support point hidden');
	
	my $pos = $p->position;
	isa_ok($pos, 'Math::Vector::Real');
	is(@$pos, 2, 'two components');
    }
    is($support[0]->position->[0], 3, 'x coordinate');
    is($support[0]->position->[1], 5, 'y coordinate');
    is($support[1]->position->[0], -1, 'x coordinate');
    is($support[1]->position->[1], 12, 'y coordinate');
    is($support[0]->order_index, 3, 'implict point order index');
    is($support[1]->order_index, 4, 'implict point order index');

    $dir = $l->parallel;
    ok(defined($dir), 'parallel defined');
    isa_ok($dir, 'Math::Vector::Real');
    is_close($dir->[0], -4 / (sqrt(4**2 + 7**2)), 'x direction');
    is_close($dir->[1],  7 / (sqrt(4**2 + 7**2)), 'y direction');
    $dir = $l->normal;
    ok(defined($dir), 'normal defined');
    isa_ok($dir, 'Math::Vector::Real');
    is_close($dir->[0], -7 / (sqrt(4**2 + 7**2)), 'x direction');
    is_close($dir->[1], -4 / (sqrt(4**2 + 7**2)), 'y direction');
}

line;
