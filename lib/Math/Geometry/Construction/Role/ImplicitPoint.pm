package Math::Geometry::Construction::Role::ImplicitPoint;
use Moose::Role;

use 5.008008;

use Carp;
use Math::Vector::Real;

=head1 NAME

C<Math::Geometry::Construction::Role::ImplicitPoint> - transform different formats to Math::Vector::Real

=head1 VERSION

Version 0.014

=cut

our $VERSION = '0.014';

sub import_point {
    my ($self, $construction, $value) = @_;
    my @point_classes = ('Math::Geometry::Construction::Point',
			 'Math::Geometry::Construction::DerivedPoint');

    return undef if(!defined($value));
    foreach(@point_classes) { return $value if(eval { $value->isa($_) }) }
    return $construction->add_point(position => $value, hidden => 1);
}

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

