#!/usr/bin/perl
use strict;
use warnings;

use LaTeX::TikZ;

my $seq = Tikz->seq;
my $raw = Tikz->raw('\path[clip] (0, 0) rectangle (1, 1)');
$seq->add($raw);

print $raw->content, "\n";

my (undef, undef, $body) = Tikz->formatter->render($seq);
my $string = sprintf("%s\n", join("\n", @$body));
print $string;
