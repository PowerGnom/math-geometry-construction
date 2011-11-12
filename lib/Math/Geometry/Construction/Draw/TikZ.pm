package Math::Geometry::Construction::Draw::TikZ;
use Moose;
extends 'Math::Geometry::Construction::Draw';

use 5.008008;

use Carp;
use LaTeX::TikZ as => 'TikZ';

=head1 NAME

C<Math::Geometry::Construction::Draw::TikZ> - TikZ output

=head1 VERSION

Version 0.013

=cut

our $VERSION = '0.013';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'svg_mode'  => (isa     => 'Bool',
		    is      => 'ro',
		    default => 0);

has 'math_mode' => (isa     => 'Bool',
		    is      => 'ro',
		    default => 1);

sub BUILD {
    my ($self, $args) = @_;
    my $seq           = TikZ->seq;

    # add clip
    my $rect = TikZ->rectangle
	(TikZ->point(0, 0),
	 TikZ->point($self->width, $self->height));
    $seq->clip(TikZ->path($rect));
    $self->_output($seq);
}

###########################################################################
#                                                                         #
#                            Generate Output                              #
#                                                                         #
###########################################################################

override 'transform_coordinates' => sub {
    my ($self, $x, $y) = @_;

    ($x, $y) = super();

    if($self->svg_mode) { return($x, $self->height - $y) }
    else                { return($x, $y)                 }
};

sub process_style {
    my ($self, $element, %style) = @_;
    my $svg_mode                 = $self->svg_mode;

    if($element eq 'text') {
	if(exists($style{fill})) {
	    $style{color} = $style{fill} if($svg_mode);
	    delete($style{fill});
	}
    }
    else {
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
    }

    while(my ($key, $value) = each(%style)) {
	if($value and ref($value) eq 'ARRAY' and @$value == 3) {
	    $style{$key} = sprintf('{rgb,255:red,%d;green,%d;blue,%d}',
				   @$value);
	}
    }

    return %style;
}

sub set_background {
    my ($self, $color) = @_;
}

sub line {
    my ($self, %args) = @_;

    my $line = TikZ->line
	([$self->transform_coordinates($args{x1}, $args{y1})],
	 [$self->transform_coordinates($args{x2}, $args{y2})]);

    my %style = $self->process_style('line', %{$args{style} || {}});
    while(my ($key, $value) = each(%style)) {
	$line->mod(TikZ->raw_mod("$key=$value"));
    }

    $self->output->add($line);
}

sub circle {
    my ($self, %args) = @_;

    my $raw = TikZ->raw
	(sprintf('(%f, %f) ellipse (%f and %f)',
		 $self->transform_coordinates($args{cx}, $args{cy}),
		 $self->transform_x_length($args{r}),
		 $self->transform_y_length($args{r})));
	
    my %style = $self->process_style('circle', %{$args{style} || {}});
    while(my ($key, $value) = each(%style)) {
	next if($key eq 'fill');
	$raw->mod(TikZ->raw_mod("$key=$value"));
    }
    if($style{fill}) {
	$raw->mod(TikZ->fill($style{fill}));
    }

    $self->output->add($raw);
}

sub text {
    my ($self, %args) = @_;
    my $svg_mode      = $self->svg_mode;
    my $template      = $self->math_mode
	? '(%f, %f) node {$%s$}' : '(%f, %f) node {%s}';

    my $content = sprintf
	($template,
	 $self->transform_coordinates($args{x}, $args{y}),
	 $args{text});
    my $raw = TikZ->raw($content);
    my %style = $self->process_style('text', %{$args{style} || {}});
    while(my ($key, $value) = each(%style)) {
	$raw->mod(TikZ->raw_mod("$key=$value"));
    }
    $self->output->add($raw);
}

1;


__END__

=pod

=head1 SYNOPSIS

  use Math::Geometry::Construction;

  my $construction = Math::Geometry::Construction->new;
  my $p1 = $construction->add_point('x' => 100, 'y' => 150);
  my $p2 = $construction->add_point('x' => 130, 'y' => 110);

  my $l1 = $construction->add_line(extend  => 10,
				   support => [$p1, $p2]);

  my $tikz = $construction->as_tikz(width    => 8,
                                    height   => 3,
                                    view_box => [0, 0, 800, 300],
                                    svg_mode => 1);

  my (undef, undef, $body) = Tikz->formatter->render($tikz);
  my $string = sprintf("%s\n", join("\n", @$body));

  print <<END_OF_TEX;
  \\documentclass{article}
  \\usepackage{tikz}
  \\begin{document}
  $string\\end{document}
  END_OF_TEX

=head1 DESCRIPTION

This class implements the
L<Math::Geometry::Construction::Draw|Math::Geometry::Construction::Draw>
interface in order to generate C<TikZ> code to be used in
C<LaTeX>. It is instantiated by the L<draw
method|Math::Geometry::Construction/draw> in
C<Math::Geometry::Construction>.

The output created by this class will be a
C<LaTeX::TikZ::Set::Sequence> object. See C<SYNOPSIS>.

Key/value pairs in the style settings of lines, circles etc. are
translated into C<raw_mod> calls

    while(my ($key, $value) = each(%style)) {
	$raw->mod(TikZ->raw_mod("$key=$value"));
    }

See L<LaTeX::TikZ|LaTeX::TikZ> if you want to know what this code
exactly does. Anyway, the important part is that you should be able
to use any modifier that C<TikZ> understands. See also
C<svg_mode|/svg_mode>.

=head1 INTERFACE

=head2 Public Attributes

=head3 svg_mode

Defaults to C<0>. If set to a true value, C<SVG> style attributes
are mapped to C<TikZ> attributes internally. The idea behind this is
that you might want to use the same construction including style
settings for both C<SVG> and C<TikZ> export. This feature is
experimental and will probably never cover the full C<SVG> and/or
C<TikZ> functionality.

Currently, only C<stroke> is mapped to C<color>, and this is done
literally. It will therefore only work for named colors which exist
in both output formats.

=head3 math_mode

Defaults to C<0>. If set to a true value, all text is printed in
C<LaTeX>'s math mode. Again, this is to enable the same code to be
used for C<TikZ> along side other output formats while still
typesetting labels in math mode.

=head2 Methods

See
L<Math::Geometry::Construction::Draw|Math::Geometry::Construction::Draw>.

=head1 DIAGNOSTICS

=head2 Exceptions

=head2 Warnings


=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-math-geometry-construction at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Geometry-Construction>.
I will be notified, and then you will automatically be notified of
progress on your bug as I make changes.


=head1 SEE ALSO

=over 4

=item * L<LaTeX::TikZ|LaTeX::TikZ>

=item * L<http://en.wikipedia.org/wiki/PGF/TikZ>

=item * L<http://www.ctan.org/tex-archive/graphics/pgf/base/doc/generic/pgf>

=back


=head1 AUTHOR

Lutz Gehlen, C<< <perl at lutzgehlen.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Lutz Gehlen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

