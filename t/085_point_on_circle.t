#!perl -T
use strict;
use warnings;

use Test::More tests => 51;
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub is_fairly_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-6), $message);
}

sub point {
    my $construction = Math::Geometry::Construction->new;

    my $circle;
    my $d;
    my $dp;
    my $pos;
    my @templates;

    $circle = $construction->add_circle(center  => [50, 50],
					support => [50, 20]);
    
    $d  = $construction->add_derivate
	('PointOnCircle', input => [$circle], quantile => 0.5);
    $dp = $d->create_derived_point
	(position_selector => ['indexed_position', [0]]);

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'position x');
    is_close($pos->[1], 80, 'position y');

    $dp = $d->create_derived_point;

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'position x');
    is_close($pos->[1], 80, 'position y');
    
    $dp = $construction->add_derived_point
	('PointOnCircle',
	 {input => [$circle], quantile => 0.75},
	 {position_selector => ['indexed_position', [0]]});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'position x');
    is_close($pos->[1], 50, 'position y');
    
    $dp = $construction->add_derived_point
	('PointOnCircle',
	 {input => [$circle], quantile => -0.25},
	 {});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'position x');
    is_close($pos->[1], 50, 'position y');
    
    $dp = $construction->add_derived_point
	('PointOnCircle',
	 {input => [$circle], quantile => 0});

    ok(defined($dp), 'derived point defined');
    isa_ok($dp, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $dp->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 50, 'position x');
    is_close($pos->[1], 20, 'position y');
    
    @templates =
	([1, 75.2441295442369, 33.7909308239558],
	 [-3, 45.766399758204, 79.6997748980134,
	  100 / 30, 44.2829611137354, 79.4502201413324]);

    foreach(@templates) {
	$dp = $construction->add_derived_point
	    ('PointOnCircle',
	     {input => [$circle], phi => $_->[0]});

	ok(defined($dp), 'derived point defined');
	$pos = $dp->position;
	ok(defined($pos), 'position defined');
	is_fairly_close
	    ($pos->[0], $_->[1],
	     sprintf('position based on phi = %.2f: x = %.2f',
		     $_->[0], $_->[1]));
	is_fairly_close
	    ($pos->[1], $_->[2],
	     sprintf('position based on phi = %.2f: y = %.2f',
		     $_->[0], $_->[2]));
    }

    @templates =
	([100, 44.2829611137354, 79.4502201413324],
	 [-200, 38.7754630828634, 22.1789689084707]);

    foreach(@templates) {
	$dp = $construction->add_derived_point
	    ('PointOnCircle',
	     {input => [$circle], distance => $_->[0]});

	ok(defined($dp), 'derived point defined');
	$pos = $dp->position;
	ok(defined($pos), 'position defined');
	is_fairly_close
	    ($pos->[0], $_->[1],
	     sprintf('position based on distance = %.2f: x = %.2f',
		     $_->[0], $_->[1]));
	is_fairly_close
	    ($pos->[1], $_->[2],
	     sprintf('position based on distance = %.2f: y = %.2f',
		     $_->[0], $_->[2]));
    }
}

point;
