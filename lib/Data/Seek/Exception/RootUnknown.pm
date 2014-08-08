# Data::Seek Unknown Root Exception Class
package Data::Seek::Exception::RootUnknown;

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
