#!perl -T
use strict;
use warnings;

use Test::More tests => 20;
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

sub register_derived_point {
    my $construction = Math::Geometry::Construction->new;
    my $line;
    my $circle;
    my $ip;

    $line   = $construction->add_line(support => [[1, 2], [3, 4]]);
    $circle = $construction->add_circle(center  => [1, 0],
					support => [5, 6]);
    $ip = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$line, $circle]});

    is(scalar(grep { $_->id eq $ip->id } $line->points), 1,
       'derived point is registered');
    is(scalar(grep { $_->id eq $ip->id } $circle->points), 1,
       'derived point is registered');
}

circle_line;
register_derived_point;
