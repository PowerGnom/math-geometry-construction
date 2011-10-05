package Math::Geometry::Construction::IntersectionPoint;

use 5.008008;

use Moose;
use Math::VectorReal;
use Carp;

=head1 NAME

C<Math::Geometry::Construction::IntersectionPoint> - intersection of objects

=head1 VERSION

Version 0.002

=cut

our $VERSION = '0.002';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

our $ID_TEMPLATE = 'I%09d';

sub id_template { return $ID_TEMPLATE }

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Object';

has 'intersection'   => (isa      => 'Item',
		         is       => 'ro',
		         required => 1);

has 'point_selector' => (isa      => 'Array[Item]',
			 is       => 'ro',
			 reader   => '_point_selector',
			 required => 1);

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub position {
    my ($self) = @_;

    my ($selector_method, $args) = @{$self->_point_selector};
    return($self->intersection->$selector_method(@$args)->position);
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

