agent       = require 'superagent-promise'

module.exports.get = (url)->
  agent
    .get(url)
    .set('Authorization', "Bearer #{@token}")
    .set('Accept', 'application/json')
    .end()
    .then (res)->
      res.body.bank_account

module.exports.getAll = ->
  agent
    .get('https://api.freeagent.com/v2/bank_accounts')
    .set('Authorization', "Bearer #{@token}")
    .set('Accept', 'application/json')
    .end()
    .then (res)->
      res.body.bank_accounts