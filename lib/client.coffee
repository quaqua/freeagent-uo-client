agent       = require 'superagent-promise'
lodash      = require 'lodash'

class Client

  constructor: (token)->
    @token = token

  getBankAccounts: require('./bank_accounts').getAll
  getBankAccount: require('./bank_accounts').get
  getTransactionExplanations: require('./transaction_explanations').get
  getTransactions: require('./transactions').get
  getCategories: require('./categories').getAll
  getContacts: require('./contacts').getAll

  getUrl: (url, keyName, result)->
    console.log 'get url', url
    agent
      .get(url)
      .set('Authorization', "Bearer #{@token}")
      .set('Accept', 'application/json')
      .end()
      .then (res)=>
        result = result.concat( res.body[keyName] )
        if( res.headers.link && res.headers.link.indexOf("rel=\'next") > 0 )
          link = lodash.first( res.headers.link.split(';') ).replace(/[\<\>]/g,'')
          return @getUrl( link, keyName, result )
        result

module.exports = Client
