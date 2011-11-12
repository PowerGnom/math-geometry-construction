package Math::Geometry::Construction::Draw;

use 5.008008;

use Moose;
use Carp;

=head1 NAME

C<Math::Geometry::Construction::Draw> - base class for drawing

=head1 VERSION

Version 0.015

=cut

our $VERSION = '0.015';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'output'            => (isa      => 'Item',
			    is       => 'rw',
			    writer   => '_output');

has ['width', 'height'] => (isa      => 'Str',
			    is       => 'ro',
			    required => 1);

has 'transform'         => (isa      => 'ArrayRef[Num]',
			    is       => 'ro',
			    default  => sub { [1, 0, 0, 1, 0, 0] });


###########################################################################
#                                                                         #
#                            Generate Output                              #
#                                                                         #
###########################################################################

sub transform_coordinates {
    my ($self, $x, $y) = @_;
    my $t              = $self->transform;

    return($t->[0] * $x + $t->[2] * $y, $t->[4],
	   $t->[1] * $x + $t->[3] * $y, $t->[5]);
}

sub line {}
sub circle {}
sub text {}


1;


__END__

=pod

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 INTERFACE

=head2 Public Attributes

=head2 Methods for Users

=head2 Methods for Subclass Developers

=head3 create_derived_point

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

