#!perl -T
use strict;
use warnings;

use Test::More tests => 50;
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

sub id {
    my $construction = Math::Geometry::Construction->new;
    my $line;
    my $circle;
    my $d;
    my $dp;

    $line = $construction->add_line(support => [[10, 30], [30, 30]]);
    $circle = $construction->add_circle(center  => [20, 30],
					support => [20, 60]);
    is($line->id, 'L000000002', 'line id');
    is($circle->id, 'C000000005', 'line id');

    $d = $construction->add_derivate
	('IntersectionCircleLine', input => [$line, $circle]);
    is($d->id, 'D000000006', 'derivate id');

    $dp = $d->create_derived_point;
    is($dp->id, 'S000000007', 'derived point id');

    $dp = $construction->add_derived_point
	('IntersectionCircleLine', {input => [$circle, $line]});
    is($dp->id, 'S000000009', 'derived point id');
    ok(defined($construction->object('D000000008')), 'derivate exists');

    $dp = $construction->add_derived_point
	('IntersectionCircleLine',
	 {input => [$construction->add_line(support => [[1, 2], [3, 4]]),
		    $construction->add_circle(support => [5, 6],
					      center  => [7, 8])]});
    foreach('P000000010',
	    'P000000011',
	    'L000000012',
	    'P000000013',
	    'P000000014',
	    'C000000015',
	    'D000000016',
	    'S000000017')
    {
	ok(defined($construction->object($_)), "$_ defined");
    }
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
    
    $dp = $circle x $line;
    derived_point_ok($dp, -10, 30);
}

circle_line;
id;
register_derived_point;
overloading;
