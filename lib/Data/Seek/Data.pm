# ABSTRACT: Data::Seek Data Structure Container
package Data::Seek::Data;

use 5.10.0;
use strict;
use warnings;

use Mo;

use Hash::Flatten ();

our $VERSION = '0.03'; # VERSION

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

version 0.03

=head1 SYNOPSIS

    use Data::Seek::Data;

=head1 DESCRIPTION

Data::Seek::Data is a class within L<Data::Seek> which acts as a container for a
data structure which is intended to be provided to L<Data::Seek::Search>.

=head1 ATTRIBUTES

=head2 object

    $data->object;
    $data->object($hash);

Contains the data structure to be introspected, encoded and/or decoded, and must
be a hash reference.

=head1 METHODS

=head2 decode

    my $hash = $data->decode;

Uses L<Hash::Flatten> to unflatten/unfold the data structure returning a hash
reference.

=head2 encode

    my $hash = $data->encode;

Uses L<Hash::Flatten> to flatten/fold the data structure returning a hash
reference.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
