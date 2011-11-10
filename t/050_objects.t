#!perl -T
use strict;
use warnings;

use Test::More tests => 43;
use Test::Exception;
use Math::Geometry::Construction;

sub order_index {
    my $construction;
    my $object;
    my @objects;

    $construction = Math::Geometry::Construction->new;
    is($construction->count_objects, 0, 'no objects to start with');

    $object = $construction->add_point(position => [0, 0]);
    is($object->order_index, 0, 'order index 0');
    is($construction->count_objects, 1, '1 object');

    @objects = ($construction->add_point(position => [0, 0]),
		$construction->add_point(position => [1, 0]));
    is($construction->count_objects, 3, '3 objects');
    $object  = $construction->add_line(support => [@objects]);
    is($object->order_index, 3, 'order index 3');
    is($construction->count_objects, 4, '4 objects');

    $object = $construction->add_line(support => [[1, 2], [3, 4]]);
    is($object->order_index, 6, 'order index 6');
    is($construction->count_objects, 7, '7 objects');    

    $object = $construction->add_circle(center  => [3, 4],
					support => [1, 2]);
    is($object->order_index, 9, 'order index 9');
    is($construction->count_objects, 10, '10 objects');    
}

sub id {
    my $construction;
    my $object;
    my @objects;

    $construction = Math::Geometry::Construction->new;

    $object = $construction->add_point(position => [5, -7]);
    is($construction->count_objects, 1, '1 object');
    is($object->id, 'P000000000', 'automatic point id');
    $object = $construction->object('P000000000');
    ok(defined($object), 'object by id defined');
    is($object->id, 'P000000000', '...and has the expected id');
    is($object->position->[0], 5, 'position x');
    is($object->position->[1], -7, 'position y');

    $object = $construction->object('L000000000');
    ok(!defined($object), 'object by invalid id undefined');

    $object = $construction->add_point(position => [6, -8]);
    is($construction->count_objects, 2, '2 objects');
    is($object->id, 'P000000001', 'automatic point id');

    $object = $construction->add_point(position => [7, -9],
				       id       => 'foo');
    is($construction->count_objects, 3, '3 objects');
    is($object->id, 'foo', 'specified point id');
    $object = $construction->object('foo');
    ok(defined($object), 'object by id defined');
    is($object->id, 'foo', '...and has the expected id');
    is($object->position->[0], 7, 'position x');
    is($object->position->[1], -9, 'position y');

    $object = $construction->add_point(position => [8, -10]);
    is($construction->count_objects, 4, '4 objects');
    is($object->id, 'P000000003', 'automatic point id keeps counting');

    $object = $construction->add_line(support => [[1, 2], [3, 4]]);
    is($construction->count_objects, 7, '7 objects');    
    is($object->id, 'L000000006', 'line id');
    $object = $construction->object('P000000004');
    ok(defined($object), 'implicit point by id defined');
    is($object->position->[0], 1, 'position x');
    is($object->position->[1], 2, 'position y');
    $object = $construction->object('P000000005');
    ok(defined($object), 'implicit point by id defined');
    is($object->position->[0], 3, 'position x');
    is($object->position->[1], 4, 'position y');

    $object = $construction->add_circle(center  => [5, 6],
					support => [7, 8]);
    is($construction->count_objects, 10, '10 objects');    
    is($object->id, 'C000000009', 'line id');
    $object = $construction->object('P000000007');
    ok(defined($object), 'implicit point by id defined');
    is($object->position->[0], 5, 'position x');
    is($object->position->[1], 6, 'position y');
    $object = $construction->object('P000000008');
    ok(defined($object), 'implicit point by id defined');
    is($object->position->[0], 7, 'position x');
    is($object->position->[1], 8, 'position y');
}

order_index;
id;
