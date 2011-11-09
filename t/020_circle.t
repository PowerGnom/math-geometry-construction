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

circle;

__END__

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

circle;
