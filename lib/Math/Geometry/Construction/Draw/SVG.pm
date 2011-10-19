package Math::Geometry::Construction::Draw::SVG;
use Moose;
extends 'Math::Geometry::Construction::Draw';

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Draw::SVG> - SVG output

=head1 VERSION

Version 0.007

=cut

our $VERSION = '0.007';


###########################################################################
#                                                                         #
#                            Generate Output                              #
#                                                                         #
###########################################################################

sub BUILD {
    my ($self, $args) = @_;

    $self->_output(SVG->new(%$args));

    $self->width($args->{width});
    $self->height($args->{height});

    if($args->{viewBox}) {
	my $f = '[^\s\,]+';
	my $w = '(?:\s+|\s*\,\*)';
	if($args->{viewBox} =~ /^\s*($f)$w($f)$w($f)$w($f)\s*$/) {
	    $self->view_box([$1, $2, $3, $4]);
	}
	else { warn "Failed to parse viewBox attribute.\n"  }
    }
    else {
	$self->view_box([0, 0, $args->{width}, $args->{height}]);
    }
}

sub set_background {
    my ($self, $color) = @_;
    my $vb             = $self->view_box;

    $self->output->rect('x' => $vb->[0], 'y' => $vb->[1],
			width  => $vb->[2],
			height => $vb->[3],
			stroke => 'none',
			fill   => $color);
}

sub line {
    my ($self, %args) = @_;

    $self->output->line(%args);
}

sub circle {
    my ($self, %args) = @_;

    $self->output->circle(%args);
}

sub text {
    my ($self, %args) = @_;

    my $data = delete $args{text};
    my $text = $self->output->text(%args);
    $text->cdata($data);
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

