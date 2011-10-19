package Math::Geometry::Construction::Line;
use Moose;

use 5.008008;

use Carp;
use List::MoreUtils qw(any);

use Math::Geometry::Construction::Derivate::IntersectionLineLine;
use Math::Geometry::Construction::Derivate::IntersectionCircleLine;

=head1 NAME

C<Math::Geometry::Construction::Line> - line through two points

=head1 VERSION

Version 0.007

=cut

our $VERSION = '0.007';


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

with 'Math::Geometry::Construction::Object';
with 'Math::Geometry::Construction::PositionSelection';
with 'Math::Geometry::Construction::Output';

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

sub BUILD {
    my ($self, $args) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));
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

sub draw {
    my ($self, %args) = @_;
    return undef if $self->hidden;

    my @support = $self->support;
    if(@support != 2) {
	warn "A line needs two support points, skipping.\n";
	return undef;
    }

    my @support_positions = map { $_->position } @support;

    # check for defined positions
    if(any { !defined($_) } @support_positions) {
	warn sprintf("Undefined support point in line %s, ".
		     "nothing to draw.\n", $self->id);
	return undef;
    }

    my $direction = ($support_positions[1] - $support_positions[0])->norm;

    # I don't need to check for defined points here because at least
    # the support points are there and will show up as extremes.
    my @positions = ($self->extreme_position($direction)
		     + $direction * $self->extend,
		     $self->extreme_position(-$direction)
		     - $direction * $self->extend);

    $self->construction->draw_line(x1    => $positions[0]->x,
				   y1    => $positions[0]->y,
				   x2    => $positions[1]->x,
				   y2    => $positions[1]->y,
				   style => $self->style_hash,
				   id    => $self->id);
    
    $self->draw_label('x' => ($positions[0]->x + $positions[1]->x) / 2,
		      'y' => ($positions[0]->y + $positions[1]->y) / 2);
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


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Public Attributes

=head2 Methods for Users

=head2 Methods for Subclass Developers

=head3 as_svg

=head3 id_template

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

