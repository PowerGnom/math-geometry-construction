#!perl -T
use strict;
use warnings;

use Test::More tests => 29;
use List::Util qw(min max);
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub position_ok {
    my ($pos, $x, $y) = @_;

    ok(defined($pos), 'position is defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'position has 2 components');

    if(defined($x)) {
	is($pos->[0], $x, "x coordinate is $x");
    }
    if(defined($y)) {
	is($pos->[1], $y, "y coordinate is $y");
    }
}

sub derived_point_ok {
    my ($dp, $x, $y) = @_;

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    position_ok($dp->position, $x, $y);
}

sub circle_line {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);
    my $l;
    my $c;
    my $dp;
    my @dps;

    $l = $construction->add_line(support => [[10, 30], [30, 30]]);
    $c = $construction->add_circle(center => [20, 30], radius => 30);
    
    $dp = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$l, $c]});
    # cannot test x because I don't know which point I got
    derived_point_ok($dp, undef, 30);

    @dps = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$c, $l]},
	 [{position_selector => ['indexed_position', [0]]},
	  {position_selector => ['indexed_position', [1]]}]);

    foreach $dp (@dps) { derived_point_ok($dp, undef, 30) }

    is_close(min(map { $_->position->[0] } @dps), -10, 'intersection x');
    is_close(max(map { $_->position->[0] } @dps), 50, 'intersection x');
}

sub register_derived_point {
    my $construction = Math::Geometry::Construction->new;
    my $line;
    my $circle;
    my $dp;

    $line   = $construction->add_line(support => [[1, 2], [3, 4]]);
    $circle = $construction->add_circle(center  => [1, 0],
					support => [5, 6]);
    $dp = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$line, $circle]});

    is(scalar(grep { $_->id eq $dp->id } $line->points), 1,
       'derived point is registered');
    is(scalar(grep { $_->id eq $dp->id } $circle->points), 1,
       'derived point is registered');
}

sub overloading {
    my $construction = Math::Geometry::Construction->new;

    my $line;
    my $circle;
    my $dp;

    $line = $construction->add_line(support => [[10, 30], [30, 30]]);
    $circle = $construction->add_circle(center => [20, 30], radius => 30);
    
    $dp = $line x $circle;
    derived_point_ok($dp, -10, 30);
}

circle_line;
register_derived_point;
overloading;
