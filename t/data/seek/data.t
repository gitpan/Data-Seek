use Test::More;

my $c = 'Data::Seek::Data';
my @a = qw(object);
my @m = qw(decode encode);
eval "require $c";

ok !$@ or diag $@;
can_ok $c => ('new', @a, @m);
isa_ok $c->new, $c;

ok 1 and done_testing;
