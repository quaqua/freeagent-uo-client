agent       = require 'superagent-promise'
lodash      = require 'lodash'

module.exports.get = (url)->
  agent
    .get(url)
    .set('Authorization', "Bearer #{@token}")
    .set('Accept', 'application/json')
    .end()
    .then (res)->
      res.body.bank_account

module.exports.getAll = (url,result)->
  url = url || 'https://api.freeagent.com/v2/contacts?per_page=100'
  result = result || {}
  agent
    .get( url )
    .set('Authorization', "Bearer #{@token}")
    .set('Accept', 'application/json')
    .end()
    .then (res)->
      lodash.each res.body.contacts, (contact)->
        result[lodash.last(contact.url.split('/'))] = contact
      if( res.headers.link && res.headers.link.indexOf("rel=\'next") > 0 )
        link = lodash.first( res.headers.link.split(';') ).replace(/[\<\>]/g,'')
        return module.exports.getAll( url, result )
      result