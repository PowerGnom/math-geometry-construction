package Math::Geometry::Construction::Types;
use strict;
use warnings;
use MooseX::Types -declare => ['MathVectorReal3D',
			       'Vector'];
use MooseX::Types::Moose qw/Num ArrayRef/;

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

