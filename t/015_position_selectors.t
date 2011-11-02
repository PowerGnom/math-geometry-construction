#!perl -T
use strict;
use warnings;

use Test::More tests => 47;
use Math::Geometry::Construction;
use Math::VectorReal;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub indexed_position {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $l;
    my $c;
    
    $l = $construction->add_line(support => [[10, 20], [30, 20]]);
    $c = $construction->add_circle(center => [20, 20], radius => 100);

=for later


    my @ipp = sort { $a->x <=> $b->x }
              map  { $_->position    }
              $construction->add_derived_points
		  ('IntersectionCircleLine',
		   {input => [$l, $c]},
		   [{position_selector => ['indexed_point', [0]]},
		    {position_selector => ['indexed_point', [1]]}]);
    
    is_close($ipp[0]->x, -80, 'left x');

=cut

}

indexed_position;
