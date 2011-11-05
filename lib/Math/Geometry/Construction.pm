package Math::Geometry::Construction;

use 5.008008;

use Carp;
use Moose;
use Math::VectorReal;
use SVG;
use MooseX::Params::Validate;

=head1 NAME

C<Math::Geometry::Construction> - intersecting lines and circles

=head1 VERSION

Version 0.012

=cut

our $VERSION = '0.012';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'background' => (isa => 'Str',
		     is  => 'rw');

has 'objects'    => (isa     => 'HashRef[Item]',
		     is      => 'bare',
		     traits  => ['Hash'],
		     default => sub { {} },
		     handles => {count_objects => 'count',
				 object        => 'accessor',
				 object_ids    => 'keys',
				 objects       => 'values'});

has 'output'     => (isa     => 'Item',
		     is      => 'rw',
		     writer  => '_output',
		     handles => {draw_line   => 'line',
				 draw_circle => 'circle',
				 draw_text   => 'text'});

has 'point_size' => (isa     => 'Num',
		     is      => 'rw',
		     default => 6);
		     

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub draw {
    my ($self, $type, %args) = @_;

    ($type) = pos_validated_list([$type], {isa => 'Str'});

    my $class = $type =~ /\:\:/
	? $type
	: 'Math::Geometry::Construction::Draw::'.$type;

    if($class =~ /^\s*[A-Za-z0-9\_\:]+\s*$/) {
	eval "require $class" or croak "Unable to load module $class: $!";
    }
    else { croak "Class name $class did not pass regex check" }

    my $output = $self->_output($class->new(%args));

    if(my $bg = $self->background) {
	$output->set_background($bg);
    }
    
    my @objects = sort { $a->order_index <=> $b->order_index }
        $self->objects;

    my %is_point = ('Math::Geometry::Construction::Point'        => 1,
		    'Math::Geometry::Construction::DerivedPoint' => 1);
    foreach(grep { !$is_point{blessed($_)} } @objects) {
	$_->draw(output => $output) if($_->can('draw'));
    }
    foreach(grep { $is_point{blessed($_)} } @objects) {
	$_->draw(output => $output) if($_->can('draw'));
    }

    return $output->output;
}

sub as_svg  { return(shift(@_)->draw('SVG', @_)) }

sub as_tikz { return(shift(@_)->draw('TikZ', @_)) }

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

