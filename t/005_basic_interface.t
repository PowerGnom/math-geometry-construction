#!perl -T

use Test::More tests => 6;
use Math::Geometry::Construction;
use Math::VectorReal;

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

line;
