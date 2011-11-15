#!perl -T
use strict;
use warnings;

use Test::More tests => 67;
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub line_line {
    my $construction = Math::Geometry::Construction->new;

    my $line;
    my $d;
    my $dp;
    my $pos;

    $line = $construction->add_line(support => [[10, 30], [90, 90]]);
    
    $d  = $construction->add_derivate
	('PointOnLine', input => [$line], distance => 50);
    $dp = $d->create_derived_point
	(position_selector => ['indexed_position', [0]]);

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'intersection x');
    is_close($pos->[1], 60, 'intersection y');
    
    $dp = $d->create_derived_point;

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'intersection x');
    is_close($pos->[1], 60, 'intersection y');
    
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], distance => 50},
	 {position_selector => ['indexed_position', [0]]});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'intersection x');
    is_close($pos->[1], 60, 'intersection y');
    
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], distance => 50},
	 {});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'intersection x');
    is_close($pos->[1], 60, 'intersection y');
    
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], distance => 50});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'intersection x');
    is_close($pos->[1], 60, 'intersection y');
    
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], quantile => 1.5});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 130, 'intersection x');
    is_close($pos->[1], 120, 'intersection y');
    
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], x => 90});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 90, 'intersection x');
    is_close($pos->[1], 90, 'intersection y');
    
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], 'y' => 120});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 130, 'intersection x');
    is_close($pos->[1], 120, 'intersection y');
}

sub id {
    my $construction = Math::Geometry::Construction->new;
    my $line;
    my $d;
    my $dp;

    $line = $construction->add_line(support => [[10, 30], [30, 30]]);
    is($line->id, 'L000000002', 'line id');

    $d = $construction->add_derivate
	('PointOnLine', input => [$line], quantile => 0.5);
    is($d->id, 'D000000003', 'derivate id');

    $dp = $d->create_derived_point;
    is($dp->id, 'S000000004', 'derived point id');

    $dp = $construction->add_derived_point
	('PointOnLine', {input => [$line], distance => 10});
    is($dp->id, 'S000000006', 'derived point id');
    ok(defined($construction->object('D000000005')), 'derivate exists');

    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$construction->add_line(support => [[1, 2], [3, 4]])],
	  'y'   => 20});
    foreach('P000000007',
	    'P000000008',
	    'L000000009',
	    'D000000010',
	    'S000000011')
    {
	ok(defined($construction->object($_)), "$_ defined");
    }
}

sub register_derived_point {
    my $construction = Math::Geometry::Construction->new;
    my $line;
    my $dp;

    $line = $construction->add_line(support => [[1, 2], [3, 4]]);
    $dp = $construction->add_derived_point
	('PointOnLine',
	 {input => [$line], quantile => 0.3});

    is(scalar(grep { $_->id eq $dp->id } $line->points), 1,
       'derived point is registered');
}

line_line;
id;
register_derived_point;
