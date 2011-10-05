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
    #$l1->style('stroke', 'red');
}

sub intersection {
    my $p1 = $construction->add_point('x' => 100, 'y' => 150);
    my $p2 = $construction->add_point('x' => 300, 'y' => 150);
    my $p3 = $construction->add_point('x' => 200, 'y' => 50);
    my $p4 = $construction->add_point('x' => 200, 'y' => 250);

    my $l1 = $construction->add_line;
    $l1->add_support($p1);
    $l1->add_support($p2);
    my $l2 = $construction->add_line;
    $l2->add_support($p3);
    $l2->add_support($p4);

    my $i1 = $construction->add_intersection(intersectants => [$l1, $l2]);
    my $p5 = $i1->create_intersection_point(method => 'indexed_point',
					    params => [0]);
}

line;
intersection;
    
my $svg = $construction->as_svg(width => 800, height => 300);
    
print $svg->xmlify, "\n";
    
my $rasterize = SVG::Rasterize->new();
$rasterize->rasterize(svg => $svg);
$rasterize->write(type => 'png', file_name => 'construction.png');
