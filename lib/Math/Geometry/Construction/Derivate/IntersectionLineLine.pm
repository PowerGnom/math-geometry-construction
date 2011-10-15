package Math::Geometry::Construction::Derivate::IntersectionLineLine;
use Moose;
extends 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;
use Math::VectorReal ':all';
use Math::MatrixReal;

=head1 NAME

C<Math::Geometry::Construction::Derivate::IntersectionLineLine> - line line intersection

=head1 VERSION

Version 0.006

=cut

our $VERSION = '0.006';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub positions {
    my ($self) = @_;
    my @lines  = $self->input;

    croak "Need two lines to intersect" if(@lines != 2);
    foreach(@lines) {
	if(!$_->isa('Math::Geometry::Construction::Line')) {
	    croak sprintf("Need lines for LineLine intersection, no %s",
			  ref($_));
	}
    }

    my @support = map { [map { $_->position } $_->support] } @lines;

    foreach my $line (@support) {
	foreach my $position (@$line) {
	    return if(!defined($position));
	}
    }

    my @normal   = map { $_->norm }
	           map { (plane(Z, O, $_->[1] - $_->[0]))[0] } @support;
    my @constant = map { $normal[$_] . $support[$_]->[0] } (0, 1);
    my $matrix   = Math::MatrixReal->new_from_rows
	([map { [$_->x, $_->y] } @normal]);

    return if($matrix->det == 0);
    my $inverse = $matrix->inverse;
    return if(!$inverse);  # only possible - if at all - for num. reasons

    return(vector($inverse->element(1, 1) * $constant[0] +
		  $inverse->element(1, 2) * $constant[1],
		  $inverse->element(2, 1) * $constant[0] +
		  $inverse->element(2, 2) * $constant[1],
		  0));
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

