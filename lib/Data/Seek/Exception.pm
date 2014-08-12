# Data::Seek Exception Class
package Data::Seek::Exception;

use 5.10.0;

use strict;
use warnings;

use Mo 'builder';

use Data::Dumper ();
use Scalar::Util ();

use overload fallback => 1, '""' => \&as_string;

our $VERSION = '0.05'; # VERSION

has 'code';
has 'file';
has 'line';

has 'message',
    builder => '_build_message';

sub _build_message {
    sprintf 'An unknown error occurred in class (%s)',
        ref shift
}

has 'package';
has 'subroutine';

sub as_string {
    my $self = shift;

    return sprintf "%s at %s line %s\n",
        $self->message, $self->file, $self->line;
}

sub caught {
    my $class = shift;
    my $e     = shift;

    return ! ref $class
        && Scalar::Util::blessed($e)
        && UNIVERSAL::isa($e, $class);
}

sub dumper {
    local $Data::Dumper::Terse = 1;
    return Data::Dumper::Dumper(pop);
}

sub rethrow {
    die shift;
}

sub throw {
    my ($class, %args) = @_;

    $args{subroutine} = (caller(1))[3];
    $args{package}    = (caller(0))[0];
    $args{file}       = (caller(0))[1];
    $args{line}       = (caller(0))[2];

    die $class->new(%args);
}

sub throw_subclass {
    my ($class, $subspace, %args) = @_;
    my $subclass = join '::', $class, $subspace;

    # gen exception sub-class dynamically if not loaded
    eval "package ${subclass}; use parent '@{[$class]}'; 1;";

    # throw generated exception
    @_ = ($class, %args);
    goto $subclass->can('throw');
}

1;
