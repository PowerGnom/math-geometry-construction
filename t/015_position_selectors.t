#!perl -T
use strict;
use warnings;

use Test::More tests => 47;
use Math::Geometry::Construction;
use Math::VectorReal;

sub indexed_position {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $l;
    my $c;
    
    $l = $construction->add_line(support => [[10, 20], [30, 20]]);
    $c = $construction->add_circle(center => [20, 20], radius => 100);
}

indexed_position;
