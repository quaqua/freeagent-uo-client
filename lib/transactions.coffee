lodash      = require 'lodash'

module.exports.get = (bankAccountUrl, from_date, to_date, page)->
  url = 'https://api.freeagent.com/v2/bank_transactions'
  url += "?bank_account=#{lodash.last(bankAccountUrl.split('/'))}"
  url += "&from_date=#{from_date}"
  url += "&to_date=#{to_date}"
  url += "&per_page=#{100}"
  @getUrl( url, 'bank_transactions', [] )
