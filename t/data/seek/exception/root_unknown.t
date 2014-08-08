use Test::More;

my $c = 'Data::Seek::Exception::RootUnknown';
my @a = qw(code file line message package subroutine);
my @m = qw(new as_string caught dumper rethrow throw throw_subclass);
eval "require $c";

ok !$@ or diag $@;
can_ok $c => ('new', @a, @m);

ok 1 and done_testing;
