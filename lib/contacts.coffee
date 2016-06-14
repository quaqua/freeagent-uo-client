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

module.exports.getAll = (url,result,token)->
  if( !token )
    token = @token
  url = url || 'https://api.freeagent.com/v2/contacts?per_page=100'
  console.log('getting contacts', url, token);
  result = result || {}
  agent
    .get( url )
    .set('Authorization', "Bearer #{token}")
    .set('Accept', 'application/json')
    .end()
    .then (res)->
      lodash.each res.body.contacts, (contact)->
        result[lodash.last(contact.url.split('/'))] = contact
      if( res.headers.link && res.headers.link.indexOf("rel='next") > 0 )
        links = res.headers.link.split(',')
        link = lodash.find(links, (i)->
          return i.indexOf("'next'") >= 0
        );
        if( link )
          link = lodash.first( link.split(';') ).replace(/[\<\>]/g,'')
          link = lodash.trim(link)
        return module.exports.getAll( link, result, token )
      result
    .catch (err)->
      console.log('error connecting to', '-'+url+'-');
      console.log('details:');
      console.log(err);
