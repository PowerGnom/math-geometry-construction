#!perl -T
use strict;
use warnings;

use Test::More tests => 24;
use Math::Geometry::Construction;
use Math::Vector::Real;

sub construction {
    my $construction = Math::Geometry::Construction->new;

    ok(!$construction->update(0), 'default no update');
    $construction->add_point(position => [2, 3]);
    ok(!$construction->update(0), 'add point, no update');
    $construction->add_point(position => [4, -3]);
    ok(!$construction->update(2), 'add point, no update');
    ok(!$construction->update(1), 'add point, no update');
    ok(!$construction->update(0), 'add point, no update');

    $construction->register_change(1);
    ok(!$construction->update(0), 'register_change, no update for lower');
}

construction;
