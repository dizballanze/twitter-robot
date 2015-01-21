Twit = require("twit")


has_stopwords = (word, stopwords) ->
  return false  unless stopwords.length
  lower_word = word.toLowerCase()
  for i of stopwords
    return true  unless lower_word.indexOf(stopwords[i]) is -1
  false

exports.start_bot = (Config)->
  console.log "In debug mode."  if Config.debug
  Config.accounts.forEach (conf)->
      T = new Twit
        consumer_key: conf.consumer_key
        consumer_secret: conf.consumer_secret
        access_token: conf.access_token
        access_token_secret: conf.access_token_secret

      stream = T.stream "statuses/filter", track: conf.keywords.join(",")
      stream.on "tweet", (tweet) ->
        now = new Date()
        if conf.valid(tweet) and not has_stopwords(tweet.text, conf.stopwords)
          if not Config.debug
            T.post "favorites/create",
              id: tweet.id_str
            , (err, reply) ->
              if err
                # Ignore errors about reached limits
                console.log conf.name, err  unless err.statusCode is 429
              else
                console.log "[#{now.toJSON()}] ##{tweet.id} is favorited by #{conf.name}"

          else
            console.log "[#{now.toJSON()}] ##{tweet.id} is favorited by #{conf.name}"
        else
          console.log "[#{now.toJSON()}][##{conf.name}] INVALID: @#{tweet.user.screen_name} : #{tweet.text}"

      stream.on "warning", (item) ->
        console.log "WARNING [#{conf.name}]: #{item}"

      stream.on "disconnect", (item) ->
        console.log "Stream disconnected [#{conf.name}]."

      stream.on "connect", (item) ->
        console.log "Stream connected [#{conf.name}]."

      stream.on "reconnect", (item) ->
        console.log "Stream reconnected [#{conf.name}]."