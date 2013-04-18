use strict;
use warnings;
use Test::More;

use Crypt::PRNG qw(random_bytes random_bytes_hex random_bytes_b64 random_string random_string_from rand irand);

my $r = Crypt::PRNG->new();
ok($r, 'new');

{
 my $sum = 0;
 $sum += $r->double for (1..1000);
 my $avg = $sum/1000;
 ok($avg>0.4 && $avg<0.6, "rand $avg"); 
}

{
 my $sum = 0;
 $sum += $r->double(-180) for (1..1000);
 my $avg = $sum/1000;
 ok($avg>-95 && $avg<-85, "rand $avg"); 
}

{
 my $sum = 0;
 $sum += $r->int32 for (1..1000);
 my $avg = $sum/1000;
 ok($avg>2**30 && $avg<2**32, "rand $avg"); 
}

{
 my $sum = 0;
 $sum += rand(80) for (1..1000);
 my $avg = $sum/1000;
 ok($avg>37 && $avg<43, "rand $avg"); 
}

{
 my $sum = 0;
 $sum += rand(-180) for (1..1000);
 my $avg = $sum/1000;
 ok($avg>-95 && $avg<-85, "rand $avg"); 
}

{
 my $sum = 0;
 $sum += irand for (1..1000);
 my $avg = $sum/1000;
 ok($avg>2**30 && $avg<2**32, "rand $avg"); 
}

{
  like($r->string(45), qr/^[A-Z-a-z0-9]+$/, 'string');
  like($r->string_from("ABC,.-", 45), qr/^[ABC,\,\.\-]+$/, 'string');
  is(length $r->bytes(55), 55, "bytes");
  is(length $r->bytes_hex(55), 110, "bytes_hex");
  is(length $r->bytes_b64(60), 80, "bytes_b64");
  
  like(random_string(45), qr/^[A-Z-a-z0-9]+$/, 'string');
  like(random_string_from("ABC,.-", 45), qr/^[ABC,\,\.\-]+$/, 'string');
  is(length random_bytes(55), 55, "bytes");
  is(length random_bytes_hex(55), 110, "bytes_hex");
  is(length random_bytes_b64(60), 80, "bytes_b64");
}

done_testing;