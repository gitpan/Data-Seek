requires "Hash::Flatten" => "1.19";
requires "Mo" => "0.38";
requires "perl" => "v5.10.0";

on 'test' => sub {
  requires "perl" => "v5.10.0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
