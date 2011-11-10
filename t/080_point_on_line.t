#!perl -T
use strict;
use warnings;

use Test::More tests => 56;
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

=for later

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

=cut

}

line_line;
id;
