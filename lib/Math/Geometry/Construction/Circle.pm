package Math::Geometry::Construction::Circle;
use Moose;

use 5.008008;

use Carp;
use Scalar::Util qw(blessed);
use Math::Vector::Real;

=head1 NAME

C<Math::Geometry::Construction::Circle> - circle by center and point

=head1 VERSION

Version 0.018

=cut

our $VERSION = '0.018';


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

with 'Math::Geometry::Construction::Role::Object';
with 'Math::Geometry::Construction::Role::PositionSelection';
with 'Math::Geometry::Construction::Role::Output';
with 'Math::Geometry::Construction::Role::PointSet';

has 'center'       => (isa      => 'Item',
		       is       => 'ro',
		       required => 1);

has 'support'      => (isa      => 'Item',
		       is       => 'ro',
		       required => 1);

has 'fixed_radius' => (isa      => 'Bool',
		       is       => 'ro',
		       required => 1);

sub BUILDARGS {
    my ($class, %args) = @_;
    
    $args{center} = $class->import_point
	($args{construction}, $args{center});

    if(exists($args{radius})) {
	$args{support} = $args{construction}->add_derived_point
	    ('TranslatedPoint',
	     {input      => [$args{center}],
	      translator => [$args{radius}, 0]},
	     {hidden     => 1});
	delete $args{radius};
	$args{fixed_radius} = 1;
    }
    else {
	$args{support} = $class->import_point
	    ($args{construction}, $args{support});
	$args{fixed_radius} = 0;
    }

    return \%args;
}

sub BUILD {
    my ($self, $args) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));
    $self->style('fill',   'none')  unless($self->style('fill'));

    $self->register_point($self->support);
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub positions {
    my ($self) = @_;

    return map { $_->position } $self->points;
}

sub radius {
    my ($self, @args) = @_;

    if(@args) {
	if($self->fixed_radius) {
	    # TODO: validate
	    $self->support->derivate->translator(V($args[0], 0));
	}
	else {
	    croak "Radius can only be set on circles with fixed radius";
	}
    }

    my $center_p  = $self->center->position;
    my $support_p = $self->support->position;

    return if(!$center_p or !$support_p);
    return(abs($support_p - $center_p));
}

sub draw {
    my ($self, %args) = @_;
    return undef if $self->hidden;

    my $center_position  = $self->center->position;
    my $support_position = $self->support->position;

    if(!$center_position) {
	warn sprintf("Undefined center of circle %s, ".
		     "nothing to draw.\n", $self->id);
	return undef;
    }
    if(!$support_position) {
	warn sprintf("Undefined support of circle %s, ".
		     "nothing to draw.\n", $self->id);
	return undef;
    }

    # currently, we just draw the full circle
    $self->construction->draw_circle(cx    => $center_position->[0],
				     cy    => $center_position->[1],
				     r     => $self->radius,
				     style => $self->style_hash,
				     id    => $self->id);

    $self->draw_label('x' => $support_position->[0],
		      'y' => $support_position->[1]);
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


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

