# ABSTRACT: Data::Seek Unknown Root Exception Class
package Data::Seek::Exception::RootUnknown;

use 5.10.0;

use strict;
use warnings;

use Mo;

extends 'Data::Seek::Exception';

our $VERSION = '0.04'; # VERSION

has 'criterion';
has 'separator';
has 'subject';
has 'target';

has 'is_array';
has 'is_ending';
has 'is_hash';
has 'is_match';

sub _build_message {
    my $self = shift;

    my $criterion = $self->criterion;
    my $separator = $self->separator // ' -> ';
    my $subject   = join $separator, @{$self->subject};
    my $target    = join $separator, @{$self->target};

    my $message = join ' ',
        'ERROR MATCHING CRITERION (%s):',
        'NO ROOT DATA/NODE (%s) FOUND WHILE SEEKING (%s)';

    return sprintf $message, $criterion, $subject, $target;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Seek::Exception::RootUnknown - Data::Seek Unknown Root Exception Class

=head1 VERSION

version 0.04

=head1 SYNOPSIS

    use Data::Seek::Exception::NodeInvalid;

=head1 DESCRIPTION

Data::Seek::Exception::NodeInvalid is a module for is an exception class within
L<Data::Seek> which is thrown when a criterion references a root node within the
introspected data structure which does not exist.

=head1 ATTRIBUTES

=head2 criterion

    $exception->criterion;

The criterion used against the data which resulted in the exception.

=head2 separator

    $exception->separator;

The separator used to denote the hierarchy of the match data and the criterion.

=head2 subject

    $exception->subject;

The hierarchy of the match data as an array reference.

=head2 target

    $exception->target;

The hierarchy of the criterion as an array reference.

=head2 is_array

    $exception->is_array;

True if the node is, during the exception being thrown, an array reference.

=head2 is_ending

    $exception->is_ending;

True if the node is, during the exception being thrown, the end of the structure.

=head2 is_hash

    $exception->is_hash;

True is the node is, during the exception being thrown, a hash reference.

=head2 is_match

    $exception->is_match;

True is the node has, during the exception being thrown, corresponding data.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
