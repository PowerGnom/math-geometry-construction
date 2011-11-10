#!perl -T
use strict;
use warnings;

use Test::More tests => 21;
use List::Util qw(min max);
use Math::Geometry::Construction;

sub is_close {
    my ($value, $reference, $message, $limit) = @_;

    cmp_ok(abs($value - $reference), '<', ($limit || 1e-12), $message);
}

sub line_line {
    my $construction = Math::Geometry::Construction->new;

    my @lines;
    my $ip;
    my $pos;

    @lines = ($construction->add_line(support => [[10, 30], [30, 30]]),
	      $construction->add_line(support => [[20, 10], [20, 40]]));
    
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
}

line_line;
id;
