package Math::Geometry::Construction::Role::PointSet;
use Moose::Role;

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Role::PointSet> - point set objects

=head1 VERSION

Version 0.017

=cut

our $VERSION = '0.017';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

requires 'construction';
requires 'id';

has 'members' => (isa     => 'ArrayRef[Item]',
		  is      => 'bare',
		  traits  => ['Array'],
		  default => sub { [] },
		  handles => {members    => 'elements',
			      add_member => 'push'});

1;


__END__

=pod

=head1 DESCRIPTION

This role provides attributes and methods that are common to all
classes which represent objects that are point sets (specifically
lines and circles). The role provides means to identify if two such
objects are the same.

=head1 INTERFACE

=head2 Public Attributes

=head3 members

An array of C<Point> objects that lie on this object. This is not
meant in strict geometrical sense. For a line, the members are the
two support points and all points derived from and lying on this
line, e.g. C<PointOnLine> constructions and intersection
points. However, the points must lie on that line. If, for example,
a point is reflected at this line then the reflected point is also
somehow associated with this line, but not a member. Similarly, the
center of a circle is not a member.

The C<members> accessor will return the array (not a reference), the
C<add_member> method pushes to the array.

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

