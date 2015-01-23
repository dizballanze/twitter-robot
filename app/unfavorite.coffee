###
Remove favorites from twitter older then specified time interval.
###


async = require 'async'
moment = require 'moment'
Twit = require 'twit'
models = require './models'
FavoriteTweet = models.FavoriteTweet


exports = module.exports = (config)->
  async.each config.accounts, (acc, finish)->
    account = acc.name
    if not acc.unfavorite_interval?
      return console.log "#{} account was skipped, cause unfavorite_interval param is not setted"

    # Create connection to twitter API
    T = new Twit
      consumer_key: acc.consumer_key
      consumer_secret: acc.consumer_secret
      access_token: acc.access_token
      access_token_secret: acc.access_token_secret

    # Fetch old favorite tweets not removed yet
    remove_date = moment().subtract acc.unfavorite_interval...
    FavoriteTweet.find
      created_at: {$lt: remove_date}
      account: account
      is_removed: no
    , (err, tweets)->
      throw err if err
      console.log "#{tweets.length} tweets to remove for #{account}"
      async.eachSeries tweets, (tweet, cb)->
        T.post 'favorites/destroy', {id: tweet.identifier}, (err, data)->
          if err
            if err.code = 34
              console.log "Tweet was already removed"
              return cb null
            else
              return cb err  # Already removed
          # Mark tweet as removed
          tweet.is_removed = yes
          tweet.save cb
      , (err)->
        if err
          if err.code == 88
            console.log "#{account} achieved rate limit"
          else
            console.log "uknown error", err
        else
          console.log "#{account} is clear!"
          finish()
  , ->
    process.exit()