package Math::Geometry::Construction::Types;
use strict;
use warnings;
use MooseX::Types -declare => ['ArrayRefOfNum',
			       'Vector',
			       'MathVectorReal',
			       'MathVectorReal3D',
			       'Point',
			       'Line',
			       'Construction',
			       'GeometricObject',
			       'Derivate',
			       'Draw',
			       'HashRefOfGeometricObject',
			       'ArrayRefOfGeometricObject',
			       'HashRefOfPoint',
			       'ArrayRefOfPoint',
			       'Extension'];
use MooseX::Types::Moose qw/Num ArrayRef HashRef/;

use 5.008008;

use Math::Vector::Real;
use Math::VectorReal;

=head1 NAME

C<Math::Geometry::Construction::Types> - custom types for Math::Geometry::Construction

=head1 VERSION

Version 0.024

=cut

our $VERSION = '0.024';

subtype ArrayRefOfNum,
    as ArrayRef[Num];

class_type Vector, {class => 'Math::Geometry::Construction::Vector'};
class_type MathVectorReal,   {class => 'Math::Vector::Real'};
class_type MathVectorReal3D, {class => 'Math::VectorReal'};
class_type Point,  {class => 'Math::Geometry::Construction::Point'};
class_type Line,   {class => 'Math::Geometry::Construction::Line'};

# coerce into Vector
coerce Vector,
    from ArrayRef[Num],
    via { Vector->new(provider => $_) };

coerce Vector,
    from MathVectorReal,
    via { Vector->new(provider => $_) };

coerce Vector,
    from MathVectorReal3D,
    via { Vector->new(provider => $_) };

coerce Vector,
    from Point,
    via { Vector->new(provider => $_) };

coerce Vector,
    from Line,
    via { Vector->new(provider => $_) };

# coerce into Point
coerce Point,
    from Vector,
    via { Point->new(position => $_, hidden => 1) };

coerce Point,
    from ArrayRefOfNum,
    via { Point->new(position => $_, hidden => 1) };

coerce Point,
    from MathVectorReal,
    via { Point->new(position => $_, hidden => 1) };

coerce Point,
    from MathVectorReal3D,
    via { Point->new(position => $_, hidden => 1) };

coerce Point,
    from Line,
    via { Point->new(position => $_, hidden => 1) };

class_type Construction, {class => 'Math::Geometry::Construction'};

role_type GeometricObject,
    {role => 'Math::Geometry::Construction::Role::Object'};

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

subtype Extension,
    as ArrayRef[Num];

coerce Extension,
    from Num,
    via { [$_, $_] };

1;


__END__

=pod

=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011-2013 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

