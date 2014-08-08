# Data::Seek Unknown Node Exception Class
package Data::Seek::Exception::NodeUnknown;

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

    my @subject   = @{$self->subject};
    my @target    = @{$self->target};
    my $ending    = pop @subject;
    my $criterion = $self->criterion;
    my $separator = $self->separator // ' -> ';
    my $subject   = join $separator, @subject;
    my $target    = join $separator, @target;

    my $message = join ' ',
        'ERROR MATCHING CRITERION (%s):',
        'NO CHILD DATA/NODE (%s) FOUND AT (%s) WHILE SEEKING (%s)';

    return sprintf $message, $criterion, $ending, $subject, $target;
}

1;
