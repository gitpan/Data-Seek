# ABSTRACT: Search Complex Data Structures
package Data::Seek;

use 5.10.0;
use strict;
use warnings;

use Data::Seek::Data;
use Data::Seek::Search;

use Mo 'default';

our $VERSION = '0.05'; # VERSION

has 'cache',
    default => 0;

has 'data',
    default => sub {{}};

has 'ignore',
    default => 0;

sub search {
    my ($self, @criteria) = @_;
    my $cache  = $self->cache;
    my $data   = $self->data;
    my $ignore = $self->ignore;

    unless (UNIVERSAL::isa($data, 'HASH')) {
        Data::Seek::Exception->throw(
            message => 'DATA NOT A HASH REFERENCE OR BLESSED HASH OBJECT'
        );
    }

    my $search;

    if ($self->cache) {
        if ($search = $self->{cached_search}) {
            $search->criteria({});
        }
    }

    $search //= Data::Seek::Search->new(
        cache  => $cache,
        ignore => $ignore,
        data   => Data::Seek::Data->new(
            object => $data
        ),
    );

    $search->criterion($_) for @criteria;

    if ($self->cache) {
        $self->{cached_search} = $search;
    }
    else {
        $self->{cached_search} = undef;
    }

    return $search->result;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Seek - Search Complex Data Structures

=head1 VERSION

version 0.05

=head1 SYNOPSIS

    use Data::Seek;

    my $hash   = {...};
    my $seeker = Data::Seek->new(data => $hash);
    my $result = $seeker->search('*');

    $result->data;

=head1 DESCRIPTION

Data::Seek is a module for traversing complex data structures. This module
allows you to select specific node(s) in a hierarchical data structure using a
criteria. A criteria is an expression consisting of one or more criterion. A
criterion is the part of the criteria that is used to select node(s) and
sub-node(s) to be returned in the result. Data::Seek is akin to L<Data::Dpath>
but with far fewer features, a simpler node selection syntax, and a
non-recursive approach toward traversal which makes Data::Seek extremely fast
and efficient. An even better reason to use Data::Seek is its ability to throw
exception objects which explain, in detail, why a search failed. This is very
useful internally, and externally when processing foreign data structures where
you need to provide detailed errors explaining how to resolve the missing or
malformed data nodes. For more information on the underlying concepts, please
see L<Data::Seek::Concepts>.

=head1 ATTRIBUTES

=head2 cache

    $seeker->cache;
    $seeker->cache(1);

Encode the data structure and cache the result. Allows multiple queries to
execute faster. Caching is disabled by default.

=head2 data

    $seeker->data;
    $seeker->data(Data::Seek::Data->new(...));

The data structure to be introspected, must be a hash reference, blessed or not,
which defaults to or becomes a L<Data::Seek::Data> object.

=head2 ignore

    $seeker->ignore;
    $seeker->ignore(1);

Bypass exceptions thrown when a criterion finds an unknown or invalid node in
the data structure.

=head1 METHODS

=head2 search

    my @criteria = ('id', 'person.name.*');
    my $result   = $seeker->search(@criteria);

Prepare a search object to use the supplied criteria and return a result
object. Introspection is triggered when the result object is enacted. See
L<Data::Seek::Search::Result> for usage information.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
