#!perl -T
use strict;
use warnings;

use Test::More tests => 60;
use Test::Exception;
use Math::Geometry::Construction;
use Math::VectorReal;
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

    $construction->add_point(id       => 'P1',
			     position => [0.1, 0.2]);
    $construction->add_point(id       => 'P2',
			     position => [0.3, 0.4]);
    $l = $construction->add_line(support => [$construction->object('P1'),
					     $construction->object('P2')]);
    ok(defined($l));
    isa_ok($l, 'Math::Geometry::Construction::Line');
    is($l->order_index, 2, 'order index');
    is($l->id, 'L000000002', 'id');
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
    ok(defined($l));
    isa_ok($l, 'Math::Geometry::Construction::Line');
    is($l->order_index, 5, 'order index');
    is($l->id, 'L000000005', 'id');
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

__END__

sub circle {
    my $construction = Math::Geometry::Construction->new;

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

sub style {
    my $construction = Math::Geometry::Construction->new;
    my $p;
    
    # point
    $p = $construction->add_point(position => [1, 2]);
    is_deeply($p->style_hash, {stroke => 'black', fill => 'white'},
	      'default point style');
    is($p->style('stroke'), 'black', 'default stroke');
    is($p->style('fill'), 'white', 'default fill');
    $p->style('fill', 'green');
    is($p->style('fill'), 'green', 'custom fill non-constructor');

    is_deeply($p->label_style_hash, {}, 'default label style');

    $p = $construction->add_point(position => [4, 5],
				  style    => {stroke => 'blue'});
    is_deeply($p->style_hash, {stroke => 'blue', fill => 'white'},
	      'point style');
    is($p->style('stroke'), 'blue', 'custom stroke constructor');
    is($p->style('fill'), 'white', 'default fill');

    # array color
    $p = $construction->add_point
	(position => [6, 7],
	 style    => {stroke => [0, 128, 0]});
    is_deeply($p->style('stroke'), [0, 128, 0], 'array color');
    $p->style('stroke', [123, 213, 2]);
    is_deeply($p->style('stroke'), [123, 213, 2], 'array color');
    $p->style('stroke', 'yellow');
    is($p->style('stroke'), 'yellow', 'color');

    $p = $construction->add_point(position => [6, 7]);
    is($p->style('stroke'), 'black', 'default color');
    $p->style('stroke', [122, 214, 67]);
    is_deeply($p->style('stroke'), [122, 214, 67], 'array color');
    $p->style('stroke', 'yellow');
    is($p->style('stroke'), 'yellow', 'color');

    $p = $construction->add_point
	(position    => [6, 7],
	 label_style => {stroke => [0, 128, 0]});
    is_deeply($p->label_style('stroke'), [0, 128, 0], 'array color');
    $p->label_style('stroke', [123, 213, 2]);
    is_deeply($p->label_style('stroke'), [123, 213, 2], 'array color');
    $p->label_style('stroke', 'yellow');
    is($p->label_style('stroke'), 'yellow', 'color');

    $p = $construction->add_point(position => [6, 7]);
    $p->label_style('stroke', [122, 214, 67]);
    is_deeply($p->label_style('stroke'), [122, 214, 67], 'array color');
    $p->label_style('stroke', 'yellow');
    is($p->label_style('stroke'), 'yellow', 'color');
}

line;
circle;
style;
