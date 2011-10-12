package Math::Geometry::Construction;

use 5.008008;

use Carp;
use Moose;
use Math::VectorReal;
use SVG;

use Math::Geometry::Construction::Point;
use Math::Geometry::Construction::Line;
use Math::Geometry::Construction::DerivedPoint;

=head1 NAME

C<Math::Geometry::Construction> - intersecting lines and circles

=head1 VERSION

Version 0.004

=cut

our $VERSION = '0.004';


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

    foreach(grep { ref($_) !~ /Point$/ } @objects) {
	$_->as_svg(parent => $svg, %args) if($_->can('as_svg'));
    }
    foreach(grep { ref($_) =~ /Point$/ } @objects) {
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

    my $object = $class->new(order_index  => $self->count_objects, 
			     construction => $self,
			     @args);
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

1;


__END__

=pod

=head1 SYNOPSIS

  use Math::Geometry::Construction;
  use Math::Geometry::Construction::Derivate::IntersectionLineLine;

  my $construction = Math::Geometry::Construction->new
      (width  => 500, height => 300);
  my $p1 = $construction->add_point('x' => 100, 'y' => 150, hidden => 1);
  my $p2 = $construction->add_point('x' => 120, 'y' => 150, hidden => 1);
  my $p3 = $construction->add_point('x' => 200, 'y' => 50);
  my $p4 = $construction->add_point('x' => 200, 'y' => 250);

  my $l1 = $construction->add_line(extend         => 10,
				     label          => 'g',
				     label_offset_y => 13);
  $l1->add_support($p1);
  $l1->add_support($p2);
  my $l2 = $construction->add_line;
  $l2->add_support($p3);
  $l2->add_support($p4);

  my $i1 = $construction->add_object
	('Math::Geometry::Construction::Derivate::IntersectionLineLine',
	 input => [$l1, $l2]);
  my $p5 = $i1->create_derived_point
	(point_selector => ['indexed_point', [0]],
	 label          => 'S',
	 label_offset_x => 5,
	 label_offset_y => -5);

  print $construction->as_svg(width => 800, height => 300)->xmlify;

=head1 DESCRIPTION


=head1 INTERFACE

=head2 Constructors

=head3 new

  $construction = Math::Geometry::Construction->new(%args)

Creates a new C<Math::Geometry::Construction> object and initializes
attributes. This is the default C<Moose|Moose> constructor.


=head2 Public Attributes

=head2 Methods

=head3 add_point

=head3 add_line

=head3 add_object

=head3 as_svg


=head1 DIAGNOSTICS

=head2 Exceptions

=head2 Warnings


=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-math-geometry-construction at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Geometry-Construction>.
I will be notified, and then you will automatically be notified of
progress on your bug as I make changes.


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

