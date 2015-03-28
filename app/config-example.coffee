Bot = require('bot').Bot

module.exports =
  debug: false
  db: 'mongodb://localhost:27017/twibot'
  accounts: [
    # Bot class
    # currently available: `Bot` and `DaytimeBot`
    # but you can create yours
    bot_class: Bot
    # Project name. It is used for logging and unique constraints by users.
    name: 'example'
    # keywords to search by
    keywords: []
    # if not empty - filter all tweets with languages not in list
    langs: []
    # if ward was found in tweet it would be skipped
    stopwords: []
    # skip (or not) retweets
    filter_retweets: yes
    # twitter filter_lave, can has values 'none', 'low' or 'medium'
    # see https://blog.twitter.com/2013/introducing-new-metadata-for-tweets
    filter_level: 'low'
    # automatic unfavorite after specified interval
    # you should periodically run bin/unfavorite, with crontab for example
    unfavorite_interval: [10, 'hours']
    # Twitter app credentials https://apps.twitter.com/app/new
    consumer_key: ''
    consumer_secret: ''
    access_token: ''
    access_token_secret: ''
  ]