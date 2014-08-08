use Test::More;

my $c = 'Data::Seek::Exception';
my @a = qw(code file line message package subroutine);
my @m = qw(new as_string caught dumper rethrow throw throw_subclass);
eval "require $c";

ok !$@ or diag $@;
can_ok $c => ('new', @a, @m);

my $o = $c->new;
isa_ok $o, $c;
is $o->message, "An unknown error occurred in class ($c)";

my $exc;

eval { Data::Seek::Exception->throw };
$exc = $@;
is $exc->line, '17';
is $exc->code, undef;
is $exc->package, 'main';
like $exc->file, qr/t\/data\/seek\/exception\.t/;
is $exc->subroutine, '(eval)';

eval { Data::Seek::Exception->throw(code => 12345) };
$exc = $@;
is $exc->line, '25';
is $exc->code, '12345';
is $exc->package, 'main';
like $exc->file, qr/t\/data\/seek\/exception\.t/;
is $exc->subroutine, '(eval)';

eval {
    Data::Seek::Exception->throw_subclass(
        Critical => (code => 12345)
    )
};
$exc = $@;
isa_ok $exc, $c;
is $exc->line, '34';
is $exc->code, '12345';
is $exc->package, 'main';
like $exc->file, qr/t\/data\/seek\/exception\.t/;
is $exc->subroutine, '(eval)';

ok 1 and done_testing;
