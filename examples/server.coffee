# this is just a rough copy and paste from my main project
# which I used with the freeagent-client library
#
settings = {
  hostname: ''
  port: ''
  clientId: ''
  clientSecret: ''
}

express         = require 'express'
passport        = require 'passport'
freeAgent       = require 'freeagent-client/middleware'

# the following suggests to hold the user's data somewhere
# this could be done with cookies or session store as well
fs              = require('fs')
join            = require('path').join
OAuth2Strategy  = require('passport-oauth2')

usersFile       = join __dirname, '..', 'users.json'

if !fs.existsSync(usersFile)
  fs.writeFileSync(usersFile, '{}')

users           = JSON.parse fs.readFileSync usersFile


passport.serializeUser (user, done)->
  users[user.token] = user
  fs.writeFileSync( usersFile, JSON.stringify(users))
  done(null, user.token)

passport.deserializeUser (token, done)->
  return done() unless users[token]
  done( null, users[token] )

callbackPort = if process.env.NODE_ENV == 'development' then ":#{settings.port}" else ''
callbackURL = "#{settings.hostname}#{callbackPort}/login/callback"

passport.use new OAuth2Strategy
  authorizationURL: 'https://api.freeagent.com/v2/approve_app'
  tokenURL: 'https://api.freeagent.com/v2/token_endpoint'
  clientID: settings.auth.clientId
  clientSecret: settings.auth.clientSecret
  callbackURL: callbackURL
  customHeaders: { 'Accept': 'application/json' }
  , (accessToken, refreshToken, profile, done)->
    user =
      token: accessToken
      refresh: refreshToken
      expires: moment().add('hours',6).toDate()

    # users[accessToken] = user
    done( null, user )

app = express()
app.use passport.initialize()
app.use passport.session()
  

app.get '/login',
  passport.authenticate 'oauth2',
    failureRedirect: '/login'
    successRedirect: '/'
    failureFlash: true

app.get '/login/callback',
  passport.authenticate 'oauth2',
    failureRedirect: '/login'
    failureFlash: true
    successRedirect: '/'