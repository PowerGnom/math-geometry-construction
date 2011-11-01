package Math::Geometry::Construction::Circle;
use Moose;

use 5.008008;

use Carp;

use Math::Geometry::Construction::Derivate::IntersectionCircleCircle;
use Math::Geometry::Construction::Derivate::IntersectionCircleLine;

=head1 NAME

C<Math::Geometry::Construction::Circle> - circle by center and point

=head1 VERSION

Version 0.010

=cut

our $VERSION = '0.010';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

our $ID_TEMPLATE = 'C%09d';

sub id_template { return $ID_TEMPLATE }

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Object';
with 'Math::Geometry::Construction::PositionSelection';
with 'Math::Geometry::Construction::Output';

has 'center'  => (isa      => 'Item',
		  is       => 'rw',
		  required => 1);

has 'support' => (isa      => 'Item',
		  is       => 'rw',
		  required => 1);

has 'extend'  => (isa     => 'Num',
		  is      => 'rw',
		  default => 0);

sub BUILDARGS {
    my ($class, %args) = @_;

    if(exists($args{radius})) {
	$args{support} = $args{construction}->add_derived_point
	    ('TranslatedPoint',
	     {input      => [$args{center}],
	      translator => [$args{radius}, 0]},
	     {hidden     => 1});
	delete $args{radius};
    }

    return \%args;
}

sub BUILD {
    my ($self, $args) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));
    $self->style('fill',   'none')  unless($self->style('fill'));
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

sub radius {
    my ($self) = @_;

    my $center_p  = $self->center->position;
    my $support_p = $self->support->position;

    return if(!$center_p or !$support_p);
    return(($support_p - $center_p)->length);
}

sub draw {
    my ($self, %args) = @_;
    return undef if $self->hidden;

    my $center_position  = $self->center->position;
    my $support_position = $self->support->position;

    if(!defined($center_position)) {
	warn sprintf("Undefined center of circle %s, ".
		     "nothing to draw.\n", $self->id);
	return undef;
    }
    if(!defined($support_position)) {
	warn sprintf("Undefined support of circle %s, ".
		     "nothing to draw.\n", $self->id);
	return undef;
    }

    my $radius = ($support_position - $center_position)->length;

    # currently, we just draw the full circle
    $self->construction->draw_circle(cx    => $center_position->x,
				     cy    => $center_position->y,
				     r     => $radius,
				     style => $self->style_hash,
				     id    => $self->id);

    $self->draw_label('x'    => $support_position->x,
		      'y'    => $support_position->y);
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

=head2 radius

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

