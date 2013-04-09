package Math::Geometry::Construction::Vector;

use 5.008008;

use Math::Geometry::Construction::Types qw(ArrayRefOfNum
                                           MathVectorReal
                                           MathVectorReal3D
                                           Point
                                           Line);
use Moose;
use Carp;

use Math::Vector::Real;

=head1 NAME

C<Math::Geometry::Construction::Vector> - anything representing a vector

=head1 VERSION

Version 0.024

=cut

our $VERSION = '0.024';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'provider' => (isa      => ArrayRefOfNum
		             | MathVectorReal
		             | MathVectorReal3D
		             | Point
		             | Line,
		   is       => 'rw',
		   required => 1);

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub value {
    my ($self)   = @_;
    my $provider = $self->provider;
    
    croak "Undefined provider of a Vector should not be possible.\n"
	if(!defined($provider));
    return V(@$provider[0, 1])
	if(!blessed($provider) and ref($provider) eq 'ARRAY');
    return $provider            if($provider->isa('Math::Vector::Real'));
    return V($provider->x, $provider->y)
	if($provider->isa('Math::VectorReal'));
    return $provider->position
	if($provider->isa('Math::Geometry::Construction::Point'));
    return $provider->direction
	if($provider->isa('Math::Geometry::Construction::Line'));
    croak("Unknown provider type (".
	  ref($provider).
	  ") of a Vector should not be possible.\n");
}
###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

1;


__END__

=pod

=head1 DESCRIPTION

The typical user will not interact directly with this class. It
unifies the access to different sources of a vector. This can be

=over 4

=item * a reference to an array of numbers

In this case, the L<value|/value> method will return a
L<Math::Vector::Real|Math::Vector::Real> object consisting of the
first two items of the array. It is only checked if the type is the
C<Moose> type C<ArrayRef[Num]>. It is not checked if the array
contains at least two items.

=item * a L<Math::Vector::Real> object

The L<value|/value> method returns the object itself (not a clone).

=item * a L<Math::VectorReal> object

The L<value|/value> method returns an
L<Math::Vector::Real|Math::Vector::Real> object consisting of the
C<x> and C<y> component of the vector.

=item * a
L<Math::Geometry::Construction::Point|Math::Geometry::Construction::Point>
object

The L<value|/value> method returns the
L<position|Math::Geometry::Construction::Point/position> attribute
of the point.

=item * a
L<Math::Geometry::Construction::Line|Math::Geometry::Construction::Line>
object

The L<value|/value> method returns the
L<direction|Math::Geometry::Construction::Point/direction> of the
line.

=back

C<Point> and C<Line> objects are evaluated at the time you call
L<value|/value>.

=head1 INTERFACE

=head2 Constructors

=head3 new

  $vector = Math::Geometry::Construction::Vector->new
      (provider => ...)

Creates a new C<Math::Geometry::Construction::Vector> object and
initializes attributes. This is the default L<Moose|Moose>
constructor.


=head2 Public Attributes

=head3 provider

This is the only attribute. It must be set at construction time and
is readonly after that. The possible values are described in the
L<DESCRIPTION section|/DESCRIPTION>.

=head2 Methods

=head3 value

Returns a L<Math::Vector::Real|Math::Vector::Real> object as
described in the L<DESCRIPTION section|/DESCRIPTION>.


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

