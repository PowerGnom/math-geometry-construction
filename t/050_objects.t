#!perl -T
use strict;
use warnings;

use Test::More tests => 8;
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
}

sub id {
}

order_index;
id;
