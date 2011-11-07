package Math::Geometry::Construction::Line;
use Moose;

use 5.008008;

use Carp;
use List::MoreUtils qw(any);
use Scalar::Util qw(blessed);
use Math::Vector::Real;

=head1 NAME

C<Math::Geometry::Construction::Line> - line through two points

=head1 VERSION

Version 0.014

=cut

our $VERSION = '0.014';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

our $ID_TEMPLATE = 'L%09d';

sub id_template { return $ID_TEMPLATE }

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Role::Object';
with 'Math::Geometry::Construction::Role::PositionSelection';
with 'Math::Geometry::Construction::Role::Output';
with 'Math::Geometry::Construction::Role::ImplicitPoint';

has 'support'     => (isa      => 'ArrayRef[Item]',
		      is       => 'bare',
		      traits   => ['Array'],
		      required => 1,
		      handles  => {count_support  => 'count',
				   support        => 'elements',
				   single_support => 'accessor'});

has 'extend'      => (isa     => 'Num',
		      is      => 'rw',
		      default => 0);

sub BUILDARGS {
    my ($class, %args) = @_;
    
    for(my $i=0;$i<@{$args{support}};$i++) {
	$args{support}->[$i] = $class->import_point
	    ($args{construction}, $args{support}->[$i]);
    }

    return \%args;
}

sub BUILD {
    my ($self, $args) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));

    my @support = $self->support;
    if(@support != 2) {
	croak "A line needs exactly two support points";
	return undef;
    }
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub points {
    my ($self) = @_;

    return($self->support, $self->points_of_interest);
}

sub positions {
    my ($self) = @_;

    return map { $_->position } $self->points;
}

sub parallel {
    my ($self)            = @_;
    my @support_positions = map { $_->position } $self->support;

    # check for defined positions
    if(any { !defined($_) } @support_positions) {
	warn sprintf("Undefined support point in line %s.\n", $self->id);
	return undef;
    }

    my $direction = $support_positions[1] - $support_positions[0];
    my $length    = abs($direction);

    if($length == 0) {
	warn sprintf("Support points of line %s are identical.\n",
		     $self->id);
	return undef;
    }
    
    return($direction / $length);
}

sub normal {
    my ($self)   = @_;
    my $parallel = $self->parallel;

    return $parallel ? V(-$parallel->[1], $parallel->[0]) : undef;
}

sub draw {
    my ($self, %args) = @_;
    return undef if $self->hidden;

    my $parallel = $self->parallel;
    return undef if(!$parallel);

    my @positions = ($self->extreme_position($parallel)
		     + $parallel * $self->extend,
		     $self->extreme_position(-$parallel)
		     - $parallel * $self->extend);

    $self->construction->draw_line(x1    => $positions[0]->[0],
				   y1    => $positions[0]->[1],
				   x2    => $positions[1]->[0],
				   y2    => $positions[1]->[1],
				   style => $self->style_hash,
				   id    => $self->id);
    
    $self->draw_label
	('x' => ($positions[0]->[0] + $positions[1]->[0]) / 2,
	 'y' => ($positions[0]->[1] + $positions[1]->[1]) / 2);
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

  my $p1 = $construction->add_point('x' => 100, 'y' => 90);
  my $p2 = $construction->add_point('x' => 120, 'y' => 150);
  my $l1 = $construction->add_line(support => [$p1, $p2]);

  my $p3 = $construction->add_point('x' => 200, 'y' => 50);
  my $p4 = $construction->add_point('x' => 250, 'y' => 50);

  my $l2 = $construction->add_line(support        => [$p3, $p4],
                                   extend         => 10,
                                   label          => 'g',
				   label_offset_y => 13);


=head1 DESCRIPTION

An instance of this class represents a line defined by two points.
The points can be either points defined directly by the user
(L<Math::Geometry::Construction::Point|Math::Geometry::Construction::Point>
objects) or so-called derived points
(L<Math::Geometry::Construction::DerivedPoint|Math::Geometry::Construction::DerivedPoint>
objects), e.g. intersection points. This class is not supposed to be
instantiated directly. Use the L<add_line
method|Math::Geometry::Construction/add_line> of
C<Math::Geometry::Construction> instead.


=head1 INTERFACE

=head2 Public Attributes

=head3 support

Holds an array reference of the two points that define the line.
Must be given to the constructor and should not be touched
afterwards (the points can change their positions, of course). Must
hold exactly two points.

=head3 extend

Often it looks nicer if the visual representation of a line extends
somewhat beyond its end points. The length of this extent is set
here. Defaults to C<0>.

=head2 Methods

=head3 normal

Returns a L<Math::Vector::Real|Math::Vector::Real> of length C<1>
that is orthogonal to the line.

=head3 draw

Called by the C<Construction> object during output generation.
Draws a line between the most extreme points on this line
(including both support points and points derived from this line).
The line is extended by length of L<extend|/extend> beyond these
points.

=head3 id_template

Class method returning C<$ID_TEMPLATE>, which defaults to C<'L%09d'>.

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

