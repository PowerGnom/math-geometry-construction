package Math::Geometry::Construction;

use 5.008008;

use Carp;
use Moose;
use Math::VectorReal;
use SVG;

use Math::Geometry::Construction::Point;
use Math::Geometry::Construction::Line;

use Math::Geometry::Construction::Intersection;

=head1 NAME

C<Math::Geometry::Construction> - intersecting lines and circles

=head1 VERSION

Version 0.002

=cut

our $VERSION = '0.002';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'objects' => (isa     => 'HashRef[Item]',
		  is      => 'bare',
		  traits  => ['Hash'],
		  default => sub { {} },
		  handles => {count_objects => 'count',
			      object        => 'accessor',
			      object_ids    => 'keys',
			      objects       => 'values'});

has 'width'   => (isa      => 'Int',
		  is       => 'rw',
		  required => 1);

has 'height'  => (isa      => 'Int',
		  is       => 'rw',
		  required => 1);

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub as_svg {
    my ($self, %args) = @_;
    my $svg           = SVG->new(width  => $args{width}  || $self->width,
				 height => $args{height} || $self->height);
    
    $svg->rect('x'    => 0,
	       'y'    => 0,
	       width  => $self->width,
	       height => $self->height,
	       fill   => 'white',
	       stroke => 'none');

    my @objects = sort { $a->order_index <=> $b->order_index }
        $self->objects;

    my $point_class = 'Math::Geometry::Construction::Point';
    foreach(grep { !$_->isa($point_class) } @objects) {
	$_->as_svg(parent => $svg, %args) if($_->can('as_svg'));
    }
    foreach(grep { $_->isa($point_class) } @objects) {
	$_->as_svg(parent => $svg, %args);
    }

    return $svg;
}

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

sub add_object {
    my ($self, $class, @args) = @_;

    my $object = $class->new(order_index => $self->count_objects, @args);
    $self->object($object->id, $object);

    return $object;
}

sub add_point {
    my ($self, @args) = @_;

    return $self->add_object('Math::Geometry::Construction::Point', @args);
}

sub add_line {
    my ($self, @args) = @_;

    return $self->add_object('Math::Geometry::Construction::Line', @args);
}

sub add_intersection {
    my ($self, @args) = @_;

    return $self->add_object('Math::Geometry::Construction::Intersection',
			     @args);
}

1;


__END__

=pod

=head1 SYNOPSIS

    use Math::Geometry::Construction;

    my $foo = Math::Geometry::Construction->new();


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Constructors

=head3 new

  Usage   : Math::Geometry::Construction->new(%args)
  Function: creates a new Math::Geometry::Construction object
  Returns : a Math::Geometry::Construction object
  Args    : initial attribute values as named parameters

Creates a new C<Math::Geometry::Construction> object and initializes
attributes. This is the default C<Moose|Moose> constructor.


=head2 Public Attributes

=head2 Methods for Users

=head3 add_point

=head3 add_line

=head3 add_object

=head3 add_intersection

=head3 as_svg

=head2 Methods for Subclass Developers


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

