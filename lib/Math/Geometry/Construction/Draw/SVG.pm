package Math::Geometry::Construction::Draw::SVG;
use Moose;
extends 'Math::Geometry::Construction::Draw';

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Draw::SVG> - SVG output

=head1 VERSION

Version 0.013

=cut

our $VERSION = '0.013';


###########################################################################
#                                                                         #
#                            Generate Output                              #
#                                                                         #
###########################################################################

sub BUILD {
    my ($self, $args) = @_;

    delete($args->{view_box});
    $self->_output(SVG->new(%$args));
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

sub process_style {
    my ($self, $element, %style) = @_;

    while(my ($key, $value) = each(%style)) {
	if($value and ref($value) eq 'ARRAY' and @$value == 3) {
	    $style{$key} = sprintf('rgb(%d, %d, %d)', @$value);
	}
    }

    return %style;
}

sub line {
    my ($self, %args) = @_;

    $args{style} = {$self->process_style('line', %{$args{style}})}
	if($args{style});
    $self->output->line(%args);
}

sub circle {
    my ($self, %args) = @_;

    $args{style} = {$self->process_style('circle', %{$args{style}})}
	if($args{style});
    $self->output->circle(%args);
}

sub text {
    my ($self, %args) = @_;

    $args{style} = {$self->process_style('text', %{$args{style}})}
	if($args{style});

    my $data = delete $args{text};
    my $text = $self->output->text(%args);
    $text->cdata($data);
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

  print $construction->as_svg(width => 800, height => 300)->xmlify;


=head1 DESCRIPTION

This class implements the
L<Math::Geometry::Construction::Draw|Math::Geometry::Construction::Draw>
interface in order to generate C<SVG> output. It is instantiated by
the L<draw method|Math::Geometry::Construction/draw> in
C<Math::Geometry::Construction>.

The output created by this class will be an L<SVG|SVG> object. See
C<SYNOPSIS>.

Key/value pairs in the style settings of lines, circles etc. are
passed unchanged to the respective C<SVG> element.


=head1 INTERFACE

=head2 Public Attributes

=head2 Methods

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

=item * L<SVG|SVG>

=item * L<http://www.w3.org/TR/SVG11/>

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

