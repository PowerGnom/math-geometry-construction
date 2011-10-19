package Math::Geometry::Construction::Output;
use Moose::Role;

use 5.008008;

use Carp;

=head1 NAME

C<Math::Geometry::Construction::Output> - graphical output issues

=head1 VERSION

Version 0.004

=cut

our $VERSION = '0.004';


###########################################################################
#                                                                         #
#                               Accessors                                 # 
#                                                                         #
###########################################################################

has 'points_of_interest' => (isa     => 'ArrayRef[Item]',
			     is      => 'bare',
			     traits  => ['Array'],
			     default => sub { [] },
			     handles => {points_of_interest => 'elements',
					 add_poi            => 'push'});

has 'label'              => (isa       => 'Item',
			     is        => 'rw',
			     clearer   => 'clear_label',
			     predicate => 'has_label');

has 'label_offset_x'     => (isa     => 'Num',
			     is      => 'rw',
			     default => 0);

has 'label_offset_y'     => (isa     => 'Num',
			     is      => 'rw',
			     default => 0);

has 'hidden'             => (isa     => 'Bool',
			     is      => 'rw',
			     default => 0);

has 'style'              => (isa     => 'HashRef[Str]',
			     is      => 'rw',
			     reader  => 'style_hash',
			     writer  => '_style_hash',
			     traits  => ['Hash'],
			     default => sub { {} },
			     handles => {style => 'accessor'});

has 'label_style'        => (isa     => 'HashRef[Str]',
			     is      => 'rw',
			     reader  => 'label_style_hash',
			     writer  => '_label_style_hash',
			     traits  => ['Hash'],
			     default => sub { {} },
			     handles => {label_style => 'accessor'});

###########################################################################
#                                                                         #
#                             Retrieve Data                               #
#                                                                         #
###########################################################################

sub label_as_svg {
    my ($self, %args) = @_;
    my $text;

    if($self->has_label) {
	$text = $args{parent}->text
	    ('x' => $args{x} + $self->label_offset_x,
	     'y' => $args{y} + $self->label_offset_y,
	     style => $self->label_style_hash);

	my $label = $self->label;
	$text->cdata(defined($label) ? $label : '');
    }

    return $text;
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

