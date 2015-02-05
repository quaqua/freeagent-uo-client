# freeagent-uo-client library

a simple *unofficial* freeagent client library using superagent.

This library was written in order to receive transactions and collect all related information for further computation.

## usage

You need a valid token from freeagent (how to obtain a token is suggested below).

    :::coffeescript
    FreeAgent = require 'freeagent-uo-client'
    client = new FreeAgent.Client( '<YOUR_TOKEN>' )

    client
      .getBankAccounts()
      .then (bankAccounts)->
        # returns a list of bank accounts

## obtaining a token

This library does not implement a web server. Yo have to write your own. In the example's folder is a server setup 
using expressjs. It is just a rough copy and paste from the main project using freeagent-uo-client, but should give an
idea

## middleware methods

There is a bunch of middleware methods which can be required with:

    :::coffeescript
    faMw = require 'freeagent-uo-client/middleware'

### .getAllBankAccountsTransactionExplanations

needs:

    res.locals.url - the bank account's full url (see freeagent api doc) or null or 'all' to obtain all transaction_explanations
    res.locals.from_date - start from e.g.: 2014-01-01
    res.locals.to_date - end at e.g.: 2014-01-31

parameters:

    ( req, res, next )

sets:

    res.locals.transactions (Array)


### .getBankAccounts

paramters:

    ( req, res, next )

sets:

    res.locals.bankAccounts (Array)

### .getCategories

sets:

    res.locals.categories (Object with ids as keys)

### .getContacts

sets:

    res.locals.contacts (Object with ids as keys)



