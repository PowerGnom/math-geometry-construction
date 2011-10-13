#!/usr/bin/perl
use strict;
use warnings;

use Math::Geometry::Construction;
use Math::VectorReal;
use SVG::Rasterize;

my $construction = Math::Geometry::Construction->new(width  => 800,
						     height => 300);

sub line {
    my $p1 = $construction->add_point('x' => 500, 'y' => 100, hidden => 1);
    my $p2 = $construction->add_point(position => vector(700, 200, 0),
				      style    => {stroke => 'none',
						   fill   => 'blue',
						   'fill-opacity' => 0.5});
    my $l1 = $construction->add_line(extend => 50);
    $l1->add_support($p1);
    $l1->add_support($p2);
}

sub intersection {
    my $p1 = $construction->add_point('x' => 100, 'y' => 150);
    my $p2 = $construction->add_point('x' => 120, 'y' => 150);
    my $p3 = $construction->add_point('x' => 200, 'y' => 50);
    my $p4 = $construction->add_point
	('x' => 200, 'y' => 250,
	 label          => "P4",
	 label_offset_x => 7,
	 label_offset_y => 10,
	 label_style    => {'font-family' => 'Helvetica'});

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
}

sub circle {
    my $p01 = $construction->add_point('x' => 190, 'y' => 200);
    my $p02 = $construction->add_point('x' => 190, 'y' => 170, hidden => 1);
    my $c1  = $construction->add_circle(center  => $p01,
					support => $p02);

    my $p03 = $construction->add_point('x' => 200, 'y' => 50, hidden => 1);
    my $p04 = $construction->add_point('x' => 200, 'y' => 60, hidden => 1);

    my $l1 = $construction->add_line(hidden => 1);
    $l1->add_support($p03);
    $l1->add_support($p04);

    my $i1 = $construction->add_derivate('IntersectionCircleLine',
					 input => [$l1, $c1]);
    my $p05 = $i1->create_derived_point
	(point_selector => ['indexed_point', [0]],
	 label          => 'T',
	 label_offset_x => 5,
	 label_offset_y => -5);
    my $p06 = $i1->create_derived_point
	(point_selector => ['indexed_point', [1]],
	 label          => 'U',
	 label_offset_x => 5,
	 label_offset_y => -5);

    my $p07 = $construction->add_point('x' => 350, 'y' => 200);
    my $p08 = $construction->add_point('x' => 350, 'y' => 240, hidden => 1);
    my $c2  = $construction->add_circle(center  => $p07,
					support => $p08);
    my $p09 = $construction->add_point('x' => 360, 'y' => 220);
    my $p10 = $construction->add_point('x' => 360, 'y' => 270, hidden => 1);
    my $c3  = $construction->add_circle(center  => $p09,
					support => $p10);

    my $i2 = $construction->add_derivate('IntersectionCircleCircle',
					 input => [$c2, $c3]);
    my $p11 = $i2->create_derived_point
	(point_selector => ['indexed_point', [0]]);
    my $p12 = $i2->create_derived_point
	(point_selector => ['indexed_point', [1]]);
}

line;
intersection;
circle;
    
my $svg = $construction->as_svg(width => 800, height => 300);
    
print $svg->xmlify, "\n";
    
my $rasterize = SVG::Rasterize->new();
$rasterize->rasterize(svg => $svg);
$rasterize->write(type => 'png', file_name => 'construction.png');
