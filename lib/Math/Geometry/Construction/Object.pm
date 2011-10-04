package Math::Geometry::Construction::Object;
use Moose::Role;

use 5.008008;

use Carp;

# $Id: Object.pm 6959 2011-09-25 07:19:52Z powergnom $

=head1 NAME

C<Math::Geometry::Construction::Object> - shared administrative issues

=head1 VERSION

Version 0.002

=cut

our $VERSION = '0.002';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

requires 'id_template';

has 'id'          => (isa      => 'Str',
		      is       => 'rw',
		      writer   => '_id',
		      required => 1,
		      lazy     => 1,
		      builder  => '_generate_id');

has 'order_index' => (isa      => 'Int',
		      is       => 'rw',
		      required => 1);

has 'style'       => (isa     => 'HashRef[Str]',
		      is      => 'rw',
		      reader  => 'style_hash',
		      writer  => '_style_hash',
		      traits  => ['Hash'],
		      default => sub { {} },
		      handles => {style => 'accessor'});

has 'hidden'      => (isa     => 'Bool',
		      is      => 'rw',
		      default => 0);

has 'specific_poi' => (isa     => 'ArrayRef[Item]',
		       is      => 'bare',
		       traits  => ['Array'],
		       default => sub { [] },
		       handles => {specific_poi => 'elements',
				   add_poi      => 'push'});

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

