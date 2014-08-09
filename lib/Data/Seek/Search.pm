# ABSTRACT: Data::Seek Search Execution Class
package Data::Seek::Search;

use 5.10.0;
use strict;
use warnings;

use Data::Seek::Exception;
use Data::Seek::Exception::RootInvalid;
use Data::Seek::Exception::RootUnknown;
use Data::Seek::Exception::NodeInvalid;
use Data::Seek::Exception::NodeUnknown;
use Data::Seek::Search::Result;

use Mo 'default';

our $VERSION = '0.03'; # VERSION

has 'criteria',
    default => sub {{}};

has 'data',
    default => sub {{}};

has 'ignore',
    default => 0;

sub criterion {
    my $self = shift;
    my $expr = shift;

    Data::Seek::Exception->throw(
        message => 'INVALID CRITERION PROVIDED'
    )
    unless $expr && $expr =~ do {
        my $name = '[\w\*]+';
        my $indx = ':\d+';
        my $iter = '\@';

        my $sect = join '|',
            "(?:${indx}\\.|${indx}\$)",
            "(?:${iter}\\.|${iter}\$)",
            "(?:${name}\\.|${name}\$)",
            "(?:${name}${indx}\\.|${name}${indx}\$)";

        qr/^(?:${indx}|(${sect})+(?:${iter}|${name}(?:${indx})?)?)$/;
    };

    $self->criteria->{$expr} = keys %{$self->criteria};
    return $self;
}

sub perform {
    my $self = shift;
    my $data = $self->data;

    my $criteria = $self->criteria;
    $criteria = { reverse %$criteria };

    my $dataset = $data->encode;
    my @orders = sort keys %$criteria;
    my @criteria = @$criteria{@orders};

    my @results;

    for my $criterion (@criteria) {
        my @nodes     = keys %$dataset;
        my @selectors = split /\./, $criterion;
        @selectors = map { /([^\.]+):(\d+)/ ? ($1, ":$2") : $_ } @selectors;

        my @expressions;
        for (my $i=0; $i<@selectors; $i++) {
            my $first = $i == 0;
            my $last  = $i == $#selectors;

            my $selector  = $selectors[$i];
            my $query     = quotemeta $selector;
            my $keys      = [];

            my $token;
            my $regex;

            $token  = quotemeta '\@';
            $regex  = ':\d+';
            $query =~ s/^$token$/$regex/g;

            $token  = quotemeta '\*';
            $token  = sprintf '(?:%s){2,}', $token;
            $regex  = '.*';
            $query  =~ s/$token/$regex/g;

            $token  = quotemeta '\*';
            $token  = sprintf '(?:%s){1}', $token;
            $regex  = '[^\.]+';
            $query  =~ s/$token/$regex/g;

            push @expressions, $query;
        }

        my $was_match  = 0;
        my $was_array  = 0;
        my $was_hash   = 0;
        my $was_ending = 0;

        for (my $i=0; $i<@expressions; $i++) {
            my $first = $i == 0;
            my $last  = $i == $#expressions;
            my @steps = grep defined, @selectors[0..$i];
            my @query = @expressions[0..$i];

            my $query = shift @query;
            $query .= join '', map { /^\\?:/ ? $_ : '\.' . $_ } @query;

            my $index = $steps[-1] =~ /^\@|[^\.]+:\d+$/;

            my $is_match  = 0;
            my $is_array  = 0;
            my $is_hash   = 0;
            my $is_ending = 0;

            $is_array = grep /^$query/,     @nodes if $index;
            $is_array = grep /^$query:\d+/, @nodes if !$index;
            $is_hash  = grep /^$query\./,   @nodes;

            $is_match  = @nodes = grep /^$query/,  @nodes;
            $is_ending = @nodes = grep /^$query$/, @nodes if $last;

            if (@nodes) {
                $was_match  = $is_match;
                $was_array  = $is_array;
                $was_hash   = $is_hash;
                $was_ending = $is_ending;
            }

            unless (@nodes) {
                last if $self->ignore;

                my $format = sub {
                    my $expr = shift;
                    return "[0]"        if $expr =~ /\@/;
                    return "[$1]"       if $expr =~ /:(\d+)/;
                    return ($1, "[$2]") if $expr =~ /(.*):(\d+)/;
                    return "{...}"      if $expr =~ /\*+/;
                    return $_;
                };

                my $subject = [ map $format->($_), @steps ];
                my $target  = [ map $format->($_), @selectors ];

                if ($first) {
                    if (!$is_match) {
                        Data::Seek::Exception::RootUnknown->throw(
                            criterion => $criterion,
                            subject   => $subject,
                            target    => $target,
                            is_array  => $is_array,
                            is_ending => $is_ending,
                            is_hash   => $is_hash,
                            is_match  => $is_match,
                        );
                    }
                    elsif ($is_match && !$is_hash && !$is_array) {
                        Data::Seek::Exception::RootUnknown->throw(
                            criterion => $criterion,
                            subject   => $subject,
                            target    => $target,
                            is_array  => $is_array,
                            is_ending => $is_ending,
                            is_hash   => $is_hash,
                            is_match  => $is_match,
                        );
                    }
                    else {
                        Data::Seek::Exception::RootInvalid->throw(
                            criterion => $criterion,
                            subject   => $subject,
                            target    => $target,
                            is_array  => $is_array,
                            is_ending => $is_ending,
                            is_hash   => $is_hash,
                            is_match  => $is_match,
                        );
                    }
                }
                else {
                    if (!$was_match) {
                        Data::Seek::Exception::NodeUnknown->throw(
                            criterion  => $criterion,
                            subject    => $subject,
                            target     => $target,
                            was_array  => $was_array,
                            was_ending => $was_ending,
                            was_hash   => $was_hash,
                            was_match  => $was_match,
                        );
                    }
                    elsif ($was_match && !$was_hash && !$was_array) {
                        Data::Seek::Exception::NodeUnknown->throw(
                            criterion  => $criterion,
                            subject    => $subject,
                            target     => $target,
                            was_array  => $was_array,
                            was_ending => $was_ending,
                            was_hash   => $was_hash,
                            was_match  => $was_match,
                        );
                    }
                    else {
                        Data::Seek::Exception::NodeInvalid->throw(
                            criterion  => $criterion,
                            subject    => $subject,
                            target     => $target,
                            was_array  => $was_array,
                            was_ending => $was_ending,
                            was_hash   => $was_hash,
                            was_match  => $was_match,
                        );
                    }
                }
            }
        }
        my $result = {nodes => [sort @nodes], criterion => $criterion};
        push @results, $result;
    }

    my $output = [];
    for my $result (@results) {
        $$result{dataset} = {map { $_ => $$dataset{$_} } @{$$result{nodes}}};
        push @$output, $result;
    }

    return $output;
}

