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

has 'transform' => (isa     => 'ArrayRef[Num]',
		    is      => 'rw',
		    writer  => '_transform',
		    default => sub { [1, 1, 0, 0] });

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

# TODO: Consider using builder instead for transform
sub BUILD {
    my ($self, $args) = @_;

    if(my $vb = $self->view_box) {
	my $scale = [$self->width / $vb->[2],
		     $self->height / $vb->[3]];
	$self->_transform([@$scale,
			   $vb->[0] * $scale->[0],
			   $vb->[1] * $scale->[1]]);
    }

    $self->_output(Tikz->seq);

=for later

    # add clip and bounding box
    my $rect = Tikz->rectangle(Tikz->point(0, 0),
			       {$self->width, $self->height});
    my $path = Tikz->path($rect);
    $path->
    $self->output->add($path);

=cut

}

###########################################################################
#                                                                         #
#                            Generate Output                              #
#                                                                         #
###########################################################################

sub transform_coordinates {
    my ($self, $x, $y) = @_;
    my $transform      = $self->transform;

    if($self->svg_mode) {
	return($x * $transform->[0] + $transform->[2],
	       $self->height - ($y * $transform->[1] + $transform->[3]));
    }
    else {
	return($x * $transform->[0] + $transform->[2],
	       $y * $transform->[1] + $transform->[3]);
    }
}

sub transform_x_length {
    my ($self, $l) = @_;

    return($l * $self->transform->[0]);
}

sub transform_y_length {
    my ($self, $l) = @_;

    return($l * $self->transform->[1]);
}

sub process_style {
    my ($self, %style) = @_;
    my $svg_mode       = $self->svg_mode;

    if(exists($style{stroke})) {
	$style{color} = $style{stroke} if($svg_mode);
	delete($style{stroke});
    }

    # for some reason 'none' does not work although it should
    if($style{color} and $style{color} eq 'none') {
	if($style{fill} and $style{fill} ne 'none') {
	    $style{color} = $style{fill};
	}
	else  {
	    delete($style{color})
	}
    }

    return %style;
}

sub set_background {
    my ($self, $color) = @_;
}

sub line {
    my ($self, %args) = @_;

    my $line = Tikz->line
	([$self->transform_coordinates($args{x1}, $args{y1})],
	 [$self->transform_coordinates($args{x2}, $args{y2})]);

    my %style = $self->process_style(%{$args{style}});
    while(my ($key, $value) = each(%style)) {
	$line->mod(Tikz->raw_mod("$key=$value"));
    }

    $self->output->add($line);
}

sub circle {
    my ($self, %args) = @_;

    my $raw = Tikz->raw
	(sprintf('(%f, %f) ellipse (%f and %f)',
		 $self->transform_coordinates($args{cx}, $args{cy}),
		 $self->transform_x_length($args{r}),
		 $self->transform_y_length($args{r})));
	
    my %style = $self->process_style(%{$args{style}});
    
    $raw->mod(Tikz->color($style{color})) if($style{color});
    $raw->mod(Tikz->fill($style{fill}))   if($style{fill});

    $self->output->add($raw);
}

sub text {
    my ($self, %args) = @_;

    my $content = sprintf
	('(%f, %f) node {%s}',
	 $self->transform_coordinates($args{x}, $args{y}),
	 $args{text});
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

