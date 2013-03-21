package Math::Geometry::Construction::Role::Input;
use Moose::Role;

use 5.008008;

use Carp;
use Math::Vector::Real;

=head1 NAME

C<Math::Geometry::Construction::Role::Input> - format conversions

=head1 VERSION

Version 0.021

=cut

our $VERSION = '0.021';


# As a general rule, this method should only deal with 'fixed
# values'; e.g. Point positions and Line directions have to be
# evaluated by the caller in order supply the vector object to this
# method.
sub import_vector {
    my ($self, $value) = @_;

    return undef if(!defined($value));
    return $value if(eval { $value->isa('Math::Vector::Real') });
    return V(@{$value}[0, 1]) if(ref($value) eq 'ARRAY');
    return V($value->x, $value->y)
	if(eval { $value->isa('Math::VectorReal') });
    croak sprintf('Unsupported vector format %s', ref($value));
}

sub import_point {
    my ($self, $construction, $value) = @_;

    return undef if(!defined($value));
    return $value
	if(eval { $value->isa('Math::Geometry::Construction::Point') });
    return $construction->add_point(position => $value, hidden => 1);
}

1;


__END__

=pod

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Methods


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

