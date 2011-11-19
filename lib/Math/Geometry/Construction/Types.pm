package Math::Geometry::Construction::Types;
use strict;
use warnings;
use MooseX::Types -declare => ['MathVectorReal3D',
			       'Vector',
			       'Construction',
			       'GeometricObject',
			       'Point',
			       'Derivate',
			       'Draw',
			       'HashRefOfGeometricObject',
			       'ArrayRefOfGeometricObject',
			       'HashRefOfPoint',
			       'ArrayRefOfPoint'];
use MooseX::Types::Moose qw/Num ArrayRef HashRef/;

use 5.008008;

use Math::Vector::Real;
use Math::VectorReal;

=head1 NAME

C<Math::Geometry::Construction::Types> - custom types for Math::Geometry::Construction

=head1 VERSION

Version 0.019

=cut

our $VERSION = '0.019';

class_type MathVectorReal3D, {class => 'Math::VectorReal'};

subtype Vector,
    as 'Math::Vector::Real';

coerce Vector,
    from MathVectorReal3D,
    via { V($_->x, $_->y) };

coerce Vector,
    from ArrayRef[Num],
    via { V(@$_[0, 1]) };

class_type Construction, {class => 'Math::Geometry::Construction'};

role_type GeometricObject,
    {role => 'Math::Geometry::Construction::Role::Object'};

class_type Point,    {class => 'Math::Geometry::Construction::Point'};
class_type Derivate, {class => 'Math::Geometry::Construction::Derivate'};
class_type Draw,     {class => 'Math::Geometry::Construction::Draw'};

subtype HashRefOfGeometricObject,
    as HashRef[GeometricObject];

subtype ArrayRefOfGeometricObject,
    as ArrayRef[GeometricObject];

subtype HashRefOfPoint,
    as HashRef[Point];

subtype ArrayRefOfPoint,
    as ArrayRef[Point];

1;


__END__

=pod

=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

