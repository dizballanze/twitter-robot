Bot = require('bot').Bot

module.exports =
  debug: false
  db: 'mongodb://localhost:27017/twibot'
  accounts: [
    bot_class: Bot
    name: 'example'
    keywords: []
    langs: []
    stopwords: []
    unfavorite_interval: [10, 'hours']
    # Twitter app credentials https://apps.twitter.com/app/new
    consumer_key: ''
    consumer_secret: ''
    access_token: ''
    access_token_secret: ''
  ]