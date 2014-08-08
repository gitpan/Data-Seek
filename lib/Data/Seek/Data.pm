# ABSTRACT: Data::Seek Data Structure Container
package Data::Seek::Data;

use 5.10.0;
use strict;
use warnings;

use Mo;

use Hash::Flatten ();

our $VERSION = '0.01'; # VERSION

has 'object';

sub decode {
    my $self   = shift;
    my $object = $self->object // {};
    return Hash::Flatten::unflatten $object;
}

sub encode {
    my $self   = shift;
    my $object = $self->object // {};
    return Hash::Flatten::flatten $object;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Seek::Data - Data::Seek Data Structure Container

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    use Data::Seek::Serializer;

=head1 DESCRIPTION

Data::Seek::Serializer creates flattened/folded data structures to be
introspected by L<Data::Seek>.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
