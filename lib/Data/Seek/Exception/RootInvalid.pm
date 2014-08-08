# Data::Seek Invalid Root Exception Class
package Data::Seek::Exception::RootInvalid;

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
    my $is_array = $self->is_array;
    my $is_hash  = $self->is_hash;

    my $type = $is_hash ? 'AN OBJECT' : $is_array ? 'A LIST' : 'INVALID';

    my $criterion = $self->criterion;
    my $separator = $self->separator // ' -> ';
    my $subject   = join $separator, @{$self->subject};
    my $target    = join $separator, @{$self->target};

    my $message = join ' ',
        'ERROR MATCHING CRITERION (%s):',
        'INVALID ENDING OF ROOT DATA/NODE (%s)',
        'WHILE SEEKING (%s), NODE VALUE IS %s (NOT A STRING)';

    return sprintf $message, $criterion, $subject, $target, $type;
}

1;
