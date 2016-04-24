#!perl

use strict;
use warnings;

package Utils::Tester;

use Moo;
with 'Business::Mondo::Utils';

package main;

use Test::Most;
use Test::Deep;
use Test::Exception;
use MIME::Base64 qw/ decode_base64 /;

use Business::Mondo::Utils;

my $Utils = Utils::Tester->new;

my $params = {
    id                => "AKJ398H8KA",
    status            => "paid",
    source_type       => "subscription",
    source_id         => "KKJ398H8K8",
    amount            => "20.0",
    amount_minus_fees => "19.8",
    paid_at           => "2011-12-01T12:00:00Z",
    uri               => "https://gocardless.com/api/v1/bills/AKJ398H8KA"
};

my $normalized = 'amount=20.0&amount_minus_fees=19.8&id=AKJ398H8KA&paid_at=2011-12-01T12%3A00%3A00Z&source_id=KKJ398H8K8&source_type=subscription&status=paid&uri=https%3A%2F%2Fgocardless.com%2Fapi%2Fv1%2Fbills%2FAKJ398H8KA';

is(
    $Utils->normalize_params( $params,1 ),
    $normalized,
    'normalize_params with complex params'
);

cmp_deeply(
    { $Utils->_params_as_array_string( 'yuck',$params ) },
    {
      'yuck[amount]' => '20.0',
      'yuck[amount_minus_fees]' => '19.8',
      'yuck[id]' => 'AKJ398H8KA',
      'yuck[paid_at]' => '2011-12-01T12:00:00Z',
      'yuck[source_id]' => 'KKJ398H8K8',
      'yuck[source_type]' => 'subscription',
      'yuck[status]' => 'paid',
      'yuck[uri]' => 'https://gocardless.com/api/v1/bills/AKJ398H8KA'
    },
    '_params_as_array_string',
);

done_testing();
