package Math::Geometry::Construction::Derivate::TranslatedPoint;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;
use Math::Vector::Real;

=head1 NAME

C<Math::Geometry::Construction::Derivate::TranslatedPoint> - point translated by a given vector

=head1 VERSION

Version 0.014

=cut

our $VERSION = '0.014';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Role::VectorFormats';

has 'translator' => (isa      => 'Item',
		     is       => 'rw',
		     required => 1);

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{translator} = $class->import_vector($args{translator});

    return \%args;
}

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub positions {
    my ($self) = @_;
    my @input  = $self->input;

    croak "Need one point" if(@input != 1);
    if(!$input[0]->can('position')) {
	croak sprintf("Need something with a position, no %s",
		      ref($_));
    }

    my $position = $input[0]->position;
    return if(!$position);

    return($position + $self->translator);
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

