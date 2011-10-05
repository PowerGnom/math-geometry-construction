package Math::Geometry::Construction::LineLine;
use Moose::Role;

use 5.008008;

use Carp;
use Math::VectorReal ':all';

=head1 NAME

C<Math::Geometry::Construction::LineLine> - line line intersection

=head1 VERSION

Version 0.002

=cut

our $VERSION = '0.002';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

requires 'intersectants';

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub points {
    my ($self) = @_;
    my @lines  = $self->intersectants;

    croak "Needs two lines to intersect" if(@lines != 2);
    foreach(@lines) {
	if(!$_->isa('Math::Geometry::Construction::Line')) {
	    croak sprintf("Need lines for LineLine intersection, no %s",
			  ref($_));
	}
    }

    my @support  = map { [$_->support] } @lines;
    my @normal   = map { $_->norm }
 	           map { (plane(Z, 0, ($_->[1] - $_->[0])))[0] } @support;
    my @constant = map { $normal[$_] . $support[$_]->[0] } (0, 1);
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

