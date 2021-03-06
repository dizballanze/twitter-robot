Twit = require 'twit'
seqqueue = require 'seq-queue'
Bot = require('./bot').Bot


exports.start_bots = (Config)->
  console.log 'In debug mode.'  if Config.debug
  Config.accounts.forEach (conf)->
      queue = seqqueue.createQueue 3000
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

      # Twitter filter_level
      if conf.filter_level in ['none', 'low', 'medium']
        filter_level = conf.filter_level
      else
        filter_level = 'none'
      # Connect to tweets stream
      stream = T.stream 'statuses/filter', {track: bot.get_keywords().join(','), filter_level: filter_level}
      stream.on 'tweet', (tweet) ->
        queue.push (task)->
          now = new Date()
          # Validate tweet
          bot.is_valid tweet, (err, is_valid, reason)->
            throw err if err
            # If tweet is not valid
            unless is_valid
              task.done()
              return console.log "[#{now.toJSON()}][##{conf.name}] INVALID: #{reason} @#{tweet.user.screen_name} : #{tweet.text}"
            # Just write message to console if debug mode is on
            if Config.debug
              task.done()
              return console.log "[#{now.toJSON()}] ##{tweet.id} is favorited by #{conf.name}"
            # Actually process tweet
            T.post 'favorites/create',
              id: tweet.id_str
            , (err, reply) ->
              if err
                console.log conf.name, err
                console.log conf.name, err  unless err.statusCode is 429  # Ignore errors about reached limits
                task.done()
              else
                console.log "[#{now.toJSON()}] ##{tweet.id} is favorited by #{conf.name}"
                # Process tweet
                bot.process tweet, task.done

      stream.on 'warning', (item) -> console.log "WARNING [#{conf.name}]: #{item}"
      stream.on 'disconnect', (item) -> console.log "Stream disconnected [#{conf.name}]."
      stream.on 'connect', (item) -> console.log "Stream connected [#{conf.name}]."
      stream.on 'reconnect', (item) -> console.log "Stream reconnected [#{conf.name}]."