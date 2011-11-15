#!perl -T
use strict;
use warnings;

use Test::More tests => 22;
use List::Util qw(min max);
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub circle_circle {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $c1;
    my $c2;
    my $ip;
    my @ips;
    my $pos;

    $c1 = $construction->add_circle(center => [0, 0], radius => 5);
    $c2 = $construction->add_circle(center => [0, 8], radius => 5);
    
    $ip = $construction->add_derived_point
	('IntersectionCircleCircle',
	 {input => [$c1, $c2]});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    # cannot test x because I don't know which point I got
    is_close($pos->[1], 4, 'intersection y');

    @ips = $construction->add_derived_point
	('IntersectionCircleCircle',
	 {input => [$c1, $c2]},
	 [{position_selector => ['indexed_position', [0]]},
	  {position_selector => ['indexed_position', [1]]}]);

    foreach $ip (@ips) {
	ok(defined($ip), 'derived point defined');
	isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
	$pos = $ip->position;
	ok(defined($pos), 'position defined');
	isa_ok($pos, 'Math::Vector::Real');
	is(@$pos, 2, 'two components');
	# cannot test x because I don't know which point I got
	is_close($pos->[1], 4, 'intersection y');
    }

    is_close(min(map { $_->position->[0] } @ips), -3, 'intersection x');
    is_close(max(map { $_->position->[0] } @ips), 3, 'intersection x');
}

sub register_derived_point {
    my $construction = Math::Geometry::Construction->new;
    my @circles;
    my $ip;

    @circles = ($construction->add_circle(center  => [1, 0],
					  support => [5, 6]),
		$construction->add_circle(center  => [1, 5],
					  support => [5, 9]));
    $ip = $construction->add_derived_point
	('IntersectionCircleCircle',
	 {input => [@circles]});

    is(scalar(grep { $_->id eq $ip->id } $circles[0]->points), 1,
       'derived point is registered');
    is(scalar(grep { $_->id eq $ip->id } $circles[1]->points), 1,
       'derived point is registered');
}

circle_circle;
register_derived_point;
