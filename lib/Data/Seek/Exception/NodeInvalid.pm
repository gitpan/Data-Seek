# Data::Seek Invalid Node Exception Class
package Data::Seek::Exception::NodeInvalid;

use 5.10.0;

use strict;
use warnings;

use Mo;

extends 'Data::Seek::Exception';

our $VERSION = '0.01'; # VERSION

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
