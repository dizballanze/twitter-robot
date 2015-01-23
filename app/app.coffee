Twit = require 'twit'
Bot = require('./bot').Bot


exports.start_bots = (Config)->
  console.log 'In debug mode.'  if Config.debug
  Config.accounts.forEach (conf)->
      # Create bot instance
      if conf.bot_class
        bot_class = conf.bot_class
      else
        bot_class = Bot
      bot = new bot_class conf

      # Connect to Twitter API
      T = new Twit
        consumer_key: conf.consumer_key
        consumer_secret: conf.consumer_secret
        access_token: conf.access_token
        access_token_secret: conf.access_token_secret

      # Connect to tweets stream
      stream = T.stream 'statuses/filter', track: bot.get_keywords().join(',')
      stream.on 'tweet', (tweet) ->
        now = new Date()
        # Validate tweet
        bot.is_valid tweet, (err, is_valid)->
          throw err if err
          # If tweet is not valid
          unless is_valid
            return console.log "[#{now.toJSON()}][##{conf.name}] INVALID: @#{tweet.user.screen_name} : #{tweet.text}"
          # Just write message to console if debug mode is on
          if Config.debug
            return console.log "[#{now.toJSON()}] ##{tweet.id} is favorited by #{conf.name}"
          # Actually process tweet
          T.post 'favorites/create',
            id: tweet.id_str
          , (err, reply) ->
            if err
              console.log conf.name, err  unless err.statusCode is 429  # Ignore errors about reached limits
            else
              console.log "[#{now.toJSON()}] ##{tweet.id} is favorited by #{conf.name}"
              # Process tweet
              bot.process tweet

      stream.on 'warning', (item) -> console.log "WARNING [#{conf.name}]: #{item}"
      stream.on 'disconnect', (item) -> console.log "Stream disconnected [#{conf.name}]."
      stream.on 'connect', (item) -> console.log "Stream connected [#{conf.name}]."
      stream.on 'reconnect', (item) -> console.log "Stream reconnected [#{conf.name}]."