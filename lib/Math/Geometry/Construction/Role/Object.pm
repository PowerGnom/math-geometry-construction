package Math::Geometry::Construction::Role::Object;
use Moose::Role;

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Role::Object> - shared administrative issues

=head1 VERSION

Version 0.014

=cut

our $VERSION = '0.014';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

requires 'id_template';

has 'id'           => (isa      => 'Str',
		       is       => 'ro',
		       required => 1,
		       lazy     => 1,
		       builder  => '_generate_id');

has 'order_index'  => (isa      => 'Int',
		       is       => 'rw');

has 'construction' => (isa      => 'Item',
		       is       => 'ro',
		       required => 1,
		       weak_ref => 1);

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub _generate_id {
    my ($self) = @_;
    
    return sprintf($self->id_template, $self->order_index);
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

