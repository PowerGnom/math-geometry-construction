package Math::Geometry::Construction::Draw::TikZ;
use Moose;
extends 'Math::Geometry::Construction::Draw';

use 5.008008;

use Carp;
use LaTeX::TikZ;

=head1 NAME

C<Math::Geometry::Construction::Draw::TikZ> - TikZ output

=head1 VERSION

Version 0.008

=cut

our $VERSION = '0.008';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'scale_x'  => (isa     => 'Num',
		   is      => 'rw',
		   writer  => '_scale_x',
		   default => 1);

has 'scale_y'  => (isa     => 'Num',
		   is      => 'rw',
		   writer  => '_scale_y',
		   default => 1);

has 'offset_x' => (isa     => 'Num',
		   is      => 'rw',
		   writer  => '_offset_x',
		   default => 0);

has 'offset_y' => (isa     => 'Num',
		   is      => 'rw',
		   writer  => '_offset_y',
		   default => 0);

has 'svg_mode' => (isa     => 'Bool',
		   is      => 'ro',
		   default => 0);

sub BUILD {
    my ($self, $args) = @_;

    if(my $vb = $self->view_box) {
	$self->_scale_x($self->width / $vb->[2]);
	$self->_scale_y($self->height / $vb->[3]);
	$self->_offset_x(-$vb->[0] * $self->scale_x);
	if($self->svg_mode) {
	    $self->_offset_y($self->height + $vb->[1] * $self->scale_y);
	}
	else {
	    $self->_offset_y(-$vb->[1] * $self->scale_y);
	}
    }

    $self->_output(Tikz->seq);
}

###########################################################################
#                                                                         #
#                            Generate Output                              #
#                                                                         #
###########################################################################

sub set_background {
    my ($self, $color) = @_;
}

sub line {
    my ($self, %args) = @_;

    $self->output->add(Tikz->line([$args{x1}, $args{y1}],
				  [$args{x2}, $args{y2}]));
}

sub circle {
    my ($self, %args) = @_;

    $self->output->add(Tikz->circle([$args{cx}, $args{cy}],
				    $args{r}));
}

sub text {
    my ($self, %args) = @_;

    my $content = sprintf('(%f, %f) node {%s}',
			  $args{x}, $args{y}, $args{text});
    $self->output->add(Tikz->raw($content));
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

