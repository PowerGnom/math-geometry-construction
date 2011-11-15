#!perl -T
use strict;
use warnings;

use Test::More tests => 51;
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub line_line {
    my $construction = Math::Geometry::Construction->new;

    my @lines;
    my $d;
    my $ip;
    my $pos;

    @lines = ($construction->add_line(support => [[10, 30], [30, 30]]),
	      $construction->add_line(support => [[20, 10], [20, 40]]));
    
    $d  = $construction->add_derivate
	('IntersectionLineLine', input => [@lines]);
    $ip = $d->create_derived_point
	(position_selector => ['indexed_position', [0]]);

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'intersection x');
    is_close($pos->[1], 30, 'intersection y');
    
    $ip = $d->create_derived_point;

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'intersection x');
    is_close($pos->[1], 30, 'intersection y');
    
    # add_derived_point
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]},
	 {position_selector => ['indexed_position', [0]]});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'intersection x');
    is_close($pos->[1], 30, 'intersection y');
    
    # without position selector
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]},
	 {});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'intersection x');
    is_close($pos->[1], 30, 'intersection y');

    # without point args
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]});

    ok(defined($ip), 'derived point defined');
    isa_ok($ip, 'Math::Geometry::Construction::DerivedPoint');
    $pos = $ip->position;
    ok(defined($pos), 'position defined');
    isa_ok($pos, 'Math::Vector::Real');
    is(@$pos, 2, 'two components');
    is_close($pos->[0], 20, 'intersection x');
    is_close($pos->[1], 30, 'intersection y');
}

sub id {
    my $construction = Math::Geometry::Construction->new;
    my @lines;
    my $d;
    my $ip;

    @lines = ($construction->add_line(support => [[10, 30], [30, 30]]),
	      $construction->add_line(support => [[20, 10], [20, 40]]));
    is($lines[0]->id, 'L000000002', 'line id');
    is($lines[1]->id, 'L000000005', 'line id');

    $d = $construction->add_derivate
	('IntersectionLineLine', input => [@lines]);
    is($d->id, 'D000000006', 'derivate id');

    $ip = $d->create_derived_point;
    is($ip->id, 'S000000007', 'derived point id');

    $ip = $construction->add_derived_point
	('IntersectionLineLine', {input => [@lines]});
    is($ip->id, 'S000000009', 'derived point id');
    ok(defined($construction->object('D000000008')), 'derivate exists');

    $ip = $construction->add_derived_point
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
    my $ip;

    @lines = ($construction->add_line(support => [[1, 2], [3, 4]]),
	      $construction->add_line(support => [[5, 6], [7, 8]]));
    $ip = $construction->add_derived_point
	('IntersectionLineLine',
	 {input => [@lines]});

    is(scalar(grep { $_->id eq $ip->id } $lines[0]->points), 1,
       'derived point is registered');
    is(scalar(grep { $_->id eq $ip->id } $lines[1]->points), 1,
       'derived point is registered');
}

line_line;
id;
register_derived_point;