sub result {
    return Data::Seek::Search::Result->new(
        search => shift
    );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Seek::Search - Data::Seek Search Execution Class

=head1 VERSION

version 0.03

=head1 SYNOPSIS

    use Data::Seek::Search;

=head1 DESCRIPTION

Data::Seek::Search is a class within L<Data::Seek> which provides the search
mechanism for introspecting data structures.

=head1 ATTRIBUTES

=head2 criteria

    $search->criteria;
    $search->criteria({
        '*'                       => 0,
        'person.name.first'       => 1,
        'person.name.last'        => 2,
        'person.settings.@.name'  => 3,
        'person.settings.@.type'  => 4,
        'person.settings.@.value' => 5,
    });

A collection of criterion which will be used to match nodes within the data
structure when introspected, in the order registered.

=head2 data

    $search->data;
    $search->data(Data::Seek::Data->new(...));

The data structure to be introspected, must be a hash reference, blessed or not,
which defaults to or becomes a L<Data::Seek::Data> object.

=head2 ignore

    $search->ignore;
    $search->ignore(1);

Bypass exceptions thrown when a criterion finds an unknown or invalid node in
the data structure.

=head1 METHODS

=head2 criterion

    $search->criterion('*');

Register a criterion to be used to introspect the registered data structure. A
criterion is only valid if it begins with a array index, and array iterator, or
a node key; Also can only contain letters, numbers, underscores, periods, and
semi-colons. See L<Data::Seek::Concepts> for more information.

=head2 perform

    my $dataset = $search->perform;

Introspect the data structure using the registered criteria and settings, and
return a result set of operations and matching data nodes.

=head2 result

    my $result = $search->result;

Return a search result object, L<Data::Seek::Search::Result>, based on the
current search object.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
