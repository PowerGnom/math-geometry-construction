package Math::Geometry::Construction::Point;

use 5.008008;

use Moose;
use Math::VectorReal;
use Carp;

=head1 NAME

C<Math::Geometry::Construction::Point> - a free user-defined point

=head1 VERSION

Version 0.012

=cut

our $VERSION = '0.012';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

our $ID_TEMPLATE = 'P%09d';

sub id_template { return $ID_TEMPLATE }

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Role::Object';
with 'Math::Geometry::Construction::Role::Output';
with 'Math::Geometry::Construction::Role::DrawPoint';

has 'position' => (isa      => 'Math::VectorReal',
	           is       => 'rw',
	           required => 1);

sub BUILDARGS {
    my ($class, %args) = @_;

    if(defined($args{position}) and ref($args{position}) eq 'ARRAY') {
	$args{position} = vector($args{position}->[0],
				 $args{position}->[1],
				 $args{position}->[2] || 0);
    }
    if(defined($args{x}) and defined($args{y})) {
	$args{position} = vector($args{x}, $args{y}, $args{z} || 0);
    }

    return \%args;
}

sub BUILD {
    my ($self, $args) = @_;

    $self->set_default_point_style;
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub draw {
    my ($self, %args) = @_;
    return undef if $self->hidden;

    my $position = $self->position;
    my $size     = $self->size;
    my $radius   = defined($size) ? $size / 2 : $self->radius;
    $self->construction->draw_circle(cx    => $position->x,
				     cy    => $position->y,
				     r     => $radius,
				     style => $self->style_hash,
				     id    => $self->id);

    $self->draw_label('x' => $position->x,
		      'y' => $position->y);

    return undef;
}

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

1;


__END__

=pod

=head1 SYNOPSIS

  my $p1 = $construction->add_point('x' => 100, 'y' => 150);

  my $p2 = $construction->add_point('x' => 50, 'y' => 90,
                                    hidden => 1);

  my $p3 = $construction->add_point('x' => 70, 'y' => 130,
                                    style          => {stroke => 'red'},
                                    label          => 'A',
	                            label_offset_x => 5,
	                            label_offset_y => -5);


=head1 DESCRIPTION

An instance of this class represents a user defined free point, as
opposed to a derived point, e.g. an intersection point. An instance
of this class got its position directly from the user. It is created
by using the L<add_point
method|Math::Geometry::Construction/add_point> of
C<Math::Geometry::Construction>.

=head1 INTERFACE

=head2 Public Attributes

=head3 position

Holds a L<Math::VectorReal|Math::VectorReal> object with the
position of the point. The C<z> position is expected to be C<0>. As
initialization argument to the constructor, you can also give an
array reference instead of a C<Math::VectorReal> object. The object
is then created by the constructor. The C<z> value is optional.

Example:

  $construction->add_point(position => [1, 4]);

Note that the conversion of a array reference is only done at
construction time (at least currently). If you want to change the
position later you have to provide a
L<Math::VectorReal|Math::VectorReal> object.

=head3 size

A point is currently always drawn as a circle. This might become
more flexible in the future. C<size> determines the size of the
point in the output. For a circle it is its diameter. This parameter
is currently C<undef> by default, because the output falls back to
L<radius|/radius> (see below). When C<radius> is removed, C<size>
will default to C<6>.

=head3 radius

This attribute is deprecated and might be removed in a future
version. If L<size|/size> is not set then this attribute determines
the radius of the output circle. Defaults to C<3>.

=head2 General Output Attributes

See
L<Math::Geometry::Construction::Output|Math::Geometry::Construction::Output>.

=head2 Methods

=head3 draw

Called by the C<Construction> object during output generation.
Currently draws a circle of diameter L<size|/size>, but this might
become more flexible in the future.

=head3 id_template

Class method returning C<$ID_TEMPLATE>, which defaults to C<'P%09d'>.

=head1 DIAGNOSTICS

=head2 Exceptions

=head2 Warnings


=head1 BUGS AND LIMITATIONS

No bugs have been reported. Please report all bugs directly to the author.


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

