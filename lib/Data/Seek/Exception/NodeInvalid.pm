# ABSTRACT: Data::Seek Invalid Node Exception Class
package Data::Seek::Exception::NodeInvalid;

use 5.10.0;

use strict;
use warnings;

use Mo;

extends 'Data::Seek::Exception';

our $VERSION = '0.03'; # VERSION

has 'criterion';
has 'separator';
has 'subject';
has 'target';

has 'was_array';
has 'was_ending';
has 'was_hash';
has 'was_match';

sub _build_message {
    my $self = shift;
    my $was_array = $self->was_array;
    my $was_hash  = $self->was_hash;

    my $type = $was_hash ? 'AN OBJECT' : $was_array ? 'A LIST' : 'INVALID';

    my @subject   = @{$self->subject};
    my @target    = @{$self->target};
    my $ending    = pop @subject;
    my $criterion = $self->criterion;
    my $separator = $self->separator // ' -> ';
    my $subject   = join $separator, @subject;
    my $target    = join $separator, @target;

    my $message = join ' ',
        'ERROR MATCHING CRITERION (%s):',
        'INVALID ENDING AT CHILD DATA/NODE (%s)',
        'UNDER (%s) WHILE SEEKING (%s), NODE VALUE IS %s (NOT A STRING)';

    return sprintf $message, $criterion, $ending, $subject, $target, $type;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Seek::Exception::NodeInvalid - Data::Seek Invalid Node Exception Class

=head1 VERSION

version 0.03

=head1 SYNOPSIS

    use Data::Seek::Exception::NodeInvalid;

=head1 DESCRIPTION

Data::Seek::Exception::NodeInvalid is an exception class within L<Data::Seek>
which is thrown when a criterion references a child node within the introspected
data structure which is not what was expected.

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

=head2 was_array

    $exception->was_array;

True if the node prior to the exception being thrown was an array reference.

=head2 was_ending

    $exception->was_ending;

True if the node prior to the exception being thrown was the end of the
structure.

=head2 was_hash

    $exception->was_hash;

True is the node prior to the exception being thrown was a hash reference.

=head2 was_match

    $exception->was_match;

True is the node prior to the exception being thrown had corresponding data.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
