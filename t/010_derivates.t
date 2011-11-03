#!perl -T
use strict;
use warnings;

use Test::More tests => 52;
use Math::VectorReal;
use List::Util qw(min max);
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub line_line {
    my $construction = Math::Geometry::Construction->new(width  => 800,
							 height => 300);

    my $l1;
    my $l2;
    my $ip;
    my $pos;

    $l1 = $construction->add_line(support => [[10, 30], [30, 30]]);
    $l2 = $construction->add_line(support => [[20, 10], [20, 40]]);
    
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [$l1, $l2]},
	 {position_selector => ['indexed_position', [0]]});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::VectorReal');
    is_close($pos->x, 20, 'intersection x');
    is_close($pos->y, 30, 'intersection y');
    
    # without position selector
    $l1 = $construction->add_line(support => [[110, 130], [130, 130]]);
    $l2 = $construction->add_line(support => [[120, 110], [120, 140]]);
    
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [$l1, $l2]},
	 {style => {stroke => 'red'}});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::VectorReal');
    is_close($pos->x, 120, 'intersection x');
    is_close($pos->y, 130, 'intersection y');
    
    # without point_args
    $l1 = $construction->add_line(support => [[210, 230], [230, 230]]);
    $l2 = $construction->add_line(support => [[220, 210], [220, 240]]);
    
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [$l1, $l2]});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::VectorReal');
    is_close($pos->x, 220, 'intersection x');
    is_close($pos->y, 230, 'intersection y');
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
    isa_ok($pos, 'Math::VectorReal');
    # cannot test x because I don't know which point I got
    is_close($pos->y, 30, 'intersection y');

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
	isa_ok($pos, 'Math::VectorReal');
	# cannot test x because I don't know which point I got
	is_close($pos->y, 30, 'intersection y');
    }

    is_close(min(map { $_->position->x } @ips), -10, 'intersection x');
    is_close(max(map { $_->position->x } @ips), 50, 'intersection x');
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
    isa_ok($pos, 'Math::VectorReal');
    # cannot test x because I don't know which point I got
    is_close($pos->y, 4, 'intersection y');

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
	isa_ok($pos, 'Math::VectorReal');
	# cannot test x because I don't know which point I got
	is_close($pos->y, 4, 'intersection y');
    }

    is_close(min(map { $_->position->x } @ips), -3, 'intersection x');
    is_close(max(map { $_->position->x } @ips), 3, 'intersection x');
}

line_line;
circle_line;
circle_circle;