sub add_object {
    my ($self, $class, @args) = @_;

    if($class =~ /^\s*[A-Za-z0-9\_\:]+\s*$/) {
	eval "require $class" or croak "Unable to load module $class: $!";
    }
    else { croak "Class name $class did not pass regex check" }
    
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

sub add_derived_point {
    my ($self, $class, $derivate_args, $point_args) = @_;

    my $derivate = $self->add_derivate($class, %$derivate_args);
    
    if(!defined($point_args) or ref($point_args) eq 'HASH') {
	return $derivate->create_derived_point(%{$point_args || {}});
    }
    else {
	return(map { $derivate->create_derived_point(%{$_ || {}}) }
	       @$point_args);
    }
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
  my $p5 = $i1->create_derived_point(label          => 'S',
                                     label_offset_x => 5,
                                     label_offset_y => -5);

  my $c1 = $construction->add_circle(center => $p5, radius => 20);

  # an intersection point can also be generated in one go
  my $p6 = $construction->add_derived_point
      ('IntersectionCircleLine',
       {input => [$l1, $c1]},
       {position_selector => ['extreme_position', [[1, 0]]]});

  print $construction->as_svg(width => 800, height => 300)->xmlify;


=head1 DESCRIPTION

This is alpha software. The API is likely to change, input checks
and documentation are sparse, the test suite barely exists. But
release early, release often, so here we go.

So far, the development has been fast and focused on adding
features. On the downside, the code has to be considered
fragile. Please report any problems you encounter.

=head2 Aims

This distribution serves two purposes:

=over 4

=item * Carrying out geometric constructions like with compass and
straight edge. You can define points, lines through two points, and
circles around a given center and through a given point. You can let
these objects intersect to gain new points to work with.

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
languages. With this module, you have Perl as your "macro language".

=back

=head2 Intersection Concept

Intersecting two objects consists of two steps. First, you create a
L<Math::Geometry::Construction::Derivate|Math::Geometry::Construction::Derivate>
object that holds the intersecting partners and "knows" how to
calculate the intersection points. Second, you create a
L<Math::Geometry::Construction::DerivedPoint|Math::Geometry::Construction::DerivedPoint>
from the C<Derivate>. The C<DerivedPoint> object holds information
about which of the intersection points to use. This can be based on
distance to a given point, being the extreme point with respect to a
given direction etc..

The C<DerivedPoint> object only holds information about how to
select the right point. Only when you ask for the position of the
point it is actually calculated.

The classes are called C<Derivate> and C<DerivedPoint> because this
concept is applicable beyond the case of intersections. It could,
for example, be used to calculate the center of a circle given by
three points. Whenever some operation based on given objects results
in a finite number of points, it fits into this concept.

=head2 Output

=head3 Output Formats

The current output formats are C<SVG> and C<TikZ>. Especially the
latter one is experimental and the interface might change in future
versions. Other output engines could be written by subclassing
L<Math::Geometry::Construction::Draw|Math::Geometry::Construction::Draw>.
However, documentation of the interface is not available, yet.

=head3 How much to draw?

Each line or similar object holds a number of "points of
interest". These are - in case of the line - the two points that
define the line and all intersection points the line is involved
in. At drawing time, the object determines the most extreme points
and they define the end points of the drawn line segment. The
C<extend> attribute allows to extend the line for a given length
beyond these points because this often looks better. A similar
concept will be implemented for circles, but currently, the full
circle is drawn.

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
color to be used instead. Possible values depend on the output
type. For C<SVG>, it can hold any valid C<SVG> color specifier,
e.g. C<white> or C<rgb(255, 255, 255)>. C<TikZ> currently ignores
the C<background> attribute.

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

=head2 Methods for Users

=head3 add_point

  $construction->add_point(%args)

Returns a new
L<Math::Geometry::Construction::Point|Math::Geometry::Construction::Point>.
All parameters are handed over to the constructor after adding the
C<construction> and C<order_index> arguments.

Examples:

  $construction->add_point(position => [10, 20]);
  $construction->add_point('x' => 50, 'y' => 30,
                           style => {stroke => 'red'});

  # requires 'use Math::VectorReal' in this package
  $construction->add_point(position => vector(-15, 23, 0),
                           hidden   => 1);

=head3 add_line

  $construction->add_line(%args)

Returns a new
L<Math::Geometry::Construction::Line|Math::Geometry::Construction::Line>.
All parameters are handed over to the constructor after adding the
C<construction> and C<order_index> arguments.

Example:

  $construction->add_line(support => [$point1, $point2],
                          extend  => 10);

=head3 add_circle

  $construction->add_circle(%args)

Returns a new
L<Math::Geometry::Construction::Circle|Math::Geometry::Construction::Circle>.
All parameters are handed over to the constructor after adding the
C<construction> and C<order_index> arguments.

The "standard" circle requires the center and a point "support"
point on its perimeter. However, you can provide a radius instead of
the support point, and the constructor of
L<Math::Geometry::Construction::Circle|Math::Geometry::Construction::Circle>
will create a support point under the hood. Even if you move the
center later on, the radius of the circle will stay constant.

Examples:

  $construction->add_circle(center  => $point1,
                            support => $point2);
  $construction->add_circle(center  => $point1,
                            radius  => 50);

=head3 add_object

  $construction->add_object($class, %args)

Returns a new instance of the given class. All parameters are handed
over to the constructor after adding the C<construction> and
C<order_index> arguments. In fact, L<add_point|/add_point>,
L<add_line|/add_line>, and L<add_circle|/add_circle> just call this
method with the appropriate class.

=head3 add_derivate

  $construction->add_derivate($class, %args)

Convenience shortcut for L<add_object|/add_object>. The only
difference is that C<$class> is prepended with
C<Math::Geometry::Construction::Derivate::>. Therefore you can call

  $construction->add_derivate('IntersectionCircleLine', %args)

instead of

  $construction->add_object
      ('Math::Geometry::Construction::Derivate::IntersectionCircleLine', %args)


Example:

  $construction->add_derivate('TranslatedPoint',
                              input      => [$point1],
                              translator => vector(10, -20, 0));

=head3 add_derived_point

  $construction->add_derived_point($class, $derivate_args, $point_args)

Combines the creation of a C<Derivate> object and a C<DerivedPoint>
object in one step. This is particularly useful if the derivate only
holds one point, e.g. the intersection of two lines, a translated
point, a point on a line etc..

The method expects three parameters:

=over 4

=item 1. the derivate class

=item 2. a hash reference with arguments for the constructor of
L<Math::Geometry::Construction::Derivate|Math::Geometry::Construction::Derivate>

=item 3. a hash reference with arguments for the constructor of
L<Math::Geometry::Construction::DerivedPoint|Math::Geometry::Construction::DerivedPoint>; this argument is optional, if not defined it is replaced by an empty hash reference

=back

Returns the C<DerivedPoint> object.

Example:

  $derived_point = $construction->add_derived_point
      ('IntersectionLineLine',
       {input => [$line1, $line2]},
       {position_selector => ['indexed_point', [0]]});

In this example, the last hash reference can be omitted:

  $derived_point = $construction->add_derived_point
      ('IntersectionLineLine', {input => [$line1, $line2]});

The missing hash reference is replaced by an empty hash reference,
and the constructor of the C<DerivedPoint> object uses the default
position selector C<['indexed_point', [0]]>.

If multiple derived points based on the same derivative are desired
then the third argument for C<add_derived_point> can be replaced by
the reference to an array of hash references each of which holds the
parameters for one of the points. A list of C<DerivedPoint> objects
is returned.

Example:

  @derived_points = $construction->add_derived_point
      ('IntersectionCircleLine',
       {input => [$circle, $line]},
       [{position_selector => ['extreme_point', [[0, -1]]]},
        {position_selector => ['extreme_point', [[0,  1]]]}]);

In this case, we ask for the two intersection points between a
circle and a line. The C<extreme_point> position selector will give
as the most extreme of the intersection points in the given
direction. Therefore, in C<SVG> coordinates, C<$derived_points[0]>
will hold the "northern", C<$derived_points[1]> the "southern"
intersection point.

=head3 draw

  $construction->draw('SVG', %args)

Draws the construction. The return value depends on the output type
and might be an object or a stringified version. Currently, the only
output types are C<SVG> and C<TikZ>. See L<as_svg|/as_svg> and
L<as_tikz|/as_tikz>.

If the type does not contain a C<::> then it is prepended by
C<Math::Geometry::Construction::Draw::> before requiring the module.

Calls the C<draw> method first on all non-point objects, then on
all C<Point> and C<DerivedPoint> objects. This is because I think
that points should be drawn on top of lines, circles etc..

=head3 as_svg

  $construction->as_svg(%args)
  $construction->draw('SVG', %args)

Shortcut for L<draw|/draw>. Returns an L<SVG|SVG> object
representing the construction. All parameters are handed over to the
L<SVG|SVG> constructor. At least C<width> and C<height> should be
provided.

If a L<background color|/background> is specified then a rectangle
of of that color is drawn as background. The size is taken from the
C<viewBox> attribute if specified, from C<width> and C<height>
otherwise. If none is given, no background is drawn.

=head3 as_tikz

  $construction->as_tikz(%args)
  $construction->draw('TikZ', %args)

Shortcut for L<draw|/draw>. Returns an L<LaTeX::TikZ|LaTeX::TikZ>
sequence object representing the construction. See
L<Math::Geometry::Construction::Draw|Math::Geometry::Construction::Draw>
and
L<Math::Geometry::Construction::Draw::TikZ|Math::Geometry::Construction::Draw::TikZ>
for supported parameters. At least C<width> and C<height> should be
provided.

=head1 DIAGNOSTICS

=head2 Exceptions

Currently, C<Math::Geometry::Construction> does not use any advanced
exception framework, it just croaks if it is unhappy. The error
messages are listed below in alphabetical order.

=over 4

=item * Class name %s did not pass regex check

=item * Need circles for CircleCircle intersection, no %s

=item * Need one circle and one line to intersect

The C<input> for circle line intersection has to be exactly one
L<Math::Geometry::Construction::Circle|Math::Geometry::Construction::Circle>
(or subclass) object and one
L<Math::Geometry::Construction::Line|Math::Geometry::Construction::Line>
(or subclass) object. This exception is thrown in all other
cases. It might be split into more specific exceptions in the
future. The exception is thrown only when the positions of the
intersections are calculated.

=item * Need lines for LineLine intersection, no %s

The C<input> for line line intersection has to consist of exactly
two
L<Math::Geometry::Construction::Line|Math::Geometry::Construction::Line>
(or subclass) objects. If the correct number of items is given, but
one of them is of an incorrect type then this exception is thrown.

=item * Need one line for PointOnLine"

=item * Need one point

=item * Need something with a position, no %s

=item * Need two circles to intersect

=item * Need two lines to intersect

The C<input> for line line intersection has to consist of exactly
two
L<Math::Geometry::Construction::Line|Math::Geometry::Construction::Line>
(or subclass) objects. If the wrong number of C<input> items
(ignoring their values) is given then this exception is thrown. The
exception is thrown only when the position of the intersection is
calculated.

=item * No way to determine position of PointOnLine %s

=item * Position of PointOnLine has to be set somehow

When constructing a
L<Math::Geometry::Construction::Derivate::PointOnLine|Math::Geometry::Construction::Derivate::PointOnLine>
object, one of the attributes C<distance>, C<quantile>, C<x>, and
C<y> has to be specified. Otherwise this exception is thrown.

=item * Unable to load module %s: %s

=item * Undefined direction in 'extreme_position' selector

The C<extreme_position> position selector expects a direction
vector. This exception is raised if the provided direction is
undefined.

=item * Undefined index in 'indexed_position' selector"

The C<indexed_position> position selector expects an index. This
exception is raised if the provided index is undefined.

=item * Undefined reference position in '%s' selector

The C<close_position> and C<distant_position> position selectors
expect a reference position. This exception is raised if the
provided reference is undefined.

=back


=head2 Warnings

=over 4

=item * A line needs two support points, skipping.

=item * Failed to parse viewBox attribute.

=item * No positions to select from in %s.

This warning is issued by the position selectors if there is are no
positions. For example, if you are using an intersection point of
two circles, but the circles do not intersect. The position selector
will print this warning and return undef. Your downstream code must
be able to handle undefined positions.

=item * Position index out of range in %s.

=item * The 'radius' attribute of
Math::Geometry::Construction::Point is deprecated and might be
removed in a future version. Use 'size' with the double
value (diameter of the circle) instead.

I think this message speaks for itself :-).

=item * Undefined center of circle %s, nothing to draw.

=item * Undefined position of derived point %s, nothing to draw.

=item * Undefined support of circle %s, nothing to draw.

=item * Undefined support point in line %s, nothing to draw.

=back


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

