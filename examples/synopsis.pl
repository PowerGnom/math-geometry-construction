#!/usr/bin/perl
use strict;
use warnings;

use Math::Geometry::Construction;

my $construction = Math::Geometry::Construction->new
    (width  => 500, height => 300);
my $p1 = $construction->add_point('x' => 100, 'y' => 150, hidden => 1);
my $p2 = $construction->add_point('x' => 120, 'y' => 150, hidden => 1);
my $p3 = $construction->add_point('x' => 200, 'y' => 50);
my $p4 = $construction->add_point('x' => 200, 'y' => 250);

my $l1 = $construction->add_line(extend         => 10,
				 label          => 'g',
				 label_offset_y => 13);
$l1->add_support($p1);
$l1->add_support($p2);
my $l2 = $construction->add_line;
$l2->add_support($p3);
$l2->add_support($p4);

my $i1 = $construction->add_derivate('IntersectionLineLine',
				     input => [$l1, $l2]);
my $p5 = $i1->create_derived_point
    (point_selector => ['indexed_point', [0]],
     label          => 'S',
     label_offset_x => 5,
     label_offset_y => -5);

print $construction->as_svg(width => 800, height => 300)->xmlify;
