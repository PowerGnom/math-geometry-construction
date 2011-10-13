package Math::Geometry::Construction::Derivate::IntersectionCircleLine;
use base 'Math::Geometry::Construction::Derivate';

use 5.008008;

use Carp;
use Math::VectorReal ':all';
use Math::Geometry::Construction::TemporaryPoint;

=head1 NAME

C<Math::Geometry::Construction::Derivate::IntersectionCircleLine> - circle line intersection

=head1 VERSION

Version 0.005

=cut

our $VERSION = '0.005';


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

sub points {
    my ($self) = @_;
    my @input  = $self->input;

    croak "Need one circle and one line to intersect" if(@input != 2);

    my $circle;
    my $line;
    if(eval { $input[0]->isa('Math::Geometry::Construction::Circle') }
       and
       eval { $input[1]->isa('Math::Geometry::Construction::Line') })
    {
	($circle, $line) = @input;
    }
    elsif(eval { $input[0]->isa('Math::Geometry::Construction::Line') }
	  and
	  eval { $input[1]->isa('Math::Geometry::Construction::Circle') })
    {
	($line, $circle) = @input;
    }
    else { croak "Need one circle and one line to intersect"  }
       
    my $center_p    = $circle->center->position;
    my $c_support_p = $circle->support->position;
    my @l_support_p = map { $_->position } $line->support;

    foreach my $_ ($center_p, $c_support_p, @l_support_p) {
	return if(!defined($_));
    }

    # line normal
    my $l_normal   =
	(plane(Z, O, $l_support_p[1] - $l_support_p[0]))[0]->norm;

    # some shorter and/or more intuitive variables
    my $a  = $l_normal->x;
    my $b  = $l_normal->y;
    my $c  = $l_normal . $l_support[0];
    my $cx = $center_p->x;
    my $cy = $center_p->y;
    my $r  = ($c_support_p - $center_p)->length;

    my @x;
    my @y;
    # quadratic equation
    if(abs($a) >= abs($b)) {
	my $denom = ($b/$a)**2 + 1;
	my $mph   = ($b*$c/$a**2 + $cy - $b/$a*$cx) / $denom;
	my $q     = (($cx - $c/$a)**2 + $cy**2 - $r**2) / $denom;

	my $rad = $mph**2 - $q;
	return if($rad < 0);

	my $root = sqrt($rad);
	@y = ($mph + $root, $mph - $root);
	@x = map { ($c - $b * $_) / $a } @y;
    }
    else {
	my $denom = ($a/$b)**2 + 1;
	my $mph   = ($a*$c/$b**2 + $cx - $a/$b*$cy) / $denom;
	my $q     = (($cy - $c/$b)**2 + $cx**2 - $r**2) / $denom;

	my $rad = $mph**2 - $q;
	return if($rad < 0);

	my $root = sqrt($rad);
	@x = ($mph + $root, $mph - $root);
	@y = map { ($c - $a * $_) / $b } @x;
    }

    my @positions = map { vector($x[$_], $y[$_], 0) } (0, 1);
    my $class     = 'Math::Geometry::Construction::TemporaryPoint';
    return(map { $class->new(position => $_) } @positions);
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

