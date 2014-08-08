# ABSTRACT: Data::Seek Search Result Class
package Data::Seek::Search::Result;

use 5.10.0;
use strict;
use warnings;

use Data::Seek::Data;
use Data::Seek::Exception;
use Data::Seek::Search;

use Mo 'builder';

our $VERSION = '0.01'; # VERSION

has 'datasets',
    builder => '_build_datasets';

sub _build_datasets {
    my $self = shift;
    my $search = $self->search;
    return $search->perform;
}

has 'search',
    default => sub { Data::Seek::Search->new };

sub data {
    my $self = shift;
    my $sets = $self->datasets;
    my $data = {};

    for my $set (@$sets) {
        for my $node (@{$$set{nodes}}) {
            $$data{$node} = $$set{dataset}{$node};
        }
    }

    $data = Data::Seek::Data->new(object => $data);
    return $data->decode;
}

sub nodes {
    my $self = shift;
    my $sets = $self->datasets;
    my $keys = [];

    for my $set (@$sets) {
        push @$keys, sort @{$$set{nodes}};
    }

    return $keys;
}

sub values {
    my $self = shift;
    my $sets = $self->datasets;
    my $vals = [];

    for my $set (@$sets) {
        push @$vals, $$set{dataset}{$_} for sort @{$$set{nodes}};
    }

    return $vals;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Seek::Search::Result - Data::Seek Search Result Class

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    use Data::Seek::Search::Result;

=head1 DESCRIPTION

Data::Seek::Search::Result is a module for ... .

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
