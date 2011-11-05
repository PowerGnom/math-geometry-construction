package Math::Geometry::Construction::Derivate;

use 5.008008;

use Moose;
use Math::VectorReal;
use Carp;

=head1 NAME

C<Math::Geometry::Construction::Derivate> - derive points from objects

=head1 VERSION

Version 0.012

=cut

our $VERSION = '0.012';


###########################################################################
#                                                                         #
#                      Class Variables and Methods                        # 
#                                                                         #
###########################################################################

our $ID_TEMPLATE = 'D%09d';

sub id_template { return $ID_TEMPLATE }

###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

with 'Math::Geometry::Construction::Role::Object';
with 'Math::Geometry::Construction::Role::PositionSelection';

has 'input' => (isa      => 'ArrayRef[Item]',
		is       => 'bare',
		traits   => ['Array'],
		required => 1,
		handles  => {count_input  => 'count',
			     input        => 'elements',
			     single_input => 'accessor'});

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub positions { return() }

sub create_derived_point {
    my ($self, %args) = @_;

    my $point = $self->construction->add_object
	('Math::Geometry::Construction::DerivedPoint',
	 derivate => $self,
	 %args);

    foreach($self->input) {
	$_->add_poi($point);
    }

    return $point;
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

