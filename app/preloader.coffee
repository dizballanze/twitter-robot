###
Script for preload currently existed favorite tweets
from accounts in config
###

async = require 'async'
Twit = require 'twit'
models = require './models'
NoticedUser = models.NoticedUser
FavoriteTweet = models.FavoriteTweet


exports = module.exports = (config)->
  async.each config.accounts, (acc, finish)->
    account = acc.name
    # Create connection to twitter API
    T = new Twit
      consumer_key: acc.consumer_key
      consumer_secret: acc.consumer_secret
      access_token: acc.access_token
      access_token_secret: acc.access_token_secret

    # Function get and process favs page
    process = (max_id, complete_cb)->
      params = count: 200
      params.max_id = max_id if max_id?
      T.get 'favorites/list', params, (err, tweets)->
        # Process error in API call
        if err
          console.error err
          complete_cb err, max_id if complete_cb
          return
        console.log "process #{tweets.length} tweets since #{max_id} at #{account}"
        # If returned zero results
        unless tweets.length
          complete_cb null, 0 if complete_cb
          return
        # Process results array
        async.eachLimit tweets, 5, (tweet, callback)->
          date = new Date tweet.created_at
          async.parallel [
            (cb)->
              user = new NoticedUser
                username: tweet.user.screen_name
                account: account
                noticed_at: date
              user.save (err)->
                cb null  # ignore error cause of duplicate key

            (cb)->
              fav = new FavoriteTweet
                identifier: tweet.id_str
                created_at: date
                is_remove: tweet.favorited
                account: account
              fav.save (err)->
                console.log "duplicate tweet error" if err
                cb null  # ignore error cause of duplicate key
          ], callback
        , (err)->
          if tweets.length == 1
            last_id = null
          else
            last_id = tweets[tweets.length-1].id_str
          return complete_cb err, last_id if complete_cb
          throw err if err

    # Callback for process page function
    complete_cb = (err, last_id)->
      if err
        # Try again later if rate limit error from twitter API
        if err.code == 88
          console.log "Rate limit for account #{account}. Set timeout for 15m."
          setTimeout ->
            process last_id, complete_cb
          , 15 * 60000  # 15 minutes
        else
          throw err if err  # Uknown error
      else
        # if no tweet in last request
        if not last_id
          console.log "Done. For account #{account}"
          finish()
        else
          process last_id, complete_cb

    # Star recursive sycle
    process null, complete_cb

  , ->
    process.exit()