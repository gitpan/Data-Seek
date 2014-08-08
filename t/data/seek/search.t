use Test::More;

my $c = 'Data::Seek::Search';
my @a = qw(criteria data);
my @m = qw(new criterion perform result);
eval "require $c";

ok !$@ or diag $@;
can_ok $c => ('new', @a, @m);
isa_ok $c->new, $c;

my $search = Data::Seek::Search->new;
$search->criterion('*');
$search->criterion('@.*');
$search->criterion('@.*.id');

ok ! eval { $search->criterion('@@') };
ok $@;

ok 1 and done_testing;
