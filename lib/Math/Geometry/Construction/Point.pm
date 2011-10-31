package Math::Geometry::Construction::Point;

use 5.008008;

use Moose;
use Math::VectorReal;
use Carp;

=head1 NAME

C<Math::Geometry::Construction::Point> - a free user-defined point

=head1 VERSION

Version 0.009

=cut

our $VERSION = '0.009';


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

with 'Math::Geometry::Construction::Object';
with 'Math::Geometry::Construction::Output';

has 'position' => (isa      => 'Math::VectorReal',
	           is       => 'rw',
	           required => 1);

has 'size'     => (isa     => 'Num',
	           is      => 'rw');

has 'radius'   => (isa     => 'Num',
	           is      => 'rw',
		   trigger => \&_radius_trigger,
	           default => 3);

sub _radius_trigger {
    warn("The 'radius' attribute of Math::Geometry::Construction::Point ".
	 "is deprecated and might be removed in a future version. Use ".
	 "'size' with the double value (diameter of the circle) ".
	 "instead.\n");
}

sub BUILDARGS {
    my ($class, %args) = @_;

    if(defined($args{x}) and defined($args{y})) {
	$args{position} = vector($args{x}, $args{y}, $args{z} || 0);
    }

    return \%args;
}

sub BUILD {
    my ($self, $args) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));
    $self->style('fill', 'white')   unless($self->style('fill'));
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
initialization arguments to the constructor, you can give C<x> and
C<y> with numerical values instead of position with a
C<Math::VectorReal> value. The object is then created by the
constructor.

=head3 size

A point is currently always drawn as a circle. This might become
more flexible in the future. C<size> determines the size of the
point in the output. For a circle it is its diameter.

=head3 radius

This attribute is deprecated and might be removed in a future
version. If L<size|/size> is not set then this attribute determines
the radius of the output circle.

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

