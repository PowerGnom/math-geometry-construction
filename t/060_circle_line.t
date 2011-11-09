#!perl -T
use strict;
use warnings;

use Test::More tests => 18;
use Math::VectorReal;
use List::Util qw(min max);
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub circle_line {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $l;
    my $c;
    my $ip;
    my @ips;
    my $pos;

    $l = $construction->add_line(support => [[10, 30], [30, 30]]);
    $c = $construction->add_circle(center => [20, 30], radius => 30);
    
    $ip = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$l, $c]});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    # cannot test x because I don't know which point I got
    is_close($pos->[1], 30, 'intersection y');

    @ips = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$c, $l]},
	 [{position_selector => ['indexed_position', [0]]},
	  {position_selector => ['indexed_position', [1]]}]);

    foreach $ip (@ips) {
	ok(defined($ip), 'derived point defined');
	isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
	$pos = $ip->position;
	ok(defined($pos), 'position defined');
	isa_ok($pos, 'Math::Vector::Real');
	# cannot test x because I don't know which point I got
	is_close($pos->[1], 30, 'intersection y');
    }

    is_close(min(map { $_->position->[0] } @ips), -10, 'intersection x');
    is_close(max(map { $_->position->[0] } @ips), 50, 'intersection x');
}

circle_line;
