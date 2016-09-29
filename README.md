# NAME

Business::Monzo - Perl library for interacting with the Monzo API
(https://api.getmonzo.co.uk)

<div>

    <a href='https://travis-ci.org/leejo/business-monzo?branch=master'><img src='https://travis-ci.org/leejo/business-monzo.svg?branch=master' alt='Build Status' /></a>
    <a href='https://coveralls.io/r/leejo/business-monzo?branch=master'><img src='https://coveralls.io/repos/leejo/business-monzo/badge.png?branch=master' alt='Coverage Status' /></a>
</div>

# VERSION

0.06

# DESCRIPTION

Business::Monzo is a library for easy interface to the Monzo banking API,
it implements all of the functionality currently found in the service's API
documentation: [https://getmonzo.co.uk/docs](https://getmonzo.co.uk/docs)

**You should refer to the official Monzo API documentation in conjunction**
**with this perldoc**, as the official API documentation explains in more depth
some of the functionality including required / optional parameters for certain
methods.

Please note this library is very much a work in progress, as is the Monzo API.
Also note the Monzo were previously called Mondo, so if you see any references
to Mondo they are either typos or historical references that have not yet been
updated to reflect the changes.

All objects within the Business::Monzo namespace are immutable. Calls to methods
will, for the most part, return new instances of objects.

# SYNOPSIS

    my $monzo = Business::Monzo->new(
        token   => $token, # REQUIRED
        api_url => $url,   # optional
    );

    # transaction related information
    my @transactions = $monzo->transactions( account_id => $account_id );

    my $Transaction  = $monzo->transaction( id => 1 );

    $Transaction->annotate(
        foo => 'bar',
        baz => 'boz,
    );

    my $annotations = $Transaction->annotations;

    # account related information
    my @accounts = $monzo->accounts;

    foreach my $Account ( @accounts ) {

        my @transactions = $Account->transactions;

        $Account->add_feed_item(
            params => {
                title     => 'My Feed Item',
                image_url => 'http://...',
            }
        );

        # balance information
        my $Balance = $Account->balance;

        # webhooks
        my @webhooks = $Account->webhooks;

        my $Webhook = $Account->register_webhook(
            callback_url => 'http://www.foo.com',
        );

        $Webhook->delete
    }

    # attachments
    my $Attachment = $monzo->upload_attachment(
        file_name => 'foo.png',
        file_type => 'image/png',
    );

    $Attachment->register(
        external_id => 'my_id'
    );

    $Attachment->deregister;

# ERROR HANDLING

Any problems or errors will result in a Business::Monzo::Exception
object being thrown, so you should wrap any calls to the library in the
appropriate error catching code (ideally a module from CPAN):

    try {
        ...
    }
    catch ( Business::Monzo::Exception $e ) {
        # error specific to Business::Monzo
        ...
        say $e->message;  # error message
        say $e->code;     # HTTP status code
        say $e->response; # HTTP status message

        # ->request may not always be present
        say $e->request->{path}    if $e->request
        say $e->request->{params}  if $e->request
        say $e->request->{headers} if $e->request
        say $e->request->{content} if $e->request
    }
    catch ( $e ) {
        # some other failure?
        ...
    }

You can view some useful debugging information by setting the MONZO\_DEBUG
env varible, this will show the calls to the Monzo endpoints as well as a
stack trace in the event of exceptions:

    $ENV{MONZO_DEBUG} = 1;

# ATTRIBUTES

## token

Your Monzo access token, this is required

## api\_url

The Monzo url, which will default to https://api.getmonzo.co.uk

## client

A Business::Monzo::Client object, this will be constructed for you so
you shouldn't need to pass this

# METHODS

In the following %query\_params refers to the possible query params as shown in
the Monzo API documentation. For example: limit=100.

    # transactions in the previous month
    my @transactions = $monzo->transactions(
        since => DateTime->now->subtract( months => 1 ),
    );

## transactions

    $monzo->transactions( %query_params );

Get a list of transactions. Will return a list of [Business::Monzo::Transaction](https://metacpan.org/pod/Business::Monzo::Transaction)
objects. Note you must supply an account\_id in the params hash;

## balance

    my $Balance = $monzo->balance( account_id => $account_id );

Get an account balance Returns a [Business::Monzo::Balance](https://metacpan.org/pod/Business::Monzo::Balance) object.

## transaction

    my $Transaction = $monzo->transaction(
        id     => $id,
        expand => 'merchant'
    );

Get a transaction. Will return a [Business::Monzo::Transaction](https://metacpan.org/pod/Business::Monzo::Transaction) object

## accounts

    $monzo->accounts;

Get a list of accounts. Will return a list of [Business::Monzo::Account](https://metacpan.org/pod/Business::Monzo::Account)
objects

# EXAMPLES

See the t/002\_end\_to\_end.t test included with this distribution. you can run
this test against the Monzo emulator by running end\_to\_end\_emulated.sh (this
is advised, don't run it against a live endpoint).

# SEE ALSO

[Business::Monzo::Account](https://metacpan.org/pod/Business::Monzo::Account)

[Business::Monzo::Attachment](https://metacpan.org/pod/Business::Monzo::Attachment)

[Business::Monzo::Balance](https://metacpan.org/pod/Business::Monzo::Balance)

[Business::Monzo::Transaction](https://metacpan.org/pod/Business::Monzo::Transaction)

[Business::Monzo::Webhook](https://metacpan.org/pod/Business::Monzo::Webhook)

# AUTHOR

Lee Johnson - `leejo@cpan.org`

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/leejo/business-monzo
