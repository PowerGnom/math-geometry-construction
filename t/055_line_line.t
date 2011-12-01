#!perl -T
use strict;
use warnings;

use Test::More tests => 65;
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

sub line_line {
    my $construction = Math::Geometry::Construction->new;
    my @lines;
    my $d;
    my $dp;

    @lines = ($construction->add_line(support => [[10, 30], [30, 30]]),
	      $construction->add_line(support => [[20, 10], [20, 40]]));
    
    $d  = $construction->add_derivate
	('IntersectionLineLine', input => [@lines]);
    $dp = $d->create_derived_point
	(position_selector => ['indexed_position', [0]]);
    derived_point_ok($dp, 20, 30);

    $dp = $d->create_derived_point;
    derived_point_ok($dp, 20, 30);

    $dp = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]},
	 {position_selector => ['indexed_position', [0]]});
    derived_point_ok($dp, 20, 30);

    $dp = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]},
	 {});
    derived_point_ok($dp, 20, 30);

    $dp = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]});
    derived_point_ok($dp, 20, 30);
}

sub id {
    my $construction = Math::Geometry::Construction->new;
    my @lines;
    my $d;
    my $dp;

    @lines = ($construction->add_line(support => [[10, 30], [30, 30]]),
	      $construction->add_line(support => [[20, 10], [20, 40]]));
    is($lines[0]->id, 'L000000002', 'line id');
    is($lines[1]->id, 'L000000005', 'line id');

    $d = $construction->add_derivate
	('IntersectionLineLine', input => [@lines]);
    is($d->id, 'D000000006', 'derivate id');

    $dp = $d->create_derived_point;
    is($dp->id, 'S000000007', 'derived point id');

    $dp = $construction->add_derived_point
	('IntersectionLineLine', {input => [@lines]});
    is($dp->id, 'S000000009', 'derived point id');
    ok(defined($construction->object('D000000008')), 'derivate exists');

    $dp = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [$construction->add_line(support => [[1, 2], [3, 4]]),
		    $construction->add_line(support => [[5, 6], [7, 8]])]});
    foreach('P000000010',
	    'P000000011',
	    'L000000012',
	    'P000000013',
	    'P000000014',
	    'L000000015',
	    'D000000016',
	    'S000000017')
    {
	ok(defined($construction->object($_)), "$_ defined");
    }
}

sub register_derived_point {
    my $construction = Math::Geometry::Construction->new;
    my @lines;
    my $dp;

    @lines = ($construction->add_line(support => [[1, 2], [3, 4]]),
	      $construction->add_line(support => [[5, 6], [7, 8]]));
    $dp = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]});

    is(scalar(grep { $_->id eq $dp->id } $lines[0]->points), 1,
       'derived point is registered');
    is(scalar(grep { $_->id eq $dp->id } $lines[1]->points), 1,
       'derived point is registered');
}

sub overloading {
    my $construction = Math::Geometry::Construction->new;

    my @lines;
    my $dp;
    my $pos;

    @lines = ($construction->add_line(support => [[10, 30], [30, 30]]),
	      $construction->add_line(support => [[20, 10], [20, 40]]));
    
    $dp = $lines[0] x $lines[1];
    derived_point_ok($dp, 20, 30);
        
    $dp = $lines[1] x $lines[0];
    derived_point_ok($dp, 20, 30);
}

line_line;
id;
register_derived_point;
overloading;
