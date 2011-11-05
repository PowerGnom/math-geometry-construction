package Math::Geometry::Construction::Role::DrawPoint;
use Moose::Role;

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Role::DrawPoint> - point drawing issues

=head1 VERSION

Version 0.012

=cut

our $VERSION = '0.012';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

requires 'style';
requires 'construction';

has 'size'     => (isa     => 'Num',
	           is      => 'rw',
		   trigger => \&_size_trigger,
		   builder => '_build_size',
		   lazy    => 1);

has 'radius'   => (isa     => 'Num',
	           is      => 'rw',
		   trigger => \&_radius_trigger,
		   builder => '_build_radius',
		   lazy    => 1);

sub _size_trigger {
    my ($self, $new, $old) = @_;

    # dirty
    $self->{radius} = $new / 2;
}

sub _build_size {
    my ($self) = @_;

    return $self->construction->point_size;
}

sub _radius_trigger {
    my ($self, $new, $old) = @_;

    warn("The 'radius' attribute of Math::Geometry::Construction::Point ".
	 "is deprecated and might be removed in a future version. Use ".
	 "'size' with the double value (diameter of the circle) ".
	 "instead.\n");

    $self->size(2 * $new);
}

sub _build_radius {
    return($_[0]->_build_size / 2);
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

###########################################################################
#                                                                         #
#                              Change Data                                # 
#                                                                         #
###########################################################################

sub set_default_point_style {
    my ($self) = @_;

    $self->style('stroke', 'black') unless($self->style('stroke'));
    $self->style('fill', 'white')   unless($self->style('fill'));
}

1;


__END__

=pod

=head1 DESCRIPTION

This role provides attributes and methods that are common to all
classes which actually draw something.

=head1 INTERFACE

=head2 Public Attributes

=head2 Methods

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

