#
# freeagent middleware
#

Client        = require './client'
Promise       = require 'bluebird'

module.exports.getBankAccounts = (req,res,next)->
  freeAgent = new Client( req.user.token )
  freeAgent
    .getBankAccounts()
    .then (bankAccounts)->
      res.locals.bankAccounts = bankAccounts
      next()

module.exports.getAllBankAccountsTransactionExplanations = (req,res,next)->
  res.locals.transactions = res.locals.transactions || []
  freeAgent = new Client( req.user.token )

  if !req.body.url || req.body.url == 'all'
    Promise
      .each res.locals.bankAccounts, (bankAccount)->
        freeAgent
          .getTransactionExplanations( bankAccount.url, res.locals.from_date, res.locals.to_date )
          .then (bankTransactionExplanations)->
            if bankTransactionExplanations
              res.locals.transactions = res.locals.transactions.concat bankTransactionExplanations
      .then ->
        next()
    return

  freeAgent
    .getTransactionExplanations( req.body.url, res.locals.from_date, res.locals.to_date )
    .then (bankTransactionExplanations)->
      if bankTransactionExplanations
        res.locals.transactions = res.locals.transactions.concat bankTransactionExplanations
      next()

module.exports.getTransactionExplanationsByBankAccount = (req,res,next)->
  res.locals.transactions = res.locals.transactions || []
  freeAgent = new Client( req.user.token )
  freeAgent
    .getTransactionExplanations( req.body.url, res.locals.from_date, res.locals.to_date )
    .then (bankTransactionExplanations)->
      if bankTransactionExplanations
        res.locals.transactions = res.locals.transactions.concat bankTransactionExplanations
      next()

module.exports.getTransactionsByBankAccount = (req,res,next)->
  res.locals.transactions = res.locals.transactions || []
  freeAgent = new Client( req.user.token )
  freeAgent
    .getTransactions( req.body.url, res.locals.from_date, res.locals.to_date )
    .then (bankTransactions)->
      if bankTransactions
        res.locals.transactions = res.locals.transactions.concat bankTransactions
      next()

module.exports.getCategories = (req,res,next)->
  freeAgent = new Client( req.user.token )
  freeAgent
    .getCategories()
    .then (categories)->
      res.locals.categories = categories
      next()

module.exports.getContacts = (req,res,next)->
  freeAgent = new Client( req.user.token )
  freeAgent
    .getContacts()
    .then (contacts)->
      res.locals.contacts = contacts
      next()

module.exports.getBankAccount = (req,res,next)->
  freeAgent = new Client( req.user.token )
  freeAgent
    .getBankAccount( req.body.url )
    .then (bankAccount)->
      res.locals.bankAccount = bankAccount
      next()
