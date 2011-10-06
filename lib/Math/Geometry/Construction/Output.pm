package Math::Geometry::Construction::Output;
use Moose::Role;

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Output> - graphical output issues

=head1 VERSION

Version 0.003

=cut

our $VERSION = '0.003';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'style'              => (isa     => 'HashRef[Str]',
			     is      => 'rw',
			     reader  => 'style_hash',
			     writer  => '_style_hash',
			     traits  => ['Hash'],
			     default => sub { {} },
			     handles => {style => 'accessor'});

has 'hidden'             => (isa     => 'Bool',
			     is      => 'rw',
			     default => 0);

has 'points_of_interest' => (isa     => 'ArrayRef[Item]',
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

