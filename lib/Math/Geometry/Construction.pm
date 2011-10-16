package Math::Geometry::Construction;

use 5.008008;

use Carp;
use Moose;
use Math::VectorReal;
use SVG;

use Math::Geometry::Construction::Point;
use Math::Geometry::Construction::Line;
use Math::Geometry::Construction::Circle;
use Math::Geometry::Construction::DerivedPoint;

=head1 NAME

C<Math::Geometry::Construction> - intersecting lines and circles

=head1 VERSION

Version 0.006

=cut

our $VERSION = '0.006';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'objects'    => (isa     => 'HashRef[Item]',
		     is      => 'bare',
		     traits  => ['Hash'],
		     default => sub { {} },
		     handles => {count_objects => 'count',
				 object        => 'accessor',
				 object_ids    => 'keys',
				 objects       => 'values'});

has 'background' => (isa => 'Str',
		     is  => 'rw');

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub as_svg {
    my ($self, %args) = @_;

    my $svg = SVG->new(%args);

    # draw background rectangle if possible
    if(my $bg = $self->background) {
	my $x;
	my $y;
	my $width;
	my $height;
	if($args{viewBox}) {
	    my $f = '[^\s\,]+';
	    my $w = '(?:\s+|\s*\,\*)';
	    if($args{viewBox} =~ /^\s*($f)$w($f)$w($f)$w($f)\s*$/) {
		($x, $y, $width, $height) = ($1, $2, $3, $4);
	    }
	    else { warn "Failed to parse viewBox attribute.\n"  }
	}
	else {
	    ($x, $y, $width, $height) =
		(0, 0, $args{width}, $args{height});
	}
	if($width and $height) {
	    $svg->rect('x' => $x, 'y' => $y,
		       width => $width, height => $height,
		       stroke => 'none', fill => $bg);
	}
    }
    
    my @objects = sort { $a->order_index <=> $b->order_index }
        $self->objects;

    my %is_point = ('Math::Geometry::Construction::Point'        => 1,
		    'Math::Geometry::Construction::DerivedPoint' => 1);
    foreach(grep { !$is_point{blessed($_)} } @objects) {
	$_->as_svg(parent => $svg, %args) if($_->can('as_svg'));
    }
    foreach(grep { $is_point{blessed($_)} } @objects) {
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

sub add_circle {
    my ($self, @args) = @_;

    return $self->add_object('Math::Geometry::Construction::Circle',
			     @args);
}

sub add_derivate {
    my ($self, $class, @args) = @_;

    return $self->add_object
	('Math::Geometry::Construction::Derivate::'.$class, @args);
}

1;


__END__

=pod

=head1 SYNOPSIS

  use Math::Geometry::Construction;

  my $construction = Math::Geometry::Construction->new
      (background => 'white');
  my $p1 = $construction->add_point('x' => 100, 'y' => 150, hidden => 1);
  my $p2 = $construction->add_point('x' => 120, 'y' => 150, hidden => 1);
  my $p3 = $construction->add_point('x' => 200, 'y' => 50);
  my $p4 = $construction->add_point('x' => 200, 'y' => 250);

  my $l1 = $construction->add_line(extend         => 10,
                                   label          => 'g',
				   label_offset_y => 13,
				   support        => [$p1, $p2]);
  my $l2 = $construction->add_line(support => [$p3, $p4]);

  my $i1 = $construction->add_derivate('IntersectionLineLine',
                                       input => [$l1, $l2]);
  my $p5 = $i1->create_derived_point
	(position_selector => ['indexed_position', [0]],
	 label             => 'S',
	 label_offset_x    => 5,
	 label_offset_y    => -5);

  print $construction->as_svg(width => 800, height => 300)->xmlify;


=head1 DESCRIPTION

This is alpha software. The API is likely to change, input checks
and documentation are sparse, the test suite barely exists. But
release early, release often, so here we go.

=head2 Aims

This distribution serves two purposes:

=over 4

=item * Carrying out geometric constructions like with compass and
straight edge. You can define points, lines through two points, and
(in the future) circles around a given center and through a given
point. You can let these objects intersect to gain new points to
work with.

=item * Creating illustrations for geometry. This task is similar to
the one above, but not the same. For illustrations, the priorities
are usually different and more powerful tools like choosing a point
on a given object, drawing circles with fixed radius etc. are handy.

=back

=head2 Motivation

Problems of these kinds can be solved using several pieces of
geometry software. However, I have not found any with sufficiently
powerful automization features. This problem has two aspects:

=over 4

=item * For some project, I want to create many illustrations. I
have certain rules for the size of output images, usage of colors
etc.. With the programs I have used so far, I have found it
difficult to set these things in a consistent way for all of my
illustrations without the need to set them each time I start the
program or to change consistently later on.

=item * For actual constructions, most macro languages are not
powerful enough. For example, the intersection between two circles
sometimes yields two points. There are situations where I want to
choose the one which is further away from some given point or the
one which is not the one I already had before or things like
that. The macro languages of most geometry programs do not allow
that. It is somehow determined internally which one is first
intersection point and which the second, so from the user point of
view the choice is arbitrary. Or, for example, I have come across
the situation where I needed to double an angle iteratively until it
becomes larger than a given angle. Impossible in most macro
languates. With this module, you have Perl as your "macro language".

=back

=head2 Intersection Concept

Intersecting two objects consists of two steps. First, you create a
L<Math::Geometry::Construction::Derivate|Math::Geometry::Construction::Derivate>
object that holds the intersecting partners and "knows" how to
calculate the intersection points. Second, you create a
L<Math::Geometry::Construction::DerivedPoint|Math::Geometry::Construction::DerivedPoint>
from the C<Derivate>. The C<DerivedPoint> object holds information
about which of the intersection points to use. This can be based
distance to a given point, being the extreme point with respect to a
given direction etc..

The C<DerivedPoint> object only holds information about how to
select the right point. Only when you actually ask for the position
of the point it is actually calculated.

The classes are called C<Derivate> and C<DerivedPoint> because this
concept is applicable beyond the case of intersections. It could,
for example, be used to calculate the center of a circle given by
three points. Whenever some operation based on given objects results
in a finite number of points, it fits into this concept.

=head2 Output

Each line or similar object holds a number of "points of
interest". These are - in case of the line - the two points that
define the line and all intersection points the line is involved
in. At drawing time, the object determines the most extreme points
and they define the end points of the drawn line segment. The
C<extend> attribute allows to extend the line for a given length
beyond these points because this often looks better. A similar
concept will be implemented for circles, but currently, the full
circle is drawn.

Currently, the only output format is C<SVG>. I plan to implement
C<LaTeX> output based on C<PGF/TikZ>, but I will have to learn how
to use that package first.

Eventually, the output generation should be based on some kind of
plugin interface that allows to implement other output
formats. Therefore, everything concerned with output generation is
particularly prone to future API changes.

=head2 Current Status

At the moment, you can define points, lines, and circles. You can
intersect circles and lines with each other. The objects can have
labels, but the automatic positioning of the labels is very
primitive and unsatisfactory withouth polishing by the user.

=head2 Next Steps

=over 4

=item * Extend documentation

=item * Improve performance

=item * Improve automatic positioning of labels

=item * Improve test suite along the way

=back

=head1 INTERFACE

=head2 Constructors

=head3 new

  $construction = Math::Geometry::Construction->new(%args)

Creates a new C<Math::Geometry::Construction> object and initializes
attributes. This is the default L<Moose|Moose> constructor.


=head2 Public Attributes

=head3 background

By default the background is transparent. This attribute can hold a
color to hold instead. Possible values depend on the output
type. For C<SVG>, it can hold any valid C<SVG> color specifier,
e.g. C<white> or C<rgb(255, 255, 255)>.

=head3 objects

A construction holds a hash of the objects it contains. The hash
itself is inaccessible. However, you can call the following
accessors:

=over 4

=item * count_objects

Returns the number of objects. For the L<Moose|Moose> aficionado:
This is the C<count> method of the C<Hash> trait.

=item * object

  $construction->object($key)
  $construction->object($key, $value)

Accessor/mutator method for single entries of the hash. The keys are
the object IDs. Usage of the mutator is not intended, use only to
tamper with the internals at your own risk.

This is the C<accessor> method of the C<Hash> trait.

=item * object_ids

Returns a (copy of) the list of keys. This is the C<keys> method of
the C<Hash> trait.

=item * objects

Returns a (copy of) the list of values. This is the C<values> method
of the C<Hash> trait.

=back

=head2 Methods

=head3 add_point

  $construction->add_point(%args)

Returns a new
L<Math::Geometry::Construction::Point|Math::Geometry::Construction::Point>.
All parameters are handed over to the constructor after adding the
C<construction> and C<order_index> arguments.

=head3 add_line

  $construction->add_line(%args)

Returns a new
L<Math::Geometry::Construction::Line|Math::Geometry::Construction::Line>.
All parameters are handed over to the constructor after adding the
C<construction> and C<order_index> arguments.

=head3 add_circle

  $construction->add_circle(%args)

Returns a new
L<Math::Geometry::Construction::Circle|Math::Geometry::Construction::Circle>.
All parameters are handed over to the constructor after adding the
C<construction> and C<order_index> arguments.

=head3 add_object

  $construction->add_object($class, %args)

Returns a new instance of the given class. All parameters are handed
over to the constructor after adding the C<construction> and
C<order_index> arguments. In fact, L<add_point|/add_point>,
L<add_line|/add_line>, and L<add_circle|/add_circle> just call this
method with the appropriate class.

=head3 add_derivate

  $constructor->add_derivate($class, %args)

Convenience shortcut for L<add_object|/add_object>. The only
difference is that C<$class> is prepended with
C<Math::Geometry::Construction::Derivate::>. Therefore you can call

  $construction->add_derivate('IntersectionCircleLine', %args)

instead of

  $construction->add_object
      ('Math::Geometry::Construction::Derivate::IntersectionCircleLine', %args)


=head3 as_svg

  $construction->as_svg(%args)

Returns an L<SVG|SVG> object representing the construction. All
parameters are handed over to the L<SVG|SVG> constructor. At least
C<width> and C<height> should be provided.

If a L<background color|/background> is specified then a rectangle
of of that color is drawn as background. The size is taken from the
C<viewBox> attribute if specified, from C<width> and C<height>
otherwise. If none is given, no background is drawn.

Calls the C<as_svg> method first on all non-point objects, then on
all C<Point> and C<DerivedPoint> objects. This is because I think
that points should be drawn on top of lines, circles etc..

Details of this method are likely to change, especially with respect
to the background.

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

