#!perl -T
use strict;
use warnings;

use Test::More tests => 20;
use Test::Exception;
use Math::Geometry::Construction::Vector;
use Math::Vector::Real;
use Math::VectorReal;

sub construction {
    my $vector;
    my $value;
    my @template;

    dies_ok(sub { Math::Geometry::Construction::Vector->new },
	    'provider is mandatory');
    dies_ok(sub { Math::Geometry::Construction::Vector->new(1) },
	    '1 is not a valid provider');

    @template = ([[3, 5], [3, 5]],
		 [V(4, 6), [4, 6]],
		 [vector(5, 7, 1), [5, 7]]);

    foreach(@template) {
	$vector = Math::Geometry::Construction::Vector->new
	    (provider => $_->[0]);
	ok(defined($vector), 'vector is defined');
	isa_ok($vector, 'Math::Geometry::Construction::Vector');
	$value = $vector->value;
	ok(defined($value), 'value is defined');
	isa_ok($value, 'Math::Vector::Real');
	is($value->[0], $_->[1]->[0], 'x = '.$_->[1]->[0]);
	is($value->[1], $_->[1]->[1], 'y = '.$_->[1]->[1]);
    }
}

construction;
